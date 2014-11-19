Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbaKSRuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:50:01 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33879 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaKSRuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:50:00 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hc.yen\@mediatek.com" <hc.yen@mediatek.com>,
        "srv_heupstream\@mediatek.com" <srv_heupstream@mediatek.com>,
        "yh.chen\@mediatek.com" <yh.chen@mediatek.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely\@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        "nathan.chung\@mediatek.com" <nathan.chung@mediatek.com>,
        "yingjoe.chen\@gmail.com" <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang\@mediatek.com" <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux- arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 3/4] ARM: mediatek: Add sysirq in mt6589/mt8135/mt8127 dtsi
In-Reply-To: <1416406451-4578-4-git-send-email-yingjoe.chen@mediatek.com>
	(Yingjoe Chen's message of "Wed, 19 Nov 2014 14:14:10 +0000")
Organization: ARM Ltd
References: <1416406451-4578-1-git-send-email-yingjoe.chen@mediatek.com>
	<1416406451-4578-4-git-send-email-yingjoe.chen@mediatek.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
Date: Wed, 19 Nov 2014 17:49:49 +0000
Message-ID: <87d28jaxmq.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19 2014 at  2:14:10 pm GMT, Yingjoe Chen <yingjoe.chen@mediatek.com> wrote:
> Add sysirq settings for mt6589/mt8135/mt8127
> This also correct timer interrupt flag. The old setting works
> because boot loader already set polarity for timer interrupt.
> Without intpol support, the setting was not changed so gic
> can get the irq correctly.
>
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> ---
>  arch/arm/boot/dts/mt6589.dtsi | 14 ++++++++++++--
>  arch/arm/boot/dts/mt8127.dtsi | 14 ++++++++++++--
>  arch/arm/boot/dts/mt8135.dtsi | 14 ++++++++++++--
>  3 files changed, 36 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/boot/dts/mt6589.dtsi b/arch/arm/boot/dts/mt6589.dtsi
> index e3c7600..c91b2a9 100644
> --- a/arch/arm/boot/dts/mt6589.dtsi
> +++ b/arch/arm/boot/dts/mt6589.dtsi
> @@ -19,7 +19,7 @@
>  
>  / {
>  	compatible = "mediatek,mt6589";
> -	interrupt-parent = <&gic>;
> +	interrupt-parent = <&sysirq>;

This worries me a bit. Your sysirq cannot handle PPIs, and yet you make
it the top-level interrupt controller, without amending any PPI.

Does it mean you do not use *any* PPI? No per-cpu timer, nothing?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
