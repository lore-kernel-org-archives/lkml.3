Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbaLJUK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:10:56 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39439 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbaLJUKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:10:55 -0500
Date: Wed, 10 Dec 2014 21:08:05 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>
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
Message-ID: <20141210200805.GA17513@gmail.com>
References: <1418050989-21411-1-git-send-email-yingjoe.chen@mediatek.com>
 <1418205302-22531-1-git-send-email-yingjoe.chen@mediatek.com>
 <20141210121442.GA14485@gmail.com>
 <20141210125313.GJ22670@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210125313.GJ22670@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 07:53:13AM -0500, Jason Cooper wrote:
> On Wed, Dec 10, 2014 at 01:14:43PM +0100, Beniamino Galvani wrote:
> > On Wed, Dec 10, 2014 at 05:55:02PM +0800, Yingjoe Chen wrote:
> > > Beniamino reported a kernel oops caused by an invalid DT file for the
> > > mediatek interrupt polarity extension.
> > > 
> > > The reason is that the interrupt polarity support for mediatek chips
> > > merely checks for NULL pointer instead of a casted error return
> > > value in mtk_sysirq_of_init() so any other casted error value passes
> > > the NULL pointer check and causes a kernel panic when dereferenced.
> > > 
> > > Use IS_ERR() and return the error value via PTR_ERR().
> > > 
> > > Reported-and-tested-by: Beniamino Galvani <b.galvani@gmail.com>
> > 
> > Well, actually I only reported the bug and didn't do any test. Can the
> > "-and-tested" portion of the tag be dropped while applying the patch?
> 
> I'd prefer that it be tested before applying.  Would you mind confirming
> that the oops is gone with this patch applied?

Probably the commit message is misleading about this, but I don't own
any Mediatek device and never used the driver. I only reported [1] a
possible bug in the driver found through code analysis.

Anyway, I suppose that the tests done by Yingjoe are enough to get the
patch merged.

Beniamino

[1] https://lkml.org/lkml/2014/11/29/105
