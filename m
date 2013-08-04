Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3HEGy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:54:58 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:51137 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3HEGy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:54:57 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Milo Kim (Woogyom) <milo.kim@ti.com>
Subject: leds-lp5523: Broken commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0
Date: Sun, 4 Aug 2013 11:46:03 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.0-rc7+radeon+synaptics-generic; KDE/4.10.5; x86_64; ; )
Cc: Bryan Wu <cooloney@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6882315.tbJRuXXNvM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308041146.03970@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6882315.tbJRuXXNvM
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

git commit "leds-lp5523: use generic firmware interface"=20
db6eaf8388a413a5ee1b4547ce78506b9c6456b0 introduced in kernel=20
3.10 changed user space API for modifing lp5523 led patterns via=20
/sys.

Before this commit there were sysfs attributes engineX_mode,=20
engineX_load and engineX_leds (for every engine X).

Now (after commit) there are sysfs attributes: select_engine,=20
loading and data (see: 10c06d178df11b0b2b746321a80ea14241997127=20
for description). Old sysfs attributes were removed.

So commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0 totally broke=20
all existing userspace applications which use lp5523 leds.

This also broke application MCE which is used on Nokia N900 phone=20
for changing LED patterns in lp5523 led.

I think that kernel api which is used by userspace applications=20
(like attributes in /sys) should not be changed in way that=20
totally broke existing applications.

Can you fix this api problem? (maybe adding old sysfs attributes=20
which would call new api function...)

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6882315.tbJRuXXNvM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlH+ItsACgkQi/DJPQPkQ1KV3QCfWUwRwI27pdzUIrvWkuGFYgPu
UqgAnAj4Y3XdR5jVutkGt7pwjaM571ED
=kZgT
-----END PGP SIGNATURE-----

--nextPart6882315.tbJRuXXNvM--
