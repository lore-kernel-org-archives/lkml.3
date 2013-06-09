Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3FIJYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 05:24:47 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:51887 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3FIJYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 05:24:45 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: N900 device tree conversion: how to do first step
Date: Sun, 9 Jun 2013 11:24:40 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc4+uvd+synaptics-generic; KDE/4.10.4; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        aaro.koskinen@iki.fi, linux-omap@vger.kernel.org,
        lauri.leukkunen@nokia.com
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
In-Reply-To: <20130609015944.GA23559@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5024910.E8RVTgHMGR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201306091124.41251@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5024910.E8RVTgHMGR
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 09 June 2013 03:59:44 Pavel Machek wrote:
> Hi!
>=20
> I'd like to convert Nokia N900 to device tree.
>=20
> Unfortunately, serial port is not easily available (very
> special cable would be needed, does someone know where to get
> one?) and I don't have BDI (and very special cable would be
> needed, too).
>=20

Hello,

I used serial port only in qemu for debugging. Maybe you can try
to play with qemu first. Qemu has good n900 HW support.

But problematic is to create n900 mtd nand image bootable in
qemu, because it needs closed source nokia bootloader and this
needs to have CAL partition with some unknown data with is
proprietary format.

Nevertheless, there is prebuilded qemu image with maemo5 and with
special version of nokia patches qemu, which was (and still is)
very good for testing anything for n900. Special version of qemu
plus qemu image is part of MADDE development tool, look here:

Info: http://wiki.maemo.org/MADDE
Download link: http://tablets-dev.nokia.com/MADDE.php

Except skinning support and Opengl ES all other nokia patches were
included into Linaro version of qemu, so you can use it without
problems. But you still need proprietary bootloader and correct
CAL partition.

But, nokia released closed redistributable version of bootloader
for qemu and (proprietary) tool which generating mtd nand
partition. You can pass kernel, initfs, rootfs images and it
create correct mtd layout and automatically creating CAL.

Proprietary n900 bootloader (two parts!) for qemu is here:
http://download.meego.com/live/Trunk:/non-oss:/Testing/Trunk_Testing/i586/n=
olo-qemu-0.20100910-1.2.i586.rpm

Proprietary tool for creating mtd nand file is here:
http://download.meego.com/live/Trunk:/non-oss:/Testing/Trunk_Testing/i586/q=
flasher-21-1.2.i586.rpm

PS: Sorry for too many closed SW, but there is no FOSS equivalent
and this is the only one option how to use qemu n900 hw support.
U-Boot is ported to n900, but depends on Nokia bootloader...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5024910.E8RVTgHMGR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlG0SdkACgkQi/DJPQPkQ1JTmgCgtTUjEUwivW/hkR7tPIdRzZoA
P9YAoISSHtgZpFOKtYqkfUctbG3YDs8y
=Chox
-----END PGP SIGNATURE-----

--nextPart5024910.E8RVTgHMGR--
