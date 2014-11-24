Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaKXWQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:16:17 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34652 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKXWQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:16:15 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Mon, 24 Nov 2014 23:16:12 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201406182220.22818@pali> <CAOMZO5DZSxeTC9fKYXk6XBAG-03qW+TM_8HS_3M8Mkbd-iEdzg@mail.gmail.com>
In-Reply-To: <CAOMZO5DZSxeTC9fKYXk6XBAG-03qW+TM_8HS_3M8Mkbd-iEdzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1613410.pvag9Z3N3E";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411242316.12215@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1613410.pvag9Z3N3E
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 June 2014 23:53:00 Fabio Estevam wrote:
> On Wed, Jun 18, 2014 at 5:20 PM, Pali Roh=C3=A1r <pali.rohar@gmail.com> w=
rote:
> > So how to read Revision and Serial number in DT based
> > kernel?
>=20
> $ cat /sys/bus/soc/devices/soc0/soc_id
> i.MX6SX
>=20
> $ cat /sys/bus/soc/devices/soc0/revision
> 1.0
>=20
> $ cat /sys/bus/soc/devices/soc0/machine
> Freescale i.MX6 SoloX SDB Board

This does *not* working with DT based boot!

$ cat /sys/bus/soc/devices/soc0/soc_id
cat: can't open '/sys/bus/soc/devices/soc0/soc_id': No such file or directo=
ry
$ cat /sys/bus/soc/devices/soc0/revision=20
ES3.1
$ cat /sys/bus/soc/devices/soc0/machine=20
OMAP3430/3530


Here is output from *non* DT based boot:

# busybox cat /proc/cpuinfo=20
processor       : 0
model name      : ARMv7 Processor rev 3 (v7l)
=46eatures        : swp half thumb fastmult vfp edsp thumbee neon=20
vfpv3 tls vfpd32=20
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x2
CPU part        : 0xc08
CPU revision    : 3

Hardware        : Nokia RX-51 board
Revision        : 0012
Serial          : 0000000000000000


As you can see in those files are totally *different* values.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1613410.pvag9Z3N3E
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRzriwACgkQi/DJPQPkQ1Lg6gCgxLBys+e+GSUm1RWu7R18YgmD
sj4AoLnG1hxu6BoDI6FGNBUw+qEDyZiT
=fPs+
-----END PGP SIGNATURE-----

--nextPart1613410.pvag9Z3N3E--
