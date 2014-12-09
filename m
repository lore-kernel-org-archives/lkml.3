Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbaLIGLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:11:36 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:35064 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751009AbaLIGLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:11:34 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH] irqchip: mediatek: Fix error return code detection
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Beniamino Galvani <b.galvani@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, <srv_heupstream@mediatek.com>,
        <hc.yen@mediatek.com>, <yh.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <nathan.chung@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, <eddie.huang@mediatek.com>,
        <yingjoe.chen@gmail.com>, <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <alpine.DEB.2.11.1412082114340.16275@nanos>
References: <1418050989-21411-1-git-send-email-yingjoe.chen@mediatek.com>
	 <alpine.DEB.2.11.1412082114340.16275@nanos>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 9 Dec 2014 14:11:29 +0800
Message-ID: <1418105489.32622.11.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-08 at 21:30 +0100, Thomas Gleixner wrote:
> On Mon, 8 Dec 2014, Yingjoe Chen wrote:
> 
> > This fix an error handling bug reported by Beniamino, this is based on
> > mtk intpol patches [1]
> >
> > Joe.C
> > 
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305808.html
> > 
> > ====================
> > of_io_request_and_map() return ERR_PTR wrapped error code instead of
> > NULL when fail, fix code in mtk_sysirq_of_init() to correctly handle
> > this.
> > 
> > Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> 
> This is not a proper changelog. Let me write up a proper one:
> 
> Subject: irqchip: mediatek: Use IS_ERR() instead of NULL pointer check
> 
> Beniamino reported a kernel oops caused by an invalid DT file for the
> mediatek interrupt polarity extension.
> 
> The reason is that the interrupt polarity support for mediatek chips
> merily checks for at NULL pointer instead of a casted error return
> value in mtk_sysirq_of_init() so any other casted error value passes
> the NULL pointer check and causes a kernel panic when dereferenced.
> 
> Use IS_ERR() and return the error value via PTR_ERR().
> 
> Reported-and-tested-by: Beniamino Galvani <b.galvani@gmail.com>
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> 
> Can you see the difference?
> 
> Thanks,
> 
> 	tglx

Thanks for the review.

This changelog describe issue and why we need this change more clearly.
I'll prepare a new patch with this changelog, Thanks.

Joe.C


