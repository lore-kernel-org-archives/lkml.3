Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbbAPTtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:49:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36503 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbbAPTtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:49:06 -0500
Date: Fri, 16 Jan 2015 20:48:31 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ray Jui <rjui@broadcom.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
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
Subject: Re: [PATCH v4 3/3] ARM: dts: add I2C device nodes for Broadcom Cygnus
Message-ID: <20150116194831.GV22880@pengutronix.de>
References: <rjui@broadcom.com>
 <1421274213-3544-1-git-send-email-rjui@broadcom.com>
 <1421274213-3544-4-git-send-email-rjui@broadcom.com>
 <20150115084456.GO22880@pengutronix.de>
 <54B96559.1010007@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B96559.1010007@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 16, 2015 at 11:24:09AM -0800, Ray Jui wrote:
> >> +	i2c0: i2c@18008000 {
> >> +		compatible = "brcm,iproc-i2c";
> > in patch 2 you wrote the driver is for a family of SoCs, right? Then I'd
> > make this:
> > 
> > 	compatible = "brcm,$mysoc-iproc-i2c", "brcm,iproc-i2c";
> > 
> Sorry could you please help to explain the intention here? Note the
> iProc I2C IP can be found in various iProc family of SoCs, but to my
> best knowledge, there hasn't been any changes of the IP in any of those
> SoCs.
This is just for making the device tree stable in the future. Consider
your gentle hardware engineers "fix" a small issue for the next
generation iproc SoC "pony" that needs an incompatible software change.

Then you can fix the driver without updating the device trees by
switching to the SoC specific compatible string for "pony". And in case
the hardware engineers didn't tell you that there is a change and the
need for the software change is only detected when the machines are
already shipped, you're happy if you can fix your kernel without needing
to change the bootloader that provides the dtb.
So start already today to add the (for now unused) compatible string.

> Is the compatible ID "brcm,$mysoc-iproc-i2c" only to clarify that it's
> for a specific SoC? If so, what should the compatible ID array look
> like? Should it be changed to the following?
> 
> static const struct of_device_id bcm_iproc_i2c_of_match[] = {
> 	{ .compatible = "brcm,iproc-i2c" },
> 	{ .compatible = "brcm,$mysoc-iproc-i2c" },
> 	{},
> };
No, there is no need, see above.

If something is still unclear, don't hesitate to ask.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
