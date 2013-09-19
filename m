Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3ISS24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:28:56 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57843 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3ISS2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:28:54 -0400
Date: Thu, 19 Sep 2013 11:28:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [RFC PATCH 5/6] extcon-gpio: Describe devicetree bindings
Message-ID: <20130919182850.GA22775@roeck-us.net>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-6-git-send-email-linux@roeck-us.net>
 <20130912164100.GF22013@e106331-lin.cambridge.arm.com>
 <20130912165304.GA12202@roeck-us.net>
 <20130916142147.GF30650@e106331-lin.cambridge.arm.com>
 <20130916151953.GA5801@roeck-us.net>
 <20130918153828.GB17453@e106331-lin.cambridge.arm.com>
 <20130919164245.GG21013@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919164245.GG21013@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 05:42:45PM +0100, Mark Brown wrote:
> On Wed, Sep 18, 2013 at 04:38:28PM +0100, Mark Rutland wrote:
> > On Mon, Sep 16, 2013 at 04:19:53PM +0100, Guenter Roeck wrote:
> 
> > > I think what you are saying is that describing a generic connector via
> > > devicetree is not acceptable, even though it _does_ describe hardware.
> > > I would have to describe a specific connector for a specific hardware
> > > instead, which in turn would need its own driver. Is that correct ?
> 
> > Regardless of how the connector is described, the block of hardware it
> > connects to will have to be described, and some description of the
> > connector will be necessary (either in the node for the block, or by
> > phandle to a node for the connector). I agree that having a combined IP
> > block + connector driver for each permutation is not good.
> 
> Many of the things described only have passive components attached, or
> things that otherwise don't need drivers - things like power inputs or
> headphone connectors, they're mainly providing information to allow
> userspace to behave differently (eg, display a charging indicator in the
> UI).  It's not 100% true but by and by large if detection is being done
> using a GPIO it's probably something like that.

Correct. However, gpio based 'detect' pins typically need debounce support
which is not directly available through the gpio userspace API. I tried to add
that earlier, but was told to use extcon instead as it provides the necessary
infrastructure. Now it almost looks like I can not use it either because the
required devicetree bindings may be considered unacceptable.

Guenter
