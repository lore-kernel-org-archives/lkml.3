Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaJQO0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:26:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33362 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJQO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:26:42 -0400
Date: Fri, 17 Oct 2014 16:26:05 +0200
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141017142605.GU1820@sirena.org.uk>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141013103512.GJ27755@sirena.org.uk>
 <20141014011112.GB2751@jack-ThinkPad-T520>
 <20141014075606.GN27755@sirena.org.uk>
 <20141017091950.GA3233@jack-ThinkPad-T520>
 <20141017101734.GB1820@sirena.org.uk>
 <20141017104309.GA3136@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8KmZJhJMEENkOiL3"
Content-Disposition: inline
In-Reply-To: <20141017104309.GA3136@jack-ThinkPad-T520>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v4 7/8] regulator: sky81452: Add compatible
 string for device binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8KmZJhJMEENkOiL3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 17, 2014 at 07:43:09PM +0900, Gyungoh Yoo wrote:

> Are you talking about simplification using of_regulator_match()?
> This driver has only one regulator.
> Is the API also useful for this driver?

The thing I'm seeing is that the binding for your device with the
subnode looks very much like the device trees of devices with multiple
regulators.  The fact that you only have one regulator is a bit
difference but not that much.  It seems like drivers should fit into one
of two patterns: either the regulator is described in the root node for
the device for single purpose devices or there should be a collection of
regulators like is supported with this helper API.  Having a collection
with only one node doesn't seem to be a problem in any way.

> Like reg-fixed-voltage, how about using of_get_fixed_voltage_config()?

The driver doesn't seem to need any property parsing of its own so it
shoudn't need anything beyond basic calls into the core.

--8KmZJhJMEENkOiL3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQSb9AAoJECTWi3JdVIfQxj4H/i7w/lgspWRke5mDs2egxwpB
FSwKzUZSTLw9B/WAdWfEnQG4daYaSmbFI79EZX8Lv8/WlGu1glq1kf6TkI6Stugi
cIV4wjA+Kv6wcOArzxMAbE+dT6FAwPFMWFyjrVSXZ9BUq27hXYDjdrjx6/Pn9KoD
qTHb6BuhDZap3RX/AzVZ8OaI2zTk9m4tBLL7k3Cl7DWFXRHh9HU7JLzTZV6aFtx1
ud2j5yCwiva+/cwMJ/I3evHYjhQKsZQ5p5arxrUWq/zKXqVp8th0HjAtx/L3VB2z
39cI0oIiwJ9CNKzuzMFnNMuKczkbYZr7vKRyjOK0HOlP9b4Rj+8b/VVejG8gnkU=
=OfiQ
-----END PGP SIGNATURE-----

--8KmZJhJMEENkOiL3--
