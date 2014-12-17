Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaLQJJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:09:43 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:60548 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751257AbaLQJJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:09:40 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 4/5] ARM: mediatek: Add EINT support to MTK pinctrl
 driver.
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>, <srv_heupstream@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <linux-kernel@vger.kernel.org>, <alan.cheng@mediatek.com>,
        <maoguang.meng@mediatek.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>, <toby.liu@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, <dandan.he@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>
In-Reply-To: <1418772873-19747-5-git-send-email-hongzhou.yang@mediatek.com>
References: <1418772873-19747-1-git-send-email-hongzhou.yang@mediatek.com>
	 <1418772873-19747-5-git-send-email-hongzhou.yang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Dec 2014 17:09:25 +0800
Message-ID: <1418807365.6443.17.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 07:34 +0800, Hongzhou Yang wrote:
> From: Maoguang Meng <maoguang.meng@mediatek.com>
> 
> MTK SoC support external interrupt(EINT) from most SoC pins.
> Add EINT support to pinctrl driver.
> 
> Signed-off-by: Maoguang Meng <maoguang.meng@mediatek.com>
> Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>

Hi Linus,

This patch add EINT support to the pinctrl driver. We've surveyed
GPIOLIB_IRQCHIP, but we didn't use it because:

- Not every GPIO pin support interrupt.
- EINT use a different numbering to GPIO. eg, from the mt8135 table,
GPIO29 is EINT158. It is more nature & efficient to use EINT number as
hwirq.

+               MTK_EINT_FUNCTION(2, 158),
+               MTK_FUNCTION(0, "GPIO29"),

Joe.C



