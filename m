Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3ARPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:25:29 -0500
Received: from mrkva.eu ([83.167.228.102]:57605 "EHLO mail.mrkva.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab3ARPZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:25:28 -0500
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2013 10:25:28 EST
Message-ID: <50F96746.1080304@mrkva.eu>
Date: Fri, 18 Jan 2013 16:16:22 +0100
From: Radek Pilar <mrkva@mrkva.eu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130116 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Suspend to RAM - freeze & sync
X-Enigmail-Version: 1.5
OpenPGP: id=E60DBF0D
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2KEOAMLKCKXESHPWDQTLB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2KEOAMLKCKXESHPWDQTLB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,
I'm trying to implement feature that removes cryptsetup keys from RAM on
suspend to RAM: mounts ramfs, unpacks initramfs to ramfs, moves /proc
/dev and /sys to ramfs, chroots, calls luksSuspend, suspends system
using /sys/power/state, after resume calls luksResume and cleans up.
However, there is a small issue I wasn't able to solve: after calling
luksSuspend, all attempts to access suspended device blocks - so most
likely some processes won't be able to freeze. The same issue will be
with sync just before suspend - if there are some data to be written,
sync() blocks. If I comment out freeze and sync from the suspend code,
it suspends (and wakes up) just fine - however, that patch will never be
accepted.
Is there any *correct* way to do this? (Skip freeze/sync on demand)?
Thanks
Radek Pilar


------enig2KEOAMLKCKXESHPWDQTLB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJQ+WdNAAoJEIiYJZPmDb8N3U4QAKjkUSYFi3RGgl1lRl1Q6xFf
e4e6d1bU1NzL7hCm8X0hw6hqKg/+d8OzpLbLbNjBo0N4IN8McMtLIRPjWfncj3IR
m4Vq6aJ2rUdezY85ActRFu8PUk23mUra0IIQxazt/ACztfAeKHf6FUDCNy8pk2b1
RXlnDCImW/1daITZZx5CkSMBP0AvniT+PvUTFzzqAEsqV4gTL81iQrTdVRKyu+fA
closn4SfyL+G/a725ILHN69UDof+nmldOXJgRJtxfT50mDmliOhRW0qpYSbahYQm
g7jQjHLEGlXVtG3r6kuXdS9icAO/cz73aYKOQ41RPog8jPBpo7n0Ze90Io6P5WqS
ZM6Dhmf2S9pXUN1IhlYucm/DFJGD4CQIm78LvdjHz5Hjs64ubb2IMwtHb8qIhBw+
7I0dM7kscQ/AFvVvpLuAwbThR9cGZDapeiBvYvR61ygXkcmihUxRDt5oH92v09Bi
nM7HYxWemhvTqpKvl8sbYSysfsugzoaTT3blvRwaf35J7fTAvI2Ph1k/gwWnIAtZ
y6TWm+1pTbfNCO+ABvJcfBNxe4RmRqXTzzgTNBTKxUjtljlRmznTGT2DDleGvziL
5VsQo4NveRCiIL1ccUarIfsVQGLcLqSHjyIWlRLSD+AltnFkLpOZ6Q4RwTkMmU9l
m7dQ8ax1I/E+YASEeZKQ
=zjTc
-----END PGP SIGNATURE-----

------enig2KEOAMLKCKXESHPWDQTLB--
