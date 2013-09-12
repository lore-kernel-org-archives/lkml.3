Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3ILKMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:12:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45879 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab3ILKMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:12:44 -0400
Date: Thu, 12 Sep 2013 11:12:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
Message-ID: <20130912101229.GD29403@sirena.org.uk>
References: <1378904331-5665-1-git-send-email-ldewangan@nvidia.com>
 <5230A593.9010401@wwwdotorg.org>
 <5230AC5E.2020504@nvidia.com>
 <5230AC61.30904@wwwdotorg.org>
 <5230B1CE.3090709@nvidia.com>
 <5230AF94.60007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E4rQ6ZnlkSybhf/y"
Content-Disposition: inline
In-Reply-To: <5230AF94.60007@wwwdotorg.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: core: add support for configuring turn-on
 time through constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E4rQ6ZnlkSybhf/y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 11, 2013 at 11:59:48AM -0600, Stephen Warren wrote:
> On 09/11/2013 12:09 PM, Laxman Dewangan wrote:

> >> I suppose that either is fine from a DT perspective. But, the regulator
> >> drivers already know their internal delay, so presumably driver code
> >> will have to take the value from DT, and subtract out whatever delay the
> >> driver already embodies, in order to calculate the extra delay required?
> >> Or, if this property is set, does the driver-specified delay just get
> >> ignored?

> > Yes, if property is available then driver-specified delay get ignored.
> > Delay will be used from dt provided value.

> I'm not sure whether I prefer one option or the other. Perhaps Mark can
> decide?

The drivers don't implement their own delays, this is already factored
out of them into the framework.  It seems simpler from both a user and
implementation point of view for the delay specified in the DT to just
completely override what the drivers know.

> That said, what if the internal ramp rate of the regulator itself is
> configurable, and can change at run-time. Won't that affect the total
> time? If so, having this property represent the additional time might
> better allow the total time to be recalculated based on internal
> regulator ramp delay changes. Perhaps the additional time varies if the
> internal ramp rate varies though, so perhaps it's not worth thinking
> about this situation.

There's very little use case for varying the ramp rate from cold at run
time - it's mostly just used to limit inrush current on initial power
on.  I think it's OK to just say that if someone specifies a fixed dleay
and varies the ramp rate then they probably aren't being sensible and
get to keep all the pieces.

> - regulator-enable-ramp-delay: The time taken, in uSec, for the supply

microseconds.

--E4rQ6ZnlkSybhf/y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMZOKAAoJELSic+t+oim9vPYP/RCOT2PUyiy3Zj0RTK2tfeUf
H/PUwKA571c7RlbsdtfABTSrPr6C8boLMAmADfoXTBMWUDI5eVOFctZvqCxN+ZoE
wO9xgSaStIETTsRD5q030dezTZLvxAYSSlE6c+gaQn2yRPjE7eBaMkMJP9zbaEEI
4lA152wPn+ceSYANvhqkWZcWb6nJnG+URY3EThDzctIfJfqSI0Qo45YEkBDuzyuA
VdHyXdyONksEDRh/noJcXuE5rWRVW/X5e13BHwX1SljXQ+FdRDb6s2VemJagON9u
oG61MBnW6JVc0T0figveaCJt200bIMdhGyREh4QmMHySl+o9PZvkx3N5H3YeW7rX
6FmOzQ0XdHwrmioMUgeVluHE1baVNGuoUiCMduKBX0jDDJ/Ue+GVXErLW0YPPMjO
fgmncm+MBM592W2MMrNKnbpiTTXUM0MTSXYq6s9sDgmhFYWF7xekwp75jQ5XP20g
d8XRdBGB/V1ou/sUPM8BblAzIXJ/+vru3g/yNRnJbn2HZy5IE72cq3g7DBwj+9tq
zwBSIN4SX4eKJI3KEhXiXv0J76hf8rviR7WJnCKzH271qZ8Y0b/hjqy7Sv4RL2EO
VCgpljjNh2o5/+a/I6oTC2PP19IcYKMisAxDb0eLCu74o8rMQidb+xShkBF+DzY+
zVDaCtKpqYeV25jf8B3m
=IZ83
-----END PGP SIGNATURE-----

--E4rQ6ZnlkSybhf/y--
