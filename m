Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaIYGap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:30:45 -0400
Received: from ozlabs.org ([103.22.144.67]:47631 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbaIYGao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:30:44 -0400
Date: Thu, 25 Sep 2014 16:30:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: linux-next: build failure after merge of the tty tree
Message-ID: <20140925163036.5f3281eb@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.A_wmVP3E71tbhIbrSJIdz7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.A_wmVP3E71tbhIbrSJIdz7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (arm multi_v7_defconfi=
g)
failed like this:

In file included from init/do_mounts.c:15:0:
include/linux/tty.h:267:9: error: width of 'unused' exceeds its type
         unused:62;
         ^
include/linux/tty.h:271:9: error: width of 'unused_ctrl' exceeds its type
         unused_ctrl:55;
         ^
In file included from init/main.c:28:0:
include/linux/tty.h:267:9: error: width of 'unused' exceeds its type
         unused:62;
         ^
include/linux/tty.h:271:9: error: width of 'unused_ctrl' exceeds its type
         unused_ctrl:55;
         ^
In file included from include/linux/serial_core.h:29:0,
                 from include/linux/serial_s3c.h:236,
                 from arch/arm/mach-exynos/exynos.c:15:
include/linux/tty.h:267:9: error: width of 'unused' exceeds its type
         unused:62;
         ^
include/linux/tty.h:271:9: error: width of 'unused_ctrl' exceeds its type
         unused_ctrl:55;
         ^
In file included from include/linux/serial_core.h:29:0,
                 from include/linux/platform_data/serial-omap.h:20,
                 from arch/arm/mach-omap2/serial.c:30:
include/linux/tty.h:267:9: error: width of 'unused' exceeds its type
         unused:62;
         ^
include/linux/tty.h:271:9: error: width of 'unused_ctrl' exceeds its type
         unused_ctrl:55;
         ^

Caused by commits c545b66c6922 ("tty: Serialize tcflow() with other tty
flow control changes") and 99416322dd16 ("tty: Workaround Alpha
non-atomic byte storage in tty_struct").  There are still 32 bit
architectures out there!  ;-)

I have used the tty tree from next-20140924 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/.A_wmVP3E71tbhIbrSJIdz7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUI7aRAAoJEMDTa8Ir7ZwV7/cP/0oD7hIp8Q2N59nuKlXW3SAZ
yAqUVW8B4jkQobUhznBaQK609unUGvn7uykPZPhu+o3GXZ6Wu8WGyrg9+1/CZ82I
cW0Vw0+M2vmJ62Ina4LPB3vJpzlZ+80RU1to4qkyBxcZlHlKihftubqM+GLzPvKg
Lgsrxt5HigMgcrzLkGKARC9C9crdVZWb2QDSmof2UVl3SF3/ZLrfXNGfK6+1cCPe
O4mCmsYUyBEEA3iKyiztskyCZNgg4wy4Mhq7JVQg2GonOpCelPocfgq6BzeBmeNp
0KA+JxKr4i84lU/STjwfZg/bTLnguGWomYpdgeVttPCzx6Oa8qFwz5nQlUO+Tyof
7s5nZ+f/9Ma59FUnujqBWzP9YeW/yiBLpNNXatbLdZscQQ+GUHxDUIJwIaGoLOQH
qXC/gDJJaH0A7BuV4wWsdm760SXJxSaZ0gG8CA4TiLGXbxGbeJnDOYJFk7kHMNwl
RkxuM2yQd8Mo5yixyRj7pX/nw2OcUKnRsT5uuOzdfE3cQuDJvBFdTbrgTpnER5cr
u1d5tpxMzRZN9HbfhqWFw07PkDgOoSq88o3p/zy8xEGYfyWLa8J1r6+PtbhDk38L
XL35yljlawNXtDhyA7OlSLScaYGroLWTQwAn5/VJS58Q+bkVXSvJYlxcxQZK801q
g7D2lCigwq+OVE6t9Hvu
=Z+hz
-----END PGP SIGNATURE-----

--Sig_/.A_wmVP3E71tbhIbrSJIdz7--
