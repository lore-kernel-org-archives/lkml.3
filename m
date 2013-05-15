Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab3EOOUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:20:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759139Ab3EOOUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:20:43 -0400
Date: Wed, 15 May 2013 15:20:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: Zhang Yi <wetpzy@gmail.com>
Cc: linux-kernel@vger.kernel.org, "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Darren Hart'" <dvhart@linux.intel.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Ingo Molnar'" <mingo@kernel.org>, zhang.yi20@zte.com.cn
Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
Message-ID: <20130515142035.GD11497@suse.de>
References: <000101ce5174$1962bac0$4c283040$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <000101ce5174$1962bac0$4c283040$@com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 09:57:03PM +0800, Zhang Yi wrote:
> The futex-keys of processes share futex determined by page-offset,
> mapping-host, and mapping-index of the user space address. User
> appications using hugepage for futex may lead to futex-key conflict.
> 
> Assume there are two or more futexes in diffrent normal pages of the
> hugepage, and each futex has the same offset in its normal page,
> causing all the futexes have the same futex-key.
> 
> This patch adds the normal page index in the compound page into
> the pgoff of futex-key.
> 
> Steps to reproduce the bug:
> 1. The 1st thread map a file of hugetlbfs, and use the return address
> as the 1st mutex's address, and use the return address with PAGE_SIZE
> added as the 2nd mutex's address.
> 2. The 1st thread initialize the two mutexes with pshared attribute,
> and lock the two mutexes.
> 3. The 1st thread create the 2nd thread, and the 2nd thread block on
> the 1st mutex.
> 4. The 1st thread create the 3rd thread, and the 3rd thread block on
> the 2nd mutex.
> 5. The 1st thread unlock the 2nd mutex, the 3rd thread cannot take
> the 2nd mutex, and may block forever.
> 
> 
> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
> Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>
> Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
> Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
> Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
> 

Did all these people really review it? I just whinged about the last patch
and didn't put a Reviewed-by on it. That said, I don't actually have a
problem with this patch and I assumed it passed your testing so

Reviewed-by: Mel Gorman <mgorman@suse.de>

The others might not agree though.

I note the conversion from int offset to long offset in futex_key appears
to have gotten lost. Is that in a separate cleanup patch now?

-- 
Mel Gorman
SUSE Labs
