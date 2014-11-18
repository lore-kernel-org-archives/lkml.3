Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaKROdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:33:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:39426 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbaKROdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:33:03 -0500
Date: Tue, 18 Nov 2014 15:32:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback
 irq_chip.irq_write_msi_msg
In-Reply-To: <546B5635.6020806@huawei.com>
Message-ID: <alpine.DEB.2.11.1411181526220.3909@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com> <546B4F18.5060705@huawei.com>
 <546B51BA.6070806@linux.intel.com> <546B5635.6020806@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:

Can you please trim the messages when you're replying?

> The above you described is absolutely right, but not the things I want
> to know. :)
> Take GICv3 ITS for example, it deals with both PCI and non PCI message
> interrupts. IIUC, several irq_chips need to be implemented in the ITS
> driver (i.e. pci_msi_chip, A_msi_chip and B_msi_chip). What should we
> do to the ITS driver if new MSI-capable devices come out?

You seem to miss the stacking here

PCI-MSI	->
A-MSI	->   ITS  -> GIC
B-MSI	->

So each of the device types has its own MSI controller. Each of them
will have their own callbacks and are backed by the underlying ITS/GIC
implementation.

And that's the only sensible solution.

Thanks,

	tglx
