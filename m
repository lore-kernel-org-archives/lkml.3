Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab3L3OEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:04:14 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:39764 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3L3OEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:04:12 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Date: Mon, 30 Dec 2013 15:04:06 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-15-generic; KDE/4.12.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Marcel Holtmann <marcel@holtmann.org>,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com> <20131230121350.GB31236@amd.pavel.ucw.cz> <20131230131942.GA13816@earth.universe>
In-Reply-To: <20131230131942.GA13816@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9079777.of6x8moKOH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312301504.06745@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9079777.of6x8moKOH
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 30 December 2013 14:19:44 Sebastian Reichel wrote:
> Hi,
>=20
> On Mon, Dec 30, 2013 at 01:13:50PM +0100, Pavel Machek wrote:
> > [...]
> >=20
> > Well, I can rename config option, but renaming the module
> > would break existing userland, no?
>=20
> Why is the userland depending on the module name?
>=20

grep told me that hci_h4p is used only in these (text) files:

* /etc/modprobe.d/maemo.conf
   alias platform:hci_h4p hci_h4p

So this is not needed if kernel driver contains correct=20
MODULE_ALIAS macro.

* /etc/event.d/bluetooth-sysinfo
   echo ... > /sys/devices/platform/hci_h4p/bdaddr

This upstart script contains code for reading mac address from=20
special sysinfod daemon and setting it to kernel driver. Once=20
there will be uniform way for setting mac address that script can=20
be changed.

So I think that renaming module will not break anything if kernel=20
module will get (somehow) correct mac address (or if random one=20
is acceptable).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com


--nextPart9079777.of6x8moKOH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlLBfVYACgkQi/DJPQPkQ1IN0wCfViYDiCdqpg1Zi5iYWpem12WA
jb8An1gSOP6Jwq1IvhfkryDvNCDtHT43
=523S
-----END PGP SIGNATURE-----

--nextPart9079777.of6x8moKOH--
