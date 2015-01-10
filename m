Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbbAJWfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:35:44 -0500
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:35741 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751011AbbAJWfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:35:43 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2538:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3868:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6117:6261:6630:8660:8985:9025:10004:10400:10848:11026:11232:11657:11658:11914:12043:12517:12519:12555:12740:13018:13019:13069:13148:13230:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tooth62_3196459ec063a
X-Filterd-Recvd-Size: 2396
Message-ID: <1420929338.16787.6.camel@perches.com>
Subject: Re: [PATCH] arch/x86/kernel/cpu/common.c: split log entry into
 logical components
From: Joe Perches <joe@perches.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 10 Jan 2015 14:35:38 -0800
In-Reply-To: <alpine.DEB.2.11.1501102203380.2303@localhost.localdomain>
References: <alpine.DEB.2.11.1501102203380.2303@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-10 at 22:21 +0000, Scot Doyle wrote:
> Call printk twice since this log entry has two lines and headings.
> 
> [    0.009285] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
> Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
> 
> Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> ---
>  arch/x86/kernel/cpu/common.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index c604965..76f253f 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -496,12 +496,12 @@ void cpu_detect_tlb(struct cpuinfo_x86 *c)
>  	if (this_cpu->c_detect_tlb)
>  		this_cpu->c_detect_tlb(c);
>  
> -	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n"
> -		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d, 1GB %d\n",
> +	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n",
>  		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
> -		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
> -		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES],
> -		tlb_lld_1g[ENTRIES]);
> +		tlb_lli_4m[ENTRIES]);
> +	printk(KERN_INFO "Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d, 1GB %d\n",
> +		tlb_lld_4k[ENTRIES], tlb_lld_2m[ENTRIES],
> +		tlb_lld_4m[ENTRIES], tlb_lld_1g[ENTRIES]);
>  }

Check your dmesg version

https://lkml.org/lkml/2014/11/1/67
https://lkml.org/lkml/2014/11/2/1




