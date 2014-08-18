Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaHRNSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:18:34 -0400
Received: from smtprelay0042.hostedemail.com ([216.40.44.42]:59898 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751391AbaHRNSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:18:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3870:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4184:4321:4605:5007:6117:6248:7652:7903:9025:9388:10004:10049:10400:10848:11026:11232:11657:11658:11914:12043:12295:12296:12517:12519:12555:12740:12776:13019:13069:13095:13311:13357:14106:14107:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brain20_844ad36d42433
X-Filterd-Recvd-Size: 2330
Message-ID: <1408367905.5871.5.camel@joe-AO725>
Subject: Re: checkpatch.pl: Use of extern in function prototype
From: Joe Perches <joe@perches.com>
To: Arun Chandran <achandran@mvista.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Geoff Levand <geoff@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Date: Mon, 18 Aug 2014 06:18:25 -0700
In-Reply-To: <CAFdej00nLYi__6STxb7wMGXR9iCSYF-VBFc9DjjYo3_rwYnm7Q@mail.gmail.com>
References: <CAFdej00nLYi__6STxb7wMGXR9iCSYF-VBFc9DjjYo3_rwYnm7Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-18 at 15:09 +0530, Arun Chandran wrote:
> Hi,
> 
> I have a piece of code as shown below.
> 
> #######################
> diff --git a/arch/arm64/include/asm/proc-fns.h
> b/arch/arm64/include/asm/proc-fns.h
> index 9a8fd84..86be4f9 100644
> --- a/arch/arm64/include/asm/proc-fns.h
> +++ b/arch/arm64/include/asm/proc-fns.h
> @@ -32,7 +32,7 @@ extern void cpu_cache_off(void);
>  extern void cpu_do_idle(void);
>  extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
>  extern void cpu_reset(unsigned long addr) __attribute__((noreturn));
> +extern void cpu_soft_restart(phys_addr_t cpu_reset,
>                 unsigned long addr) __attribute__((noreturn));
>  extern void cpu_do_suspend(struct cpu_suspend_ctx *ptr);
>  extern u64 cpu_do_resume(phys_addr_t ptr, u64 idmap_ttbr);
> ########################
> 
> Other lines had an "extern" in them I also added it blindly.
> when the above code is given checkpatch.pl did not throw any
> error/warning,; but I got this reply
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/279691.html
> 
> [[As the functions have external linkage by default, the extern keyword is
> irrelevant in this case.]]
> 
> Does checkpatch.pl misbehave in my case?

checkpatch's "unnecessary extern" message is somewhat controversial.

It requires the use of "--strict" on the command line.



