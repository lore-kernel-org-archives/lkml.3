Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaDRRRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:17:22 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:44885 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDRRRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:17:20 -0400
Date: Fri, 18 Apr 2014 13:17:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 6/8] idr: avoid ping-pong
Message-ID: <20140418171717.GE23576@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397825404-12039-7-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397825404-12039-7-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:49:53PM +0800, Lai Jiangshan wrote:
> The ida callers always calls ida_pre_get() before ida_get_new*().
> ida_pre_get() will do layer allocation, and ida_get_new*() will do layer removal.
> 
> It causes an unneeded ping-pong. The speculative layer removal in
> ida_get_new*() can't result expected optimization.
> 
> So we remove the unneeded layer removal in ida_get_new*().

But the as comment says, ida doesn't want to keep extra layers around
as it wants to keep its memory footprint minimal.  I think the right
thing to do is implementing ida_preload() which is simliar to
idr_preload() and do away with per-ida layer cache.

Thanks.

-- 
tejun
