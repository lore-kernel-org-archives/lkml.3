Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaLODho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:37:44 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:52886 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbaLODhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:37:41 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v2 1/2] watchdog: Add driver for Mediatek watchdog
From: Eddie Huang <eddie.huang@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: <wim@iguana.be>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>, <heiko@sntech.de>,
        <yingjoe.chen@gmail.com>, <linux-kernel@vger.kernel.org>,
        <ibanezchen@gmail.com>, <greta.zhang@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-watchdog@vger.kernel.org>
In-Reply-To: <1418395859-32209-2-git-send-email-matthias.bgg@gmail.com>
References: <1418395859-32209-1-git-send-email-matthias.bgg@gmail.com>
	 <1418395859-32209-2-git-send-email-matthias.bgg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Dec 2014 11:37:31 +0800
Message-ID: <1418614651.18671.3.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2014-12-12 at 15:50 +0100, Matthias Brugger wrote:
> This patch adds a driver for the Mediatek SoC integrated
> watchdog. This driver supports watchdog and software reset
> for mt65xx and mt81xx SoCs.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

> +static int mtk_reset_handler(struct notifier_block *this, unsigned long mode,
> +				void *cmd)
> +{
> +	struct mtk_wdt_dev *mtk_wdt = container_of(this,
> +						       struct mtk_wdt_dev,
> +						       restart_handler);
> +	void __iomem *wdt_base = mtk_wdt->wdt_base;
> +	u32 reg;
> +
> +	/* Reset system */
> +	writel(WDT_SWRST_KEY, wdt_base + WDT_SWRST);
> +
> +	while (1) {
> +		mdelay(5);
> +		writel(WDT_SWRST_KEY, wdt_base + WDT_SWRST);
> +	}
> +	return NOTIFY_DONE;
> +
> +}

Build warning
../drivers/watchdog/mtk_wdt.c:78:6: warning: unused variable
'reg' [-Wunused-variable]

