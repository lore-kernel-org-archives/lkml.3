Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3JRNXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:23:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43141 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3JRNXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:23:03 -0400
Date: Fri, 18 Oct 2013 09:22:57 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Tim Kryger <tim.kryger@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christian Daudt <bcm@fixthebug.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "patches@linaro.org" <patches@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH v2 6/6] mmc: sdhci-bcm-kona: Add basic use of
 clocks
Message-ID: <20131018132257.GG2721@beef>
References: <1381960030-1640-1-git-send-email-tim.kryger@linaro.org>
 <1381960030-1640-7-git-send-email-tim.kryger@linaro.org>
 <20131017141309.GG24056@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017141309.GG24056@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 03:13:09PM +0100, Mark Rutland wrote:
> On Wed, Oct 16, 2013 at 10:47:10PM +0100, Tim Kryger wrote:
> > +	/* Get and enable the external clock */
> > +	kona_dev->external_clk = devm_clk_get(dev, NULL);
> > +	if (IS_ERR(kona_dev->external_clk)) {
> > +		dev_err(dev, "Failed to get external clock\n");
> > +		ret = PTR_ERR(kona_dev->external_clk);
> > +		goto err_pltfm_free;
> 
> This seems like a pretty clear breakage of existing DTBs.
> 
> Why?

Normal kernel incremental development. The notion of breaking DTBs is
pretty much incompatible with the long-standing tradition of developing
kernel support in an incremental fashion.

In this case, the bootloader available on these boards has had clocks
and regulators enabled for all the drivers currently upstream. This
allowed development of the sdhci driver (and others) independent of having
the common clk driver and PMU/regulator drivers ready. That's been especially
important given the flux that the common clk framework is in with regards
to bindings.

Are you suggesting that the required clock needs to be made logically
optional in the code to retain backward compatbility?

-Matt
