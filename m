Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbaKARR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 13:17:58 -0400
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:33932 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751981AbaKARR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 13:17:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:3870:3873:4321:5007:6119:6261:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twig84_27f3637ceb92d
X-Filterd-Recvd-Size: 1851
Message-ID: <1414862273.31550.4.camel@perches.com>
Subject: Re: [PATCH] x86, cpu: trivial printk formatting fixes
From: Joe Perches <joe@perches.com>
To: Steven Honeyman <stevenhoneyman@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <trivial@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Nov 2014 10:17:53 -0700
In-Reply-To: <1414856696-8094-1-git-send-email-stevenhoneyman@gmail.com>
References: <1414856696-8094-1-git-send-email-stevenhoneyman@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-01 at 15:44 +0000, Steven Honeyman wrote:
> A 2 line printk makes dmesg output messy, because the second line does not get a timestamp.
> For example:
[]
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
[]
> @@ -487,10 +487,8 @@ static void init_intel(struct cpuinfo_x86 *c)
>  
>  		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
>  		if ((epb & 0xF) == ENERGY_PERF_BIAS_PERFORMANCE) {
> -			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
> -				" Set to 'normal', was 'performance'\n"
> -				"ENERGY_PERF_BIAS: View and update with"
> -				" x86_energy_perf_policy(8)\n");
> +			pr_info_once("ENERGY_PERF_BIAS: Set to 'normal', was 'performance'\n");
> +			pr_info_once("ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)\n");

This changes the logging level.

You should either mention why in the changelog
or use pr_warn_once


