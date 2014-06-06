Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaFFEXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 00:23:18 -0400
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:32782 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750727AbaFFEXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 00:23:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1461:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3873:4321:5007:7652:10004:10400:10848:11026:11473:11658:11914:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNS
X-HE-Tag: pain99_5653d21ec974a
X-Filterd-Recvd-Size: 1785
Message-ID: <1402028592.3038.4.camel@joe-AO725>
Subject: Re: [PATCH v2] ARM: fix debug prints relevant to PCI devices
From: Joe Perches <joe@perches.com>
To: Vidya Sagar <vidyas@nvidia.com>
Cc: linux@arm.linux.org.uk, bhelgaas@google.com, wangyijing@huawei.com,
        thierry.reding@gmail.com, jason@lakedaemon.net, will.deacon@arm.com,
        swarren@nvidia.com, kthota@nvidia.com, sagar.tv@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Jun 2014 21:23:12 -0700
In-Reply-To: <1401994068-820-1-git-send-email-vidyas@nvidia.com>
References: <1401994068-820-1-git-send-email-vidyas@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 00:17 +0530, Vidya Sagar wrote:
> * replaced printk with pr_info
[]
> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
[]
> @@ -354,9 +357,11 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>  
>  	/*
>  	 * Report what we did for this bus
> +	 * (only if the bus doesn't have even one PCIe device)
>  	 */
> -	printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
> -		bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
> +	if (!has_pcie_dev)
> +		pr_info(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
> +			bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");

when you convert to pr_<level> you need to remove the
KERN_<LEVEL> from the format string too.


