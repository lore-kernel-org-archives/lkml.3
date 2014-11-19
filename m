Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaKSLLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:11:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:43991 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaKSLLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:11:19 -0500
Date: Wed, 19 Nov 2014 12:11:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: Marc Zyngier <marc.zyngier@arm.com>, Jiang Liu <jiang.liu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback
 irq_chip.irq_write_msi_msg
In-Reply-To: <546C1148.4080102@huawei.com>
Message-ID: <alpine.DEB.2.11.1411191209400.3909@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com> <546B4F18.5060705@huawei.com>
 <alpine.DEB.2.11.1411181518310.3909@nanos> <546B5904.6020200@huawei.com> <8761ece85x.fsf@approximate.cambridge.arm.com> <546C1148.4080102@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Yun Wu (Abel) wrote:
> On 2014/11/19 1:21, Marc Zyngier wrote:
> > This is why the framework gives you the opportunity to provide methods
> > that:
> > - compose the message
> > - program the message into the device
> > 
> > None of that has to be PCI specific, and gives you a clean
> > abstraction. The framework only gives you a number of shortcuts for PCI
> > MSI, because that's what most people care about.
> > 
> 
> Indeed, and I never said Jiang's patches don't work, I was just thinking
> that they were not that perfect.

But your magic extra layer of indirection is perfect? It's not, it
just violates sane layering in order to support braindead hardware
designs.

Thanks,

	tglx
