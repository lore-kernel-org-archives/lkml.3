Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaDWBlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:41:13 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:46365 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750925AbaDWBlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:41:11 -0400
X-IronPort-AV: E=Sophos;i="4.97,907,1389715200"; 
   d="scan'208";a="29600954"
Message-ID: <53571B1B.1060505@cn.fujitsu.com>
Date: Wed, 23 Apr 2014 09:44:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>
Subject: Re: [PATCH 3/4] ida: in-place ida allocation
References: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com> <1398161781-12105-4-git-send-email-laijs@cn.fujitsu.com> <20140422200221.GC2314@mtj.dyndns.org>
In-Reply-To: <20140422200221.GC2314@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 04:02 AM, Tejun Heo wrote:
> On Tue, Apr 22, 2014 at 06:16:20PM +0800, Lai Jiangshan wrote:
>> There are two stages of ida allocation/free, idr_layers and ida_bitmap.
>> They add unneeded foot print and memory waste.
>>
>> When a single ID is first allocated from an ida, this ida requires
>> two big chunks of memory. One idr_layer and one ida_bitmap.
>>
>> To reduce the foot print and memory, we reduce the ida_bitmap
>> to a single "unsigned long" and place it in its own idr-slot
>> and avoid to allocate the ida_bitmap.
>>
>> It also means ida bitmap is located on its coresponding idr-slot
>> which size is the same as "unsigned long".
>> Each ida bitmap(idr-slot) contains BITS_PER_LONG ida-slots.
>>
>> The struct ida_bitmap is not needed any more, we use "unsigned long"
>> directly and remove all the code of alloc/free struct ida_bitmap.
> 
> Are you calling 128 byte a "big chunk of memory" while trading off
> tree depth for it?  No, this level of space optimizaiton is completely
> uncalled for.

I reduce the depth, you forgot that struct ida_bitmap is an additional
depth which is removed in the patch.

> 
>  Nacked-by: Tejun Heo <tj@kernel.org>
> 
> Thanks.
> 

