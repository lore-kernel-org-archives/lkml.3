Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161574AbaKNRMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:12:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37048 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161282AbaKNRMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:12:12 -0500
Message-ID: <1415985069.4445.6.camel@pengutronix.de>
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
From: Lucas Stach <l.stach@pengutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yijing Wang <wangyijing@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 14 Nov 2014 18:11:09 +0100
In-Reply-To: <546627DD.2050200@arm.com>
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
	 <54651BE2.9080008@arm.com> <54654C10.2040102@linux.intel.com>
	 <54655632.2040209@huawei.com> <alpine.DEB.2.11.1411140211480.3935@nanos>
	 <54655D44.1070703@linux.intel.com> <54660D7F.70702@gmail.com>
	 <54661103.8000707@linux.intel.com> <54661CB8.2070704@arm.com>
	 <54661ED9.8090901@linux.intel.com> <546627DD.2050200@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 14.11.2014, 16:03 +0000 schrieb Marc Zyngier:
> On 14/11/14 15:25, Jiang Liu wrote:
> > On 2014/11/14 23:16, Marc Zyngier wrote:
> >> On 14/11/14 14:26, Jiang Liu wrote:
> >>> On 2014/11/14 22:11, Yijing Wang wrote:
> >>>>
> >>> We have achieved 1 and 2. And seems we could also achieve 3 by
> >>> converting all arch specific PCI MSI code to use hierarchy
> >>> irqdomain. But not sure whether we could achieve 4, not familiar
> >>> with ARM world:)
> >>
> >> Killing all the weak functions shouldn't be a problem for ARM, we're
> >> trying very hard not to rely on them.
> >>
> >> Killing msi_chip is a different story, as this is what we use to match a
> >> PCI host controller with its MSI controller (that's what the of_node
> >> field in msi_chip is for). See drivers/of/of_pci.c for details.
> >>
> >> Also, we use msi_chip directly in the MSI drivers as a way to go from a
> >> pci_dev to the MSI controller specific structure:
> >>
> >> http://git.kernel.org/cgit/linux/kernel/git/maz/arm-platforms.git/tree/drivers/irqchip/irq-gic-v3-its.c?h=irq/stacked-its-v2#n1143
> >>
> >> If we're going to kill msi_chip, we must make sure we have mechanisms
> >> that allow the conversion of the existing code.
> > Hi Marc,
> > 	Seem it doesn't worth the effort to remove irq_chip,
> > so I will focus on killing all weak functions first:)
> > After that, we may kill setup_irq and teardown_irq in irq_chip,
> > but seems irq_chip still has other usages, so I won't try to
> > kill irq_chip.
> 
> I assume you mean msi_chip! ;-)
> 
> Killing setup/teardown_irq is going to require some work. There are a
> few users in the tree (I can see three in drivers/pci/host and one in
> drivers/irqchip).
> 
> Hopefully, we can get the maintainers to convert them.
> 

I can help with both the Designware and Tegra host bridge drivers.

But that requires:
1. CCing patches to me, so I know what is going on
2. Providing good descriptions on what is done in the patchset and how
the msi_chip users should adjust

With all the MSI changes by various people going on in parallel it's
hard to follow for someone not looking at this stuff every day.

Regards,
Lucas

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

