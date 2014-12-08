Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaLHUa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:30:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:45236 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaLHUa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:30:58 -0500
Date: Mon, 8 Dec 2014 21:30:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
cc: Beniamino Galvani <b.galvani@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, srv_heupstream@mediatek.com,
        hc.yen@mediatek.com, yh.chen@mediatek.com,
        linux-kernel@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>, nathan.chung@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, eddie.huang@mediatek.com,
        yingjoe.chen@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: mediatek: Fix error return code detection
In-Reply-To: <1418050989-21411-1-git-send-email-yingjoe.chen@mediatek.com>
Message-ID: <alpine.DEB.2.11.1412082114340.16275@nanos>
References: <1418050989-21411-1-git-send-email-yingjoe.chen@mediatek.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014, Yingjoe Chen wrote:

> This fix an error handling bug reported by Beniamino, this is based on
> mtk intpol patches [1]
>
> Joe.C
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305808.html
> 
> ====================
> of_io_request_and_map() return ERR_PTR wrapped error code instead of
> NULL when fail, fix code in mtk_sysirq_of_init() to correctly handle
> this.
> 
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>

This is not a proper changelog. Let me write up a proper one:

Subject: irqchip: mediatek: Use IS_ERR() instead of NULL pointer check

Beniamino reported a kernel oops caused by an invalid DT file for the
mediatek interrupt polarity extension.

The reason is that the interrupt polarity support for mediatek chips
merily checks for at NULL pointer instead of a casted error return
value in mtk_sysirq_of_init() so any other casted error value passes
the NULL pointer check and causes a kernel panic when dereferenced.

Use IS_ERR() and return the error value via PTR_ERR().

Reported-and-tested-by: Beniamino Galvani <b.galvani@gmail.com>
Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>

Can you see the difference?

Thanks,

	tglx
