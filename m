Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbbAGCIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:08:43 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:43834 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbbAGCIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:08:41 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/CycLtQqpuf26A+BgD4Fp+whAlQAKBZ7I=
X-DKIM: OpenDKIM Filter v2.0.1 titan 07B6F63EE6B
Date: Tue, 6 Jan 2015 21:08:14 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>, srv_heupstream@mediatek.com,
        hc.yen@mediatek.com, yh.chen@mediatek.com,
        linux-kernel@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>, nathan.chung@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, eddie.huang@mediatek.com,
        yingjoe.chen@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] irqchip: mediatek: Use IS_ERR() instead of NULL
 pointer check
Message-ID: <20150107020814.GA24989@titan.lakedaemon.net>
References: <1418050989-21411-1-git-send-email-yingjoe.chen@mediatek.com>
 <1418205302-22531-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418205302-22531-1-git-send-email-yingjoe.chen@mediatek.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yingjoe,

On Wed, Dec 10, 2014 at 05:55:02PM +0800, Yingjoe Chen wrote:
> Beniamino reported a kernel oops caused by an invalid DT file for the
> mediatek interrupt polarity extension.
> 
> The reason is that the interrupt polarity support for mediatek chips
> merely checks for NULL pointer instead of a casted error return
> value in mtk_sysirq_of_init() so any other casted error value passes
> the NULL pointer check and causes a kernel panic when dereferenced.
> 
> Use IS_ERR() and return the error value via PTR_ERR().
> 
> Reported-and-tested-by: Beniamino Galvani <b.galvani@gmail.com>
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> ---
>  drivers/irqchip/irq-mtk-sysirq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

I applied V2 to irqchip/urgent, and hand-added the changes from V3
because the email formatting was wrong.  I also tweaked the subject
line.

thx,

Jason.
