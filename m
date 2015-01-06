Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbbAFJRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:17:13 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:58383 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751549AbbAFJRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:17:09 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 4/5] ARM: mediatek: Add EINT support to MTK pinctrl
 driver.
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>, <maoguang.meng@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>, <alan.cheng@mediatek.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>, <toby.liu@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <dandan.he@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>, <srv_heupstream@mediatek.com>,
        <linux-kernel@vger.kernel.org>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1418807365.6443.17.camel@mtksdaap41>
References: <1418772873-19747-1-git-send-email-hongzhou.yang@mediatek.com>
	 <1418772873-19747-5-git-send-email-hongzhou.yang@mediatek.com>
	 <1418807365.6443.17.camel@mtksdaap41>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 6 Jan 2015 17:16:57 +0800
Message-ID: <1420535817.17567.10.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 17:09 +0800, Yingjoe Chen wrote:
> On Wed, 2014-12-17 at 07:34 +0800, Hongzhou Yang wrote:
> > From: Maoguang Meng <maoguang.meng@mediatek.com>
> > 
> > MTK SoC support external interrupt(EINT) from most SoC pins.
> > Add EINT support to pinctrl driver.
> > 
> > Signed-off-by: Maoguang Meng <maoguang.meng@mediatek.com>
> > Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>
> 
> Hi Linus,
> 
> This patch add EINT support to the pinctrl driver. We've surveyed
> GPIOLIB_IRQCHIP, but we didn't use it because:
> 
> - Not every GPIO pin support interrupt.
> - EINT use a different numbering to GPIO. eg, from the mt8135 table,
> GPIO29 is EINT158. It is more nature & efficient to use EINT number as
> hwirq.
> 
> +               MTK_EINT_FUNCTION(2, 158),
> +               MTK_FUNCTION(0, "GPIO29"),


Hi Linus,

After further looking into this, we could use GPIOLIB_IRQCHIP if we add
an extension gpiochip_irqchip_add() to accept interrupt numbers and
custom .to_irq function for our SoC. We could still reuse other code
GPIOLIB_IRQCHIP provide.

Please let me know what you think about this idea.
Thanks.

Joe.C



