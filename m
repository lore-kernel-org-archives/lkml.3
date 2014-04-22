Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbaDVUC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:02:28 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:65363 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbaDVUCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:02:25 -0400
Date: Tue, 22 Apr 2014 16:02:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>
Subject: Re: [PATCH 3/4] ida: in-place ida allocation
Message-ID: <20140422200221.GC2314@mtj.dyndns.org>
References: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
 <1398161781-12105-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398161781-12105-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 06:16:20PM +0800, Lai Jiangshan wrote:
> There are two stages of ida allocation/free, idr_layers and ida_bitmap.
> They add unneeded foot print and memory waste.
> 
> When a single ID is first allocated from an ida, this ida requires
> two big chunks of memory. One idr_layer and one ida_bitmap.
> 
> To reduce the foot print and memory, we reduce the ida_bitmap
> to a single "unsigned long" and place it in its own idr-slot
> and avoid to allocate the ida_bitmap.
> 
> It also means ida bitmap is located on its coresponding idr-slot
> which size is the same as "unsigned long".
> Each ida bitmap(idr-slot) contains BITS_PER_LONG ida-slots.
> 
> The struct ida_bitmap is not needed any more, we use "unsigned long"
> directly and remove all the code of alloc/free struct ida_bitmap.

Are you calling 128 byte a "big chunk of memory" while trading off
tree depth for it?  No, this level of space optimizaiton is completely
uncalled for.

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
