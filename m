Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3FSIKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:10:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49026 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab3FSIKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:10:33 -0400
Date: Wed, 19 Jun 2013 18:10:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20130619181031.8b53acc44466ba70a47e1fcd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_18_10_31_+1000_8O.1o8L5ab+RSDey"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_18_10_31_+1000_8O.1o8L5ab+RSDey
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/staging/lustre/include/linux/libcfs/libcfs.h:=
203:0,
                 from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:6=
7,
                 from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:4=
1:
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_de=
v_need_failover':
drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:215:16: error: i=
mplicit declaration of function 'NIPQUAD' [-Werror=3Dimplicit-function-decl=
aration]
  static struct libcfs_debug_msg_data msgdata;      \
                ^
drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:231:2: note: in =
expansion of macro '__CDEBUG'
  __CDEBUG(&cdls, mask, format, ## __VA_ARGS__);\
  ^
drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:238:30: note: in=
 expansion of macro 'CDEBUG_LIMIT'
 #define CERROR(format, ...)  CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                              ^
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2577:3: note: in expans=
ion of macro 'CERROR'
   CERROR("Failed to bind %s:%u.%u.%u.%u to device(%p): %d\n",
   ^

I have once again disabled the building og the lustre client code.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Jun_2013_18_10_31_+1000_8O.1o8L5ab+RSDey
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwWd3AAoJEECxmPOUX5FE13wQAISXZsS0sxPkyIbNFRZicYWw
7mbkyDj7J2MhafuJQ5hts+kA6wrRKLyQnpwR9pyVh1MaxYfanwj69zkK2HV0I+ZJ
dM24sxURPdkdek0HBpsXYtzOKypnIWcsPfcTQ+lmPrHS5e+cLY39+Psgv/kO/rRl
j04CSYWsQS8TeVC4TNW440ChYL6JPAMS1O1neBEqlblHXoFcB1g/0sSeLrH86yGF
utIyUN112uqA9secXpe/4VDrGfnBkN3amzZPOW8rgYmyBQ3zzV06/8RkfWxLyhkE
3pgVC6uwaLndIdlOCNV5MBOTvS5EwXv1rmu6lt51ksz0M7FXhNpSwCbHn2Zv1aAk
Vpy1Pm6iU5JcyViFmVVlPYmTBG/ml5E7lyS8uLSp5aumreGunex9C5nS14KWtfBE
CUIV2f8sB1Qd90ySIj8qogJ/1iwKXUJcJQpiD3v5GKbuLgvcVQvlAT2bJqS9Odb/
6fMX1ph7VlfYG5v4EASj6Xz3AtPHdL2kqiXHTzbebNq9x50+KofrOJGeIkI7Lv2p
Gux4Kr0Glq5qLN15x8ApPSPZf0rdGblcIxTfs2Yn/O1948iUUSTDF2ejKShlhBx0
rhsHVjOC+wSFQau4o/gI8fN7WgnLE7Zs79QUiT8mu5A4DOAc7UAXhrD9OFuB+ANH
3dnVgVZEjthJnksMcKwd
=Bw3w
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_18_10_31_+1000_8O.1o8L5ab+RSDey--
