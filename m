Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaDPEhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:37:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53138 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaDPEhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:37:16 -0400
Date: Tue, 15 Apr 2014 23:34:50 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Weinberger <richard@nod.at>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: mv_u3d: Remove usb phy driver for mv_u3d
Message-ID: <20140416043450.GB15056@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397561783.1985.55.camel@x220>
 <20140415172310.GD16002@saruman.home>
 <1397585312.8212.13.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <1397585312.8212.13.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2014 at 08:08:32PM +0200, Paul Bolle wrote:
> On Tue, 2014-04-15 at 12:23 -0500, Felipe Balbi wrote:
> > so this means that drivers/usb/gadget/mv_u3d_core.c isn't used either ?
>=20
> Why should it? There's no dependency on CPU_MMP3 for USB_MV_U3D anymore,
> is there?

no, but the UDC needs its PHY driver.

> > Instead of deleting this and introducing a new driver, why don't you
> > just help fix what's already in-tree ?
>=20
> Were any of the reasons I gave for removing this driver incorrect? Has
> it actually ever been possible to build it?

I don't know, let me check:

$ make drivers/usb/phy/phy-mv-u3d-usb.o
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: `include/generated/mach-types.h' is up to date.
  CALL    scripts/checksyscalls.sh
  CC      drivers/usb/phy/phy-mv-u3d-usb.o

yup, builds just fine. Even if the ARCH support isn't in place, this
driver is *not* breaking anything, it's not preventing anyone from
getting work done and it might be helping Marvell decrease the amount of
changes they keep out of tree.

I don't see any problems this driver in tree as long as there are people
working on it and I see the latest commit was 10 days ago, it wouldn't
be fair to Marvell to delete their driver if they're still finding ways
to make it useful one way or another.

cheers

--=20
balbi

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTghqAAoJEIaOsuA1yqREgiAP+gOcyDLMCNCX02ib9kZx5d8F
8MumHSviT2miakYOtJ3d54/3GK/3dSKaxL/Rc6jlZ57o9d/2XsYla2Od0qIZ+jy6
gDmP5Wjk3AuEqeqAjLvepyS1K42sPDyfMrv+8hODgWOoD+aToLAmTlpJdycmn8nO
zvah6XshZ9FryEstCCZXqZ2bKsJL48ryTcKspJu5kw0SzCn7yuEQRlF+jK6ljEcZ
LGh6RfJKs/DSyU6tFbph3fdyznMb88lkwuNJgjKUX5ypONsOVoatNml6BIIQ2iDO
xkqWk4mbN2aOfEh3X8mOqp+vaceaF2GL9F8XtEFXEgWdHb9H9T0JDX0ecs+T/f7A
jiBdDdHutJokBZ1n7p5649niPPVmWSUatGef/162DKMTZEJNqXgq8GnE33NGnvtQ
l5T0Dqk5JSrBh8mekHzXXMYu8uCBUL8OdW/tB84LUmxw5YzDfx1xNTgWJ2R/lqRv
i4qT4MjbHasXq75GpXpunD8ipwCjEJpg/e66+1GIRMABTDS4bNG+lfhP1U4h3SGI
/HCOKrDekGUeYvuaShSf+6sfC2OcgoMv0upqzgBt328hhd5PvZ7cfUgYXeLdsI+Z
MkIWWftgg6mUFFdG7X6Nd9TFsPdnCSNCNHE1LnW4zKE+FV6s/793KT3gt641+kok
hyGB/Pe6shdqilk4oINz
=LFuA
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
