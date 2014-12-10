Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaLJMxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:53:42 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62651 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753089AbaLJMxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:53:41 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19J4F62b+gqcJY2ZetcfOnEgpEYqO5Z47o=
X-DKIM: OpenDKIM Filter v2.0.1 titan 024C462E196
Date: Wed, 10 Dec 2014 07:53:13 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>, srv_heupstream@mediatek.com,
        hc.yen@mediatek.com, yh.chen@mediatek.com,
        linux-kernel@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>, nathan.chung@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, eddie.huang@mediatek.com,
        yingjoe.chen@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] irqchip: mediatek: Use IS_ERR() instead of NULL
 pointer check
Message-ID: <20141210125313.GJ22670@titan.lakedaemon.net>
References: <1418050989-21411-1-git-send-email-yingjoe.chen@mediatek.com>
 <1418205302-22531-1-git-send-email-yingjoe.chen@mediatek.com>
 <20141210121442.GA14485@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210121442.GA14485@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 01:14:43PM +0100, Beniamino Galvani wrote:
> On Wed, Dec 10, 2014 at 05:55:02PM +0800, Yingjoe Chen wrote:
> > Beniamino reported a kernel oops caused by an invalid DT file for the
> > mediatek interrupt polarity extension.
> > 
> > The reason is that the interrupt polarity support for mediatek chips
> > merely checks for NULL pointer instead of a casted error return
> > value in mtk_sysirq_of_init() so any other casted error value passes
> > the NULL pointer check and causes a kernel panic when dereferenced.
> > 
> > Use IS_ERR() and return the error value via PTR_ERR().
> > 
> > Reported-and-tested-by: Beniamino Galvani <b.galvani@gmail.com>
> 
> Well, actually I only reported the bug and didn't do any test. Can the
> "-and-tested" portion of the tag be dropped while applying the patch?

I'd prefer that it be tested before applying.  Would you mind confirming
that the oops is gone with this patch applied?

thx,

Jason.
