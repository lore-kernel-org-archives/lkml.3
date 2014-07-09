Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaGIH6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:58:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54298 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaGIH6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:58:17 -0400
Date: Wed, 9 Jul 2014 09:56:36 +0200
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140709075636.GD30458@sirena.org.uk>
References: <201407090103.s6913Wwl035701@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3IyuMspwcGTbYISR"
Content-Disposition: inline
In-Reply-To: <201407090103.s6913Wwl035701@krsrvapps-01.diasemi.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: your mail
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3IyuMspwcGTbYISR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 10:03:32AM +0900, James Ban wrote:

> > > +	ret =3D regmap_read(chip->regmap, DA9211_REG_EVENT_B, &reg_val);
> > > +	if (ret < 0)
> > > +		goto error_i2c;

> > > +	if (reg_val & DA9211_E_OV_CURR_A) {

> > > +	if (reg_val & DA9211_E_OV_CURR_B) {

> > > +	return IRQ_HANDLED;

> > This is buggy - the driver should only return IRQ_HANDLED if it handled=
 the
> > interrupt somehow, otherwise it should return IRQ_NONE and let the inte=
rrupt
> > core handle things.  This is especially important since the device appe=
ars to
> > require that interrupts are explicitly acknoweldged so if something is =
flagged
> > but not handled the interrupt will just sit constantly asserted.

> Basically all interrupts are masked when the chip wakes up.=20
> Only two interrupts are unmasked at the start of driver like below.

I know that's the intention but the code should still be written
robustly - something might go wrong somewhere which causes another
interrupt to be enabled, or we might even gain support for shared
threaded interrupts in the interrupt core and someone could then
try to use that in a system.

--3IyuMspwcGTbYISR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvPWxAAoJELSic+t+oim9AXkP/RQ3//m+mqAVPrHuYDlx+UJs
s/zk+1m2oiL+a/pxPmW8IPaVfnsWYBF1P5BEXfk+VETvzNTn/pWNqAv8M/snq2wW
XuHB8onzoSxZV3tWfz8A4GBglTdYojsLLJeFLH0gLUKIK28X8mLpTH+Q7cWPnXwa
FfG1zJokZP5gyw+5Rrj2kzJxKJMCPKUV+WWXNCJ4IXs+xJjqv4HHRQZFOKAG9/Ii
fyUnfQHSrN7F2uYn6AhBz257Sj7KDrifqiWTlMLca9c2GGpStKoXreau+ixlAx5d
MRE+rXpr3WadFenZmtZ4rkheQx54AIJeQCBsEh0M90q/4ZxIJwSVQVG3MaxsewkJ
VIBYVXkWTj4DMaP4egos379zsAdVC9BmwSyiz015eiILyu64QkSgdpbT7GNaGhLY
AWmhfUP7GfbSA7Ns55TcNkHag9zkEA5MFLWOMQxu9xIVEuzAHnfVWzKqGCB+VmSd
apLWjMhaOFEdVAfFaaDWQ7cRaaOxh57EssJRqq9VQATXJ+jwlW9WDnLJBZsqEjTf
7BEdR488dWZDpjcI0RgqakWGktLCVr6+13NOC1h0t7E3xDDWG6WgCQ5MW7x5T076
V6Tnx2yfNRHDMgidQ/NPhj8zVr8+x8MFkqmeqDFD/2czzDFlnCFMPqHPpOQLaLLr
1e3UAmClqGat47xZEqfs
=O7oi
-----END PGP SIGNATURE-----

--3IyuMspwcGTbYISR--
