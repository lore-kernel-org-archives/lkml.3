Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaAWMdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:33:52 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46373 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751686AbaAWMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:33:51 -0500
Date: Thu, 23 Jan 2014 12:33:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-pwm@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 2/2] pwm: imx: support polarity inversion
Message-ID: <20140123123341.GW15937@n2100.arm.linux.org.uk>
References: <1389859585-14006-1-git-send-email-LW@KARO-electronics.de> <1389859585-14006-3-git-send-email-LW@KARO-electronics.de> <20140116160356.GY16215@pengutronix.de> <20140123083714.3c6e86ae@ipc1.ka-ro> <20140123115203.GV15937@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140123115203.GV15937@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:52:03AM +0000, Russell King - ARM Linux wrote:
> On Thu, Jan 23, 2014 at 08:37:14AM +0100, Lothar Waßmann wrote:
> > This wouldn't buy much without a material change to of_pwm_get().
> > The function of_parse_phandle_with_args() called by of_pwm_get()
> > requires the number of args in the pwms property be greater or equal to
> > the #pwm-cells property in the pwm node. Thus, the interesting case of
> > having #pwm-cells = <3> without changing the existing users is
> > prohibited by of_parse_phandle_with_args().
> 
> I really don't think that's a problem we need to be concerned with at
> the moment.  What we need is for the kernel to be able to parse files
> with #pwm-cells = <2> with the pwms property containing two arguments,
> and when they're updated to #pwm-cells = <3> with the pwms property
> containing three arguments.
> 
> Yes, that means all the board dt files need to be updated at the same
> time to include the additional argument, but I don't see that as a big
> problem.
> 
> What we do need to do is to adjust the PWM parsing code such that it's
> possible to use either specification without causing any side effects.
> 
> I would test this, but as u-boot is rather fscked at the moment and the
> networking has broken on my cubox-i as a result... and it seems that the
> u-boot developers have pissed off cubox-i u-boot hackers soo much that
> they've dropped u-boot in favour of barebox...

Oh, and another reason... the u-boot video settings are totally and utterly
buggered to the point that it doesn't produce correct timings, and it seems
that u-boot people have zero interest in fixing that, so u-boot mainline is
basically refusing to fix this - another reason to stay away from it.

(1024x768 @ 60Hz produces 70Hz refresh on iMX6Q here - I've seen it produce
51Hz on iMX6S, both of which are far enough out that lots of display devices
will not accept it as a valid signal.)

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
