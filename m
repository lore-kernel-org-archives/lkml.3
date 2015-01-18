Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbbARJsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 04:48:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47551 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbbARJsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 04:48:13 -0500
Date: Sun, 18 Jan 2015 10:47:41 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: Ray Jui <rjui@broadcom.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <mporter@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150118094741.GE22880@pengutronix.de>
References: <rjui@broadcom.com>
 <1421451737-7107-1-git-send-email-rjui@broadcom.com>
 <1421451737-7107-3-git-send-email-rjui@broadcom.com>
 <54BB795C.6040402@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BB795C.6040402@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 18, 2015 at 10:14:04AM +0100, Arend van Spriel wrote:
> On 01/17/15 00:42, Ray Jui wrote:
> 
> [...]
> 
> >+/*
> >+ * Can be expanded in the future if more interrupt status bits are utilized
> >+ */
> >+#define ISR_MASK (1<<  IS_M_START_BUSY_SHIFT)
> >+
> >+static irqreturn_t bcm_iproc_i2c_isr(int irq, void *data)
> >+{
> >+	struct bcm_iproc_i2c_dev *iproc_i2c = data;
> >+	u32 status = readl(iproc_i2c->base + IS_OFFSET);
> >+
> >+	status&= ISR_MASK;
> >+
> >+	if (!status)
> >+		return IRQ_NONE;
> >+
> >+	writel(status, iproc_i2c->base + IS_OFFSET);
> >+	complete_all(&iproc_i2c->done);
> 
> Looking over this code it seems to me there is always a single
> process waiting for iproc_i2c->done to complete. So using complete()
> here would suffice.
Yeah, there is always only a single thread waiting. That means both
complete and complete_all are suitable. AFAIK there is no reason to pick
one over the other in this case.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
