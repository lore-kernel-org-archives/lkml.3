Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbaKEQsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:48:06 -0500
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:49684 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751805AbaKEQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:48:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:4250:4321:5007:6261:6737:7974:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12296:12438:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: maid15_bad2ee4a8525
X-Filterd-Recvd-Size: 2033
Message-ID: <1415206078.6634.9.camel@perches.com>
Subject: Re: [tip:x86/apic] x86, irq: Replace printk(KERN_LVL) with pr_lvl()
 utilities
From: Joe Perches <joe@perches.com>
To: tglx@linutronix.de, benh@kernel.crashing.org, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, bp@alien8.de,
        rdunlap@infradead.org, konrad.wilk@oracle.com, hpa@zytor.com,
        tony.luck@intel.com, yinghai@kernel.org, bhelgaas@google.com,
        joro@8bytes.org, gregkh@linuxfoundation.org, rjw@rjwysocki.net
Cc: linux-tip-commits@vger.kernel.org
Date: Wed, 05 Nov 2014 08:47:58 -0800
In-Reply-To: <tip-4451646b745acafc89a88a17f09c6d0be4213161@git.kernel.org>
References: <1414397531-28254-11-git-send-email-jiang.liu@linux.intel.com>
	 <tip-4451646b745acafc89a88a17f09c6d0be4213161@git.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 08:37 -0800, tip-bot for Jiang Liu wrote:
> x86, irq: Replace printk(KERN_LVL) with pr_lvl() utilities
> 
> Replace printk(KENR_LVL) with pr_lvl() to keep checkpatch script silent.

This is actually a small behavioral change.

pr_debug is not quite the same as printk(KERN_DEBUG
pr_debug is not performed unless dynamic_debug is
enabled or a #define DEBUG is set.

> diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
[]
> @@ -504,28 +504,27 @@ static void __init print_local_APIC(void *dummy)
>  	unsigned int i, v, ver, maxlvt;
>  	u64 icr;
>  
> -	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
> -		smp_processor_id(), hard_smp_processor_id());
> +	pr_debug("printing local APIC contents on CPU#%d/%d:\n",
> +		 smp_processor_id(), hard_smp_processor_id());



