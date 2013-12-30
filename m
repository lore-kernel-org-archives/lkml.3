Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3L3Obg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:31:36 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44687 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab3L3Obe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:31:34 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Date: Mon, 30 Dec 2013 15:31:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-15-generic; KDE/4.12.0; x86_64; ; )
Cc: =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Sebastian Reichel <sre@ring0.de>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com> <1727897.LBX8128hIo@izba> <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
In-Reply-To: <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart198350029.lGDjynWINA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312301531.29768@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart198350029.lGDjynWINA
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 28 December 2013 02:21:23 Marcel Holtmann wrote:
> Hi Pali,
>=20
> > I'm sending updated version of hci_h4p bluetooth driver. It
> > is needed for Nokia N900 bluetooth hardware. This (v2) is
> > older version of hci_h4p driver, but I tested it with
> > v3.13-rc3 kernel on Nokia N900 and working without any
> > problems. Previous (v1) version had some problems. So for
> > future development please use this (v2) version of hci_h4p
> > driver.
>=20
> please create a proper commit message explaining this driver.
> Revision updates should go between the diffstat and the patch
> itself. Use git format-patch and you see what I mean.
>=20

Ok. First what I wanted was to have working driver with new kernel. I sent =
it so other people can look at code and fix what is
needed... I think that correct commit message is not needed now.

> > diff --git a/drivers/bluetooth/Kconfig
> > b/drivers/bluetooth/Kconfig index 11a6104..95155c3 100644
> > --- a/drivers/bluetooth/Kconfig
> > +++ b/drivers/bluetooth/Kconfig
> > @@ -242,4 +242,14 @@ config BT_WILINK
> >=20
> > 	  Say Y here to compile support for Texas Instrument's
> > 	  WiLink7 driver into the kernel or say M to compile it as
> > 	  module.
> >=20
> > +
> > +config BT_HCIH4P
> > +	tristate "HCI driver with H4 Nokia extensions"
> > +	depends on BT && ARCH_OMAP
>=20
> Since then we moved away from doing hci_* prefix of drivers
> since that is misleading. See btusb.ko, btmrvl_sdio.ko etc.
>=20
> So this might be better named BT_NOK_H4P or BT_NOKIA_H4P and
> the module named btnok_h4p.ko or btnokia_h4p.ko.
>=20
> I still never understood what =E2=80=9Cp=E2=80=9D was for.
>=20

I do not know too, I did not invent that name. I just copied
kernel driver from nokia kernel and patched it to work with 3.12.

Maybe 'p' means plus (+) as H4+.

> Can we also make this just depend on some device tree
> information and not on a specific architecture. I know that
> this driver is pretty much OMAP specific, but if we want this
> upstream, we should at least try to make it more generic.
>=20

Sebastian, can you look at code how hard is to add DT support?

> > +MODULE_DESCRIPTION("Bluetooth h4 driver with nokia
> > extensions"); +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Ville Tervo");
> > +MODULE_FIRMWARE(FW_NAME_TI1271_PRELE);
> > +MODULE_FIRMWARE(FW_NAME_TI1271_LE);
> > +MODULE_FIRMWARE(FW_NAME_TI1271);
> > +MODULE_FIRMWARE(FW_NAME_BCM2048);
> > +MODULE_FIRMWARE(FW_NAME_CSR);
>=20
> Do we actually have all these firmware files still available.
> If not, then focus on the ones we have.
>=20

=46irmware files are available for download from nemo project:

https://api.merproject.org/public/source/nemo:devel:hw:ti:omap3:n900/bcm-bt=
=2Dfirmware/bcm-bt-firmware-0.21rc3.tar.bz2

https://api.merproject.org/public/source/nemo:devel:hw:ti:omap3:n950-n9/ti-=
wl1273-bt-firmware/bt-firmware-ti1273_0.23+0m6.tar.gz

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com


--nextPart198350029.lGDjynWINA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlLBg70ACgkQi/DJPQPkQ1ItJQCbBQ5QO8yUc5ooH6Rclfa0llEW
iqEAoLl35CHVmyM1UUhLC/tGwibu9zYu
=3c+q
-----END PGP SIGNATURE-----

--nextPart198350029.lGDjynWINA--
