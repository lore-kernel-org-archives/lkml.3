Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbaDQLgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:36:10 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64350 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaDQLgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:36:08 -0400
Date: Thu, 17 Apr 2014 13:34:59 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pwm_lpss: Add support for PCI devices
Message-ID: <20140417113458.GC32603@ulmo>
References: <1397672338-3510-1-git-send-email-chiau.ee.chew@intel.com>
 <20140417110756.GB32603@ulmo>
 <20140417121643.2c07ecfc@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
Content-Disposition: inline
In-Reply-To: <20140417121643.2c07ecfc@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2014 at 12:16:43PM +0100, One Thousand Gnomes wrote:
> > > +static int pci_drv, plat_drv;	/* So we know which drivers registered=
 */
> >=20
> > I think that rather than having everything in a single file, perhaps a
> > better approach would be to keep pwm-lpss.c as a common module and then
> > have separate drivers for ACPI (pwm-lpss-acpi) and PCI (pwm-lpss-pci).
> > That way you don't have to keep track of which driver was successfully
> > registered.
>=20
> It would then take up 16K for a tiny trivial piece of code

It would help make the driver somewhat less cluttered from a code point
of view. And I suspect that 16 KiB doesn't really matter all that much
on the platforms where this is used.

But if you prefer not to do the split that's fine with me too.

> > > +static const struct pwm_lpss_boardinfo byt_info =3D {
> >=20
> > What does byt_ stand for?
>=20
> Baytrail.

Okay, that could use a comment since it's not mentioned anywhere else
and the PCI IDs don't give it away either.

> > > -static int pwm_lpss_probe(struct platform_device *pdev)
> > > +static struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,
> > > +			struct resource *r, struct pwm_lpss_boardinfo *info)
> >=20
> > Indentation is odd here. Please align arguments one subsequent lines
> > with those of the first.
>=20
> That doesn't appear to be present in CodingStyle or indeed most of the
> kernel.

I'm used to it in the PWM subsystem and I'd like to keep it that way for
consistency.

Thierry

--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTT7xiAAoJEN0jrNd/PrOh6p4P/1WJeB9SE/CDWzeAJ+YguRV/
EPk1UTOZeTjANJSRXBaDoREmhq28KckhXOih6rLdK72GD7ZV2W/Rn7fgVdrIkVD8
krvG5vsdn6Ag2en0k4ZKPvLu7y8gP6DKwVncrJj+2F67izrhe+60JDfKuuaFxVGH
8O/cO9jiMkQq+yCEc8/S/diCgsRITA4kBewy4n4ud9f9V1cfQpRzcAz8sgowd1dZ
SQVQcugaawGI0lqoGlpj1eOMCMVVR1FCzrAywWaSC1EYQaIakLOOp/6uctuRCUVy
HgnGM1EfVbvNgPxDDqGT3fAqHzVY2gILuRuEQ8s2PiPrK9EAbdy8AXFgngsHNkrI
vBQ9eCXcpDZC0E+gkiIQn8LTvsxzceJMKp/9H5bvpXPbSe+J1lrxbIiJZ13BYcgC
AJ9ypOzMPfOU/rpVYMkOpImSEdTrvFY5MFYo5VfEzZ0/5n7rQeSB594aaqvHWqHx
S6wYxE8atFSlZ1AFUoREaYc+f7XYMy1nyI1MNXJRQZCSM/pPP2zZXBnDEtNbAIw3
xyTFTNoysMF/3bCtUBC/GMMK3jDvwPGejr3I7DIkIOqkHbFWbgQtY5YgAS9dZ6T6
E5EPdLPjLuwpm4vurc37AB18UQ0S4REGTPfjBCJPouVyQDhf5LNyVTQ6IYwVIl5U
A0LCMLK4w44sm3Vf/F06
=9840
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--
