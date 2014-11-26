Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaKZIIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:08:49 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25757 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751764AbaKZIIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:08:48 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+3mYtcgz7c7/z2iJs9ddjGqky8GLsiT3c=
X-DKIM: OpenDKIM Filter v2.0.1 titan B6CD262434D
Date: Wed, 26 Nov 2014 03:08:19 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        devicetree@vger.kernel.org, hc.yen@mediatek.com,
        srv_heupstream@mediatek.com, yh.chen@mediatek.com,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        nathan.chung@mediatek.com, yingjoe.chen@gmail.com,
        Matthias Brugger <matthias.bgg@gmail.com>, eddie.huang@mediatek.com,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 0/4] ARM: mediatek: Add support for interrupt
 polarity
Message-ID: <20141126080819.GD22670@titan.lakedaemon.net>
References: <1416902662-19281-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416902662-19281-1-git-send-email-yingjoe.chen@mediatek.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yingjoe,

On Tue, Nov 25, 2014 at 04:04:18PM +0800, Yingjoe Chen wrote:
> This series is 8th version of interrupt polarity support for MediaTek SoCs.
> 
> I rebased previous version to latest tip/irq/irqdomain, and fix issues
> raised by Marc & Mark. The interrupt & irq free work fine on mt8135 board.
> 
> Simplified block diagram for interrupt on my system:
> 
>     +-------+      +-------+
>  ---| SYSIRQ|------|ARM GIC|
>  ---|       |------|       |
>  ---|       |------|       |
>  ---|       |------|       |
>  ---|       |------|       |
>     +-------+      +-------+
> 
> In device tree, interrupt-parent for other devices is sysirq, child of gic.
> This describe HW better and allow device to specify polarity as it is sent
> by the device.
> 
> When using hierarchy irq domain, gic will use irq_domain_add_linear to
> create irqdomain and all interrupt numbers must come from device tree. My
> /proc/interrupts looks like this now:
> 
> # cat /proc/interrupts
>            CPU0
>  16:     149578  MT_SYSIRQ 113  mtk_timer
>  20:       1082  MT_SYSIRQ  54  serial
> 
> Changes in v8:
>  - Rebased to new tip/irq/irqdomain
>  - Update mediatek,sysirq.txt bindinds to document interrupt-cells format
>    and interrupt-parents
>  - Change interrupt-cells format check in mtk_sysirq.
>  - Minor coding style fix
> 
> Changes in v7:
>  - Discussed in [1]
>  - Rebased to tip/irq/irqdomain
>  - In mtk_sysirq_domain_alloc, use copy of irq_data to workaound of_node
>    check in gic_irq_domain_xlate.
> 
> Changes in v6:
>  - Discussed in [2]
>  - Rebased to tip/irq/irqdomain
> 
> Changes in v5:
>  - Discussed in [3]
>  - Fix bug on mt6589 reported by Matthias
>  - Fix bug for irq_find_mapping in irq_create_of_mapping
>  - Merge Marc's change to proper handle non-DT case in gic_init_bases
> 
> Changes in v4:
>  - Discussed in [4]
>  - Remove arm,hierarchy-irq-domain. When GIC is probed by DT, it will
> support hierarchy irqdomain.
> 
> Changes in v3:
>  - Discussed in [5]
>  - First implementation using hierarchy irqdomain
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/304119.html
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/302221.html
> [3] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/298161.html
> [4] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296911.html
> [5] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/293766.html
> 
> Yingjoe Chen (4):
>   irqchip: gic: Support hierarchy irq domain.
>   ARM: mediatek: Add sysirq interrupt polarity support
>   ARM: mediatek: Add sysirq in mt6589/mt8135/mt8127 dtsi
>   dt-bindings: add bindings for mediatek sysirq
> 
>  .../bindings/arm/mediatek/mediatek,sysirq.txt      |  28 ++++
>  arch/arm/boot/dts/mt6589.dtsi                      |  14 +-
>  arch/arm/boot/dts/mt8127.dtsi                      |  14 +-
>  arch/arm/boot/dts/mt8135.dtsi                      |  14 +-
>  drivers/irqchip/Kconfig                            |   1 +
>  drivers/irqchip/Makefile                           |   1 +
>  drivers/irqchip/irq-gic.c                          |  77 +++++++---
>  drivers/irqchip/irq-mtk-sysirq.c                   | 163 +++++++++++++++++++++
>  8 files changed, 282 insertions(+), 30 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
>  create mode 100644 drivers/irqchip/irq-mtk-sysirq.c

Patches 1, 2, and 4 applied to irqchip/core with a dependency on
tip/irq/irqdomain with a few small subject line tweaks.

thx,

Jason.
