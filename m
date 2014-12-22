Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaLVJVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:21:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53114 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbaLVJV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:21:29 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH 0/3] Dell Airplane Mode Switch driver
Date: Mon, 22 Dec 2014 10:21:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com> <2697957.miSb4Rm7HK@xps13> <CAJ=jqubEggcXs0kvegGUpVh8PNh-GmdcnXkXUjqv4fHD-zXdEA@mail.gmail.com>
In-Reply-To: <CAJ=jqubEggcXs0kvegGUpVh8PNh-GmdcnXkXUjqv4fHD-zXdEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1624474.KblB4eBZ3U";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412221021.26112@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1624474.KblB4eBZ3U
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello, thank you very much for testing.

On Monday 22 December 2014 08:27:57 Alex Hung wrote:
> =3D Testing =3D
>=20
> I tested six Dell systems for two sets of patches for dell
> radio button - two system with radio slider and four with
> radio hotkey. There are also two systems with working ARBT
> method.
>=20
> =3D=3D Basic Information =3D=3D
> Based OS: Ubuntu 14.10 (kernel 3.16 [1]) and kernel 3.18 [2]
>=20
> Patches:
> 1. dell-wireless v3 =3D original v2 + Gabriele's suggestion [3]
> 2. dell-rbtn [4]
>=20
> Method:
> 1. run "rfkill list" and press hotkey / toggle slider during
> runtime 2. run "rfkill list" and toggle slider during S3
>=20

If there is problem with my patch series which does not reflect=20
correct state after resume from S3, I can add pm hook which will=20
try to re-read rfkill state (via GRBT) after system wake up from=20
S3.

> =3D=3D Results =3D=3D
>=20
> I summarized the tests in Google sheet as below. Please advise
> if anyone has problem reading it.
>=20
> https://docs.google.com/spreadsheets/d/1voffS6dNglwAExSGh3UmG_
> _UAO2qfZ829CkJLPo06aI/edit?usp=3Dsharing
>=20
> PS. The document will stay as long as possible for future
> references.
>=20
> =3D=3D Summary =3D=3D
>=20
> 1. I did not observed a duplicated event. However, keycode 240
> (unknown) is generated on many UUT. It is not issued by
> dell-laptop or del-wmi. I am suspecting it is the other event
> Pali observes but it can be the result of different distro.
>=20

It comes from i8042 bus via internal AT keyboard (not from WMI).=20
In userspace you can assign correct keycode (e.g. KEY_WLAN or=20
KEY_RFKILL) so it does not show as unknown. Its scancode is 136=20
(0x88) and default keycode 240 (0xF0).

Some other distributions or other software automatically map this=20
unknown 240 keycode to some key, so you will see duplicate event=20
even in X applications.

> 2. Some system issues scancode "0xe0 0x73 0xe0 0xf3". It can
> also be used toggle wireless state but this can also be
> distro-dependent. This scancode does nothing on Ubuntu 14.10.
>=20

I would suggest you to use program input-events for reading=20
pressed keys as it show all key events from kernel and it is=20
working per input device (so it is possible to check if event=20
comes from AT keyboard, WMI or other driver). If there is problem=20
with WMI driver (it reports both key press and BIOS do some=20
change) we can patch WMI driver to prevent another looping=20
problem...

> 2. There are two systems with working ARBT (XPS 13 9333 and
> Inspiron 7447). Calling ARBT(1) changes BIOS behaviours, and
> this matches to Dell's document. We should include it in the
> patch for maximum capability.
>=20

How it change BIOS behaviour?

>=20
> [1] dell-wireless is only tested 3.16.
> [2] dell-rbtn is tested on 3.16 and 3.18, but no differences
> are observed. [3]
> http://people.canonical.com/~alexhung/dell-wireless/ [4]
> http://people.canonical.com/~alexhung/dell-rbtn/
>=20

Next I would suggest you to test clean system without fanny=20
software like NetworkManager. Previously we saw that=20
NetworkManager change state of network devices and rfkill=20
softstates so it can interact with kernel. I think that new=20
driver in kernel should work also without NetworkManager and also=20
there are people who use alternative software (and not=20
NetworkManager). I know that Ubuntu has installed & enabled=20
NetworkManager by default, so some results in your table could=20
have values changed by NetworkManager and not by kernel.

And I have one question: Does Inspirion 5721 have ACPI DELRBTN=20
device (instead DELLABCE).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1624474.KblB4eBZ3U
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSX4pYACgkQi/DJPQPkQ1LSzACgpJ32widJg+EtgoML85oxd6MC
tDEAoJEnMa3eTeqahEcJnowISRPSmd36
=r8x5
-----END PGP SIGNATURE-----

--nextPart1624474.KblB4eBZ3U--
