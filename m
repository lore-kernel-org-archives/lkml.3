Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3GJJvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:51:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53671 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3GJJve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:51:34 -0400
Date: Wed, 10 Jul 2013 10:19:52 +0100
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
Message-ID: <20130710091952.GF3179@sirena.org.uk>
References: <20130704154105.GD27646@sirena.org.uk>
 <20130705135507.GA17439@kahuna>
 <20130705140828.GA27646@sirena.org.uk>
 <51D6DD3A.1030002@ti.com>
 <20130705165235.GC27646@sirena.org.uk>
 <51D70356.30707@ti.com>
 <20130705174727.GF27646@sirena.org.uk>
 <51DAF55C.5040502@ti.com>
 <20130709152954.GF27646@sirena.org.uk>
 <51DC3487.2080503@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3yNHWXBV/QO9xKNm"
Content-Disposition: inline
In-Reply-To: <51DC3487.2080503@ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH V2 1/8] regulator: Introduce OMAP regulator to
 control PMIC over VC/VP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3yNHWXBV/QO9xKNm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 11:04:23AM -0500, Nishanth Menon wrote:
> On 07/09/2013 10:29 AM, Mark Brown wrote:

> >This seems like something we should be able to cope with by for example
> >adding a bus for the custom PMIC interface or otherwise finding a way to

> I had considered introducing a custom bus for custom PMIC interface,
> but as you stated below, standard regulators will probably need some
> custom monkeying around.

We should just be able to use the platform bus here.

> >get to the data at runtime based on the compatible string.  This would
> >need some custom code in the regulators but would have the advantage of
> >keeping the data the same at least.  Hrm.

> Ofcourse,this will be to add custom set/get_voltage implementation
> using this "custom API" which we discussed was'nt that good an idea.

No, if the regulator isn't being interacted with directly then it
doesn't need to export any operations - just data.  The operations would
come from the magic SoC hardware that controls the regulator.  The code
in the drivers should be very small, if it isn't there's no point in
doing this.

> >>between PMICs? yep, twl4030 does 4mV/uSec, 6030 can do 6mV/uSec,
> >>TPS62361 can do 32mV/uSec, TWL6035/37 does 0.220mV/uSec

> >Those are ramp rates, they're not I2C I/O limits.  Ramp rates we already
> >know about.  I think what you're saying here is that this latency value
> >is actually about worst case ramp times?

> Arrgh.. my bad. I confused ramp time with I2C transfer timeout
> parameter. I know that I2C bus can be held[1] by PMIC as long as it
> is busy. Some custom ASIC can do some weird stuff I suppose. I dont
> seem to have clear data points in the sketchy TRMs for 6030/2 ,
> 6035, 5030, for these other than to state it is i2c specification
> compliant (/me grumbles). So, I just have emperical value which is a
> bit conservative and seem to work on the devices.

OK, no problem - like we said further up the thread I think adding
something to get the data

--3yNHWXBV/QO9xKNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3Sc1AAoJELSic+t+oim9LgcP/A9peqE0jmK5KWGZ6iw7kK0J
8KEbz1Y2DU19fY0Bn6QNW4xbQv0hDbJcH/nGAx/QwvcoPHfLnwbCQJNmeiKfHWGH
yFU76STMGLdDCC5vGSUrAayMQl4M2/3s+0jxYd1FVhRFoIfXYIC9QNl8oowQG5BR
ilWKlWIlstwYVR/Vlwq7k4ovejxGL7Pwb2l0gnKsOYKh+ElAC4nPWSVk9R6biOa+
uclgxbo58sAUZKQIR7oaS9+7UGtuYRl8JDJYtF81NdZnOIiTKzNl6KLrnEFgRxzJ
Q9RhDybgn81dSH+iouml3Fj1p4jK6fqaDymeBuXGEdd5CWAVhrjzu/4F7S1S/43V
+kc9fBccC0Pn2ls3WzFKZ9HrJZYPhyY2NOBMcj69EyKNCLMFI2HXVPEwzc0AdMWn
ea0CbyGin5Go8WMQHmpNfIL7f92QdhXVa6jl0NAZUAd6ZPfEcbqIFlqzoqM/O0Lp
O+Y3nHK4Q63jCvxTygN1O/7fjauma7gxeq4PZqrF8mV4blKhCXMmAp/TtzLQPL0X
+VyYvcWIULXyfSrsz057Eqnsnwb9Mq8DI6qMem4COYM7TnV+rbGeiM9p2RGezBvo
F2XGXgdGLBrVXUND24eVw6N2VXmXMgs3qkVWQZom8PKVNu8Dgmhy2E2dJa3Dbn8J
AmZ6xaf87FMC0qX5S/fc
=aaQ8
-----END PGP SIGNATURE-----

--3yNHWXBV/QO9xKNm--
