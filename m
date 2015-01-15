Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbbAOQdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:33:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37792 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbbAOQdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:33:06 -0500
Date: Thu, 15 Jan 2015 17:32:35 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150115163235.GQ22880@pengutronix.de>
References: <rjui@broadcom.com>
 <1421274213-3544-1-git-send-email-rjui@broadcom.com>
 <1421274213-3544-3-git-send-email-rjui@broadcom.com>
 <20150115084119.GN22880@pengutronix.de>
 <20150115120704.GB2549@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150115120704.GB2549@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 15, 2015 at 01:07:05PM +0100, Wolfram Sang wrote:
> > > +	iproc_i2c->msg = msg;
> > Can it happen that iproc_i2c->msg still holds an uncompleted message
> > here or is this serialized by the core? Wolfram? Either here something
> 
> We have per-adapter locks serializing transfers, if you mean that?
ok, so in the efm32 driver the if (ddata->msgs) condition in
efm32_i2c_master_xfer can never be true, right?

> > > +static int bcm_iproc_i2c_remove(struct platform_device *pdev)
> > > +{
> > > +	struct bcm_iproc_i2c_dev *iproc_i2c = platform_get_drvdata(pdev);
> > > +
> > > +	i2c_del_adapter(&iproc_i2c->adapter);
> > You need to free the irq before i2c_del_adapter.
> 
> One could also keep using devm_request_irq and disable all interrupts
> sources here?
calling devm_free_irq would work or writel(0, iproc_i2c->base +
IE_OFFSET) + synchronize_irq().

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
