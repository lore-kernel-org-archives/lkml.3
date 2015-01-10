Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbbAJX6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 18:58:40 -0500
Received: from mx1.scotdoyle.com ([23.226.141.211]:58503 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbbAJX6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 18:58:39 -0500
Date: Sat, 10 Jan 2015 23:57:04 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Joe Perches <joe@perches.com>, Steven Honeyman <stevenhoneyman@gmail.com>
cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/kernel/cpu/common.c: split log entry into
 logical components
In-Reply-To: <1420929338.16787.6.camel@perches.com>
Message-ID: <alpine.DEB.2.11.1501102345590.26282@localhost.localdomain>
References: <alpine.DEB.2.11.1501102203380.2303@localhost.localdomain> <1420929338.16787.6.camel@perches.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2015, Joe Perches wrote:

> On Sat, 2015-01-10 at 22:21 +0000, Scot Doyle wrote:
> > Call printk twice since this log entry has two lines and headings.
> > 
> > [    0.009285] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
> > Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
> > 
> > Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> > ---
> >  arch/x86/kernel/cpu/common.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index c604965..76f253f 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -496,12 +496,12 @@ void cpu_detect_tlb(struct cpuinfo_x86 *c)
> >  	if (this_cpu->c_detect_tlb)
> >  		this_cpu->c_detect_tlb(c);
> >  
> > -	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n"
> > -		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d, 1GB %d\n",
> > +	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n",
> >  		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
> > -		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
> > -		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES],
> > -		tlb_lld_1g[ENTRIES]);
> > +		tlb_lli_4m[ENTRIES]);
> > +	printk(KERN_INFO "Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d, 1GB %d\n",
> > +		tlb_lld_4k[ENTRIES], tlb_lld_2m[ENTRIES],
> > +		tlb_lld_4m[ENTRIES], tlb_lld_1g[ENTRIES]);
> >  }
> 
> Check your dmesg version
> 
> https://lkml.org/lkml/2014/11/1/67
> https://lkml.org/lkml/2014/11/2/1
> 

Thanks Joe.

Steven, are you planning to resubmit the patch as suggested by Borislav?
