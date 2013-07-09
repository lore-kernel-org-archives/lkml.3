Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3GIPaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:30:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48444 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3GIPaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:30:00 -0400
Date: Tue, 9 Jul 2013 16:29:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Taras Kondratiuk <taras@ti.com>
Message-ID: <20130709152954.GF27646@sirena.org.uk>
References: <1371849949-12649-1-git-send-email-nm@ti.com>
 <1371849949-12649-2-git-send-email-nm@ti.com>
 <20130704154105.GD27646@sirena.org.uk>
 <20130705135507.GA17439@kahuna>
 <20130705140828.GA27646@sirena.org.uk>
 <51D6DD3A.1030002@ti.com>
 <20130705165235.GC27646@sirena.org.uk>
 <51D70356.30707@ti.com>
 <20130705174727.GF27646@sirena.org.uk>
 <51DAF55C.5040502@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YbCBl//VW3xXyIiK"
Content-Disposition: inline
In-Reply-To: <51DAF55C.5040502@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.114
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH V2 1/8] regulator: Introduce OMAP regulator to
 control PMIC over VC/VP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YbCBl//VW3xXyIiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2013 at 12:22:36PM -0500, Nishanth Menon wrote:

> case #1 - TPS62361 has a single SMPS and a single generic i2c bus,
> one can talk on. In this case, you'd associate the regulator device
> in one place - i2cX or on custom SoC hardware interface.

> When used with custom SoC hardware interface, generic tps62361
> regulator which talks regular i2c wont even probe for omap_pmic to
> get the regulator data from tps62361 regulator driver. Even if we
> were to define the generic TPS62361 in dts nodes, it will fail probe
> as it cant access any of it's registers using generic i2c.

This seems like something we should be able to cope with by for example
adding a bus for the custom PMIC interface or otherwise finding a way to
get to the data at runtime based on the compatible string.  This would
need some custom code in the regulators but would have the advantage of
keeping the data the same at least.  Hrm.

> >Another option is for the drivers to provide the data and use the
> >helpers for their linear ranges as part of a more complex
> >implementation.

> Having looked at a few regulator driver implementations, there seems
> to be the following combinations:
> a) drivers which have n ranges of linear voltages for incremental selector
> b) drivers with 1 range of linear voltages only for all ranges of selectors
> c) drivers with 1 range of linear voltages and nonlinear voltage
> values for other vsels.

Everything else is just a special case of option a - either there's just
a single range or there's a bunch of ranges each with a single value.  I
suspect that ranges will be the most useful thing for any hardware which
can practically be used by these regulators anyway.

> >OK, that's a bit more fun but I think the kernel wants that information
> >in general anyway since a software cpufreq driver or something might
> >want to make the same latency decisions.  This is what set_voltage_time()
> >is for in part.  But to a first approximation is there really much
> >variation in the numbers?

> between PMICs? yep, twl4030 does 4mV/uSec, 6030 can do 6mV/uSec,
> TPS62361 can do 32mV/uSec, TWL6035/37 does 0.220mV/uSec

Those are ramp rates, they're not I2C I/O limits.  Ramp rates we already
know about.  I think what you're saying here is that this latency value
is actually about worst case ramp times?

--YbCBl//VW3xXyIiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3CxuAAoJELSic+t+oim9UFoP/jH/YCa3JzSAjUIoBh90fqQ8
adOcvFrc8mxhHsbwGMossY2k4YZKvKrshzI0vpnBaYHfxmAORVtGI9hRNSTJJdmz
Bjcil39PME2wAixe/Y1jjeDwkWMuZBElH3gxn0sslkYO0pHxuRDukzUqMQtTDQk0
ycLTcA8s64gXwJUYSqwr+NjU7ShPSHnppvo3m1QhSGworBMe5sd4QX4oia1CO+vt
bFHIh/vWaTqT1aqaSl9IUDG/5Su7NC2vtpbspRLHf/VadC88Wn4KdmR+tzF6K1Pu
6AfyiSKvXzkESl87D4K9t5ykAUZ94VdN6N8it63XR6jtQ7gPQy+mvVDiEgjK4d/8
VnkgHPrIaObnv1E48+o4V7lrEF8wMDyrNY1WjckMfc/bI03TJ2D9InVIGCVwv3v4
Z033ihI79m6Gsu/7crZtLiJNwX/9h0i+umdszaoo7mJnEbc9hq80g6JgyZ4g4Uxw
CzdIwe39xdydMIU94CqYRWZZ7R/vMVOoVGEPAyTb6roXe8qtPG6KJKisCSLpKUro
Zb3ofbSP7usMTLex0NpnsbGVxGYAycaKP2Qx5zB1giejROZe6VBpKDL0TvHlvVss
yr5DSxcYjHURnDqMSQ7cw5y38Tso3tI9C5lDTQvDQoqx2ahMSHIdg+kKIvOJYJeJ
G8KVlGZp1z9cW9FJ2U6x
=joFZ
-----END PGP SIGNATURE-----

--YbCBl//VW3xXyIiK--
