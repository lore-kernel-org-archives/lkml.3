Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbaJWDO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 23:14:58 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61432 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493AbaJWDO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 23:14:56 -0400
Date: Thu, 23 Oct 2014 12:14:43 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v4 7/8] regulator: sky81452: Add compatible
 string for device binding
Message-ID: <20141023031443.GA3244@jack-ThinkPad-T520>
References: <1413179262-27636-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141013103512.GJ27755@sirena.org.uk>
 <20141014011112.GB2751@jack-ThinkPad-T520>
 <20141014075606.GN27755@sirena.org.uk>
 <20141017091950.GA3233@jack-ThinkPad-T520>
 <20141017101734.GB1820@sirena.org.uk>
 <20141017104309.GA3136@jack-ThinkPad-T520>
 <20141017142605.GU1820@sirena.org.uk>
 <20141020061024.GA9406@jack-ThinkPad-T520>
 <20141022102723.GL2344@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141022102723.GL2344@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 11:27:23AM +0100, Mark Brown wrote:
> On Mon, Oct 20, 2014 at 03:10:24PM +0900, Gyungoh Yoo wrote:
> > On Fri, Oct 17, 2014 at 04:26:05PM +0200, Mark Brown wrote:
> 
> > > The thing I'm seeing is that the binding for your device with the
> > > subnode looks very much like the device trees of devices with multiple
> > > regulators.  The fact that you only have one regulator is a bit
> > > difference but not that much.  It seems like drivers should fit into one
> > > of two patterns: either the regulator is described in the root node for
> > > the device for single purpose devices or there should be a collection of
> > > regulators like is supported with this helper API.  Having a collection
> > > with only one node doesn't seem to be a problem in any way.
> 
> > Thank you for your kind comments.
> > My understanding is getting better.
> 
> > For my clear understanding:
> > I think the original designed which I wanted to design is similar
> > with arizona-ldo1.c
> > It seems that this is 1st pattern your explained above.
> > Can I ask what is different between arizona-ldo1.c and
> > this sky81452-regulator.c?
> > I think both are designed under root node.
> 
> Were that code being written today I'd probably be asking for it to use
> a regulators subnode to be consistent with everything else, it's a
> slightly older driver and sometimes we've not spotted the patterns when
> they're added, once we get to the point of adding the helpers as we have
> now things are definitely getting baked in.

I see. Thank you.

So, what do you think about DT like below?

sky81452@2c {
	compatible = "skyworks,sky81452";
	reg = <0x2c>;

	backlight {
		compatible = "skyworks,sky81452-backlight";
		name = "pwm-backlight";
		enable = <0x3F>;
		ignore-pwm;
	};

	regulator {
		compatible = "skyworks,sky81452-regulator";

		lout@0 {
			regulator-name = "LOUT";
			regulator-min-microvolt = <4500000>;
			regulator-max-microvolt = <8000000>;
		};
	};
};
