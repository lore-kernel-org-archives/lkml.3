Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbaKMVL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:11:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:49259 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154AbaKMVLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:11:54 -0500
Date: Thu, 13 Nov 2014 22:11:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
In-Reply-To: <54651BE2.9080008@arm.com>
Message-ID: <alpine.DEB.2.11.1411132207470.3935@nanos>
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <54651BE2.9080008@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Marc Zyngier wrote:
> With the new stacked irq domains, it becomes pretty tempting
> to allocate an MSI domain per PCI bus, which would remove
> the requirement of either relying on arch-specific code, or
> a default PCI MSI domain.

Right. That's what I roughly had in mind. And that would solve the
multi-iommu issue on x86 nicely as well. We establish the association
at the time where the bus gets populated. So the whole lookup magic
simply goes away.

Thanks,

	tglx

 
