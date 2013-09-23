Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3IWEji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 00:39:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49838 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3IWEjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 00:39:37 -0400
Date: Mon, 23 Sep 2013 14:39:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the random tree
Message-Id: <20130923143924.730ce3cbffbebdb7f82ce2cf@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_14_39_24_+1000_iTaHe_7xUJiZAMzk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_14_39_24_+1000_iTaHe_7xUJiZAMzk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

After merging the random tree, today's linux-next build (powerpc64
allnoconfig) produced this warning:

In file included from include/linux/kernel.h:10:0,
                 from include/linux/sched.h:15,
                 from include/linux/utsname.h:5,
                 from drivers/char/random.c:238:
drivers/char/random.c: In function 'add_interrupt_randomness':
include/linux/bitops.h:96:2: warning: 'input[3]' may be used uninitialized =
in this function [-Wmaybe-uninitialized]
  return (word << shift) | (word >> (32 - shift));
  ^
drivers/char/random.c:827:10: note: 'input[3]' was declared here
  __u32   input[4], cycles =3D random_get_entropy();
          ^
In file included from include/linux/kernel.h:10:0,
                 from include/linux/sched.h:15,
                 from include/linux/utsname.h:5,
                 from drivers/char/random.c:238:
include/linux/bitops.h:96:2: warning: 'input[2]' may be used uninitialized =
in this function [-Wmaybe-uninitialized]
  return (word << shift) | (word >> (32 - shift));
  ^
drivers/char/random.c:827:10: note: 'input[2]' was declared here
  __u32   input[4], cycles =3D random_get_entropy();
          ^

Probably introduced by commit d5693ae494f2 ("random: speed up the
fast_mix function by a factor of four").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Sep_2013_14_39_24_+1000_iTaHe_7xUJiZAMzk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP8YAAAoJEECxmPOUX5FE+m0QAJWgmU9AyaZoUtEDdChgLk4K
Clv/gM2LGNUL9O2B3UjLbYOjEEtaZ3dlKwAP+GUZ2k+AMNGCrAp65lbdlYmLPYdJ
A8opNMS5RB9+MwMexhYVK2yPwR4Ualn7Qw+i2rpk2Y3PUcQxXaxO4aSqObgNN4ii
3hAqQZ32RcCc2ts45Syz5ImENP4W1Dt9ArmL7k366SF/10aZ0IIIioCPx8b5gkoM
FoMdztFrkEkhI8J8zMzyBY9DvUkGPM0mjgEEpvyJ8BOPXtxMq+f9nWCLqTNDCj2z
v0iHAFZDGDTmGJsT5nNn7/NeCU/D6Ogrve3SSwUBcg7Kxq3SXfZVK5/xzIoY3Afi
DwQmWWj/HihWnnb2FhMNCwqWGovIVxrByZ+PMV5OP9TgwPhaQIcP8OoddB0OWSUq
PRt8bXybefQ2Ypq0F/4W6vItJhpT7fdYdn4MdiVStzGab2dXUiq2V3q2faqc4D7Y
bfxex3qB1Jy9axMXQGWV8UI7a0NtkJCluKF0W4w/EGIbSwbvFNhNTomF2I0It/kb
ShRN/0HDDdgOSypb9xr59NXkPTqC8FeMRP3bcMNZuN8LVKu355H3ezcmFD4s5Bkg
T41SxWp2nxZKJKHmYJxL0XQ4kVoJbNhgghAsCTvBpfPZ7tHq0DPveHob7I/T7s9P
QPikyuJJjHAzy2GtoIpi
=PUeG
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_14_39_24_+1000_iTaHe_7xUJiZAMzk--
