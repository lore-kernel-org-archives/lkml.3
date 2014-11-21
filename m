Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbaKUKSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:18:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33249 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbaKUKSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:18:15 -0500
Date: Fri, 21 Nov 2014 10:16:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Message-ID: <20141121101615.GP3815@sirena.org.uk>
References: <1416210027-5562-1-git-send-email-flora.fu@mediatek.com>
 <1416210027-5562-4-git-send-email-flora.fu@mediatek.com>
 <20141117234012.GE22111@sirena.org.uk>
 <1416553771.19764.51.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="411OKKGJLVBgRQv/"
Content-Disposition: inline
In-Reply-To: <1416553771.19764.51.camel@mtksdaap41>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/7] regulator: MT6397: Add support for MT6397 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--411OKKGJLVBgRQv/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 03:09:31PM +0800, Flora Fu wrote:
> On Mon, 2014-11-17 at 23:40 +0000, Mark Brown wrote:

> > > +	vosel =3D info->buck_conf.vosel_reg;
> > > +	voselon =3D info->buck_conf.voselon_reg;
> > > +	vosel_mask =3D info->buck_conf.vosel_mask;

> > Please use the standard way of specifying data even if you can't use the
> > standard function.

> Could you specify the standard way of specification data? Thanks.=20

Using the fields in the regulator_desc as you can see from the standard
helpers.

> > You should add comments here explaining what's going on - it's very
> > strange to have to write the same value to two different registers and
> > the names of the registers look suspiciously like this is something to =
do
> > with a suspend mode...

> Yes, its is for suspend mode control usage.
> For registers "vosel", "voselon", they is called register mode or
> hardware control mode voltage settings. Register mode is a default mode
> on the buck control. For quickly normal/sleep mode switch, hardware
> control can be enabled by controlling buck output by a CTRL_PIN. In the
> following diagram, there is a static settings on vosel_sleep for suspend
> mode output. According to CTRL_PIN's level, Vout can have different
> output (voselon or vosel_sleep).=20

You need to represent this in your driver, the sleep mode controls
should either be controlled using the suspend API or the GPIO control
needs to be visible in the driver.  It's also OK to ignore the GPIO
control for now and do it later if complex work is needed to represent
it in the driver.

--411OKKGJLVBgRQv/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbxDrAAoJECTWi3JdVIfQxsYH/1EnydozK7WoOzEDmaoQOiXM
3eLi6VTJhJqsnacl2Xr49kJGix/67XXR1Q1Txf/yr2Soxuom4QflD3oRUY+CHnmQ
uqxJq8FDoABYH9kn+6OZ6mlozp7H6w0+38drF/ABUryVlfw3Pb8XteOXM3lPz0EU
hhdfeLlokvP0qEIk1VXLO63Wf7hTUWjjKgX5PkVY4cSxQyVDFTGa159MM7l5hjcu
zOFeBLxLs9VKElXECw9gumx6Xw2yuIygzsCluKjBbkir7kk/uLLkDMdoZXjSnjyO
UGe4EvtKS5DyzftLxOEX+vkLZGm6X7ITy1jSd+xIy1C1Bwrwozwg1WPjXmLBVhU=
=8buq
-----END PGP SIGNATURE-----

--411OKKGJLVBgRQv/--
