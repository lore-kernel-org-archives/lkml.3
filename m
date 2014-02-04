Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155AbaBDVQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:16:50 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:58050 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984AbaBDVQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:16:44 -0500
Date: Tue, 4 Feb 2014 16:16:38 -0500
From: Matt Porter <mporter@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] regulator: add bcm59056 pmu DT binding
Message-ID: <20140204211638.GA16179@beef>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-3-git-send-email-mporter@linaro.org>
 <20140204172309.GG22609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204172309.GG22609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 05:23:09PM +0000, Mark Brown wrote:
> On Tue, Feb 04, 2014 at 07:19:08AM -0500, Matt Porter wrote:
> > Add a DT binding for the BCM59056 PMU. The binding inherits from
> > the generic regulator bindings.
> 
> Is this really only a regulator - does the chip have no other functions?

It's your average multi-function device with other functions as you are
suspecting.  Buried in the the MFD driver comments is me admitting that
I need to split this into two bindings. The base device, "bcm59056" and
then "bcm59056-reg". So point noted, I'll updated with the appropriate
binding for each.

> > +- regulators: This is the list of child nodes that specify the regulator
> > +  initialization data for defined regulators.  Generic regulator bindings
> > +  are described in regulator/regulator.txt.
> 
> The regulators property should always be optional, the driver should be
> able to start up and read back the hardware state without any further
> configuration.

Ahh, ok. I will make it so.

Thanks,
Matt
