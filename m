Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaE0Eeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 00:34:50 -0400
Received: from mail1.windriver.com ([147.11.146.13]:34234 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaE0Ees (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 00:34:48 -0400
Date: Tue, 27 May 2014 12:34:33 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Li Zefan <lizefan@huawei.com>
CC: <ralf@linux-mips.org>, <huawei.libin@huawei.com>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>
Subject: Re: [PATCH V2] MIPS: change type of asid_cache to unsigned long
Message-ID: <20140527043433.GA16193@pek-yzhang-d1>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <1400650563-1033-1-git-send-email-yong.zhang@windriver.com>
 <5384119E.7010606@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5384119E.7010606@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [128.224.162.188]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 12:16:30PM +0800, Li Zefan wrote:
> I'm not quite happy about what happaned here. There's a story behind
> this patch.
> 
> One of our Huawei product encountered a bug, and they're using WindRiver4,
> so the kernel is 2.6.34.
> 
> Because they bought your licnece, they asked for your help, but
> you were reluctant on this issue, and the problem remained there
> for about one month.
> 
> At last they turned to us for help. We're the kernel department in
> Huawei, but maintaining this product kernel isn't our job. Still
> Li Bin devoted his time to analyzing this bug, and he did a great
> job.
> 
> Li Bin told the product team what was wrong and was about to send
> a fix for upstream kernel.

You have time to do that but you didn't.

> They told you our analysis for further
> confirmation,

So you realy didn't make the patch, right? Because you are not
sure the right fix.

> and you were so reluctant to help but so quick to
> send the fix.

We have responsed to you.

> 
> Li Bin never reported this bug, but he fixed it. It's a shame that
> you took the credit from us.

I just saw a bug report and ananysis. And I agreed and confirmed it's
a bug.

Thanks,
Yong





> 
> On 2014/5/21 13:36, Yong Zhang wrote:
> > asid_cache must be unsigned long otherwise on 64bit system
> > it will become 0 if the value in get_new_mmu_context()
> > reaches 0xffffffff and in the end the assumption of
> > ASID_FIRST_VERSION is not true anymore thus leads to
> > more dangerous things.
> > 
> 
> We should describe what problem this bug can lead to, which
> will help people who encounter the same problem and google it.
> 
> > Reported-by: libin <huawei.libin@huawei.com>
> > Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
> 
> Should mark the patch for stable trees. Though 2.6.34 is EOL,
> the fix should be backported to other kernels.
> 
> > ---
> > 
> > V2<-V1: Add the reporter.
> > 
> >  arch/mips/include/asm/cpu-info.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/mips/include/asm/cpu-info.h b/arch/mips/include/asm/cpu-info.h
> > index f6299be..ebcc2ed 100644
> > --- a/arch/mips/include/asm/cpu-info.h
> > +++ b/arch/mips/include/asm/cpu-info.h
> > @@ -40,7 +40,7 @@ struct cache_desc {
> >  
> >  struct cpuinfo_mips {
> >  	unsigned int		udelay_val;
> > -	unsigned int		asid_cache;
> > +	unsigned long		asid_cache;
> >  
> >  	/*
> >  	 * Capability and feature descriptor structure for MIPS CPU
> > 
