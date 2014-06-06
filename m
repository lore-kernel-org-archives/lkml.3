Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaFFFbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 01:31:04 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11584 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaFFFbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 01:31:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Jun 2014 22:22:56 -0700
From: Vidya Sagar <vidyas@nvidia.com>
To: Joe Perches <joe@perches.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "Stephen Warren" <swarren@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>,
        "sagar.tv@gmail.com" <sagar.tv@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 6 Jun 2014 11:00:32 +0530
Subject: RE: [PATCH v2] ARM: fix debug prints relevant to PCI devices
Thread-Topic: [PATCH v2] ARM: fix debug prints relevant to PCI devices
Thread-Index: Ac+BRsuQCdy2nOhWTUeNUB1Q1kCz2AAAZDWw
Message-ID: <113ACA888B71994BB56E5CF3704953486D6CE1E2DF@BGMAIL02.nvidia.com>
References: <1401994068-820-1-git-send-email-vidyas@nvidia.com>
 <1402028592.3038.4.camel@joe-AO725>
In-Reply-To: <1402028592.3038.4.camel@joe-AO725>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops... I missed it somehow. I'll post a new patch.

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Friday, June 06, 2014 9:53 AM
> To: Vidya Sagar
> Cc: linux@arm.linux.org.uk; bhelgaas@google.com;
> wangyijing@huawei.com; thierry.reding@gmail.com;
> jason@lakedaemon.net; will.deacon@arm.com; Stephen Warren; Krishna
> Thota; sagar.tv@gmail.com; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v2] ARM: fix debug prints relevant to PCI devices
> 
> On Fri, 2014-06-06 at 00:17 +0530, Vidya Sagar wrote:
> > * replaced printk with pr_info
> []
> > diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> []
> > @@ -354,9 +357,11 @@ void pcibios_fixup_bus(struct pci_bus *bus)
> >
> >  	/*
> >  	 * Report what we did for this bus
> > +	 * (only if the bus doesn't have even one PCIe device)
> >  	 */
> > -	printk(KERN_INFO "PCI: bus%d: Fast back to back transfers
> %sabled\n",
> > -		bus->number, (features & PCI_COMMAND_FAST_BACK) ?
> "en" : "dis");
> > +	if (!has_pcie_dev)
> > +		pr_info(KERN_INFO "PCI: bus%d: Fast back to back transfers
> %sabled\n",
> > +			bus->number, (features &
> PCI_COMMAND_FAST_BACK) ? "en" : "dis");
> 
> when you convert to pr_<level> you need to remove the KERN_<LEVEL>
> from the format string too.
> 

