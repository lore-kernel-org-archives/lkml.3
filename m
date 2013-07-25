Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3GYDUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 23:20:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53125 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3GYDUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 23:20:10 -0400
Date: Thu, 25 Jul 2013 13:19:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Won Kang <wkang77@gmail.com>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20130725131959.3c39e033c6fee01328b10119@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__25_Jul_2013_13_19_59_+1000_MInx8rGMCOdQKgKx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Jul_2013_13_19_59_+1000_MInx8rGMCOdQKgKx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/gdm724x/built-in.o: In function `netlink_init':
(.text+0x19b6): multiple definition of `netlink_init'
drivers/staging/gdm72xx/built-in.o:(.text+0x19d5): first defined here
drivers/staging/gdm724x/built-in.o: In function `netlink_exit':
(.text+0x1a2a): multiple definition of `netlink_exit'
drivers/staging/gdm72xx/built-in.o:(.text+0x1a49): first defined here
drivers/staging/gdm724x/built-in.o: In function `netlink_send':
(.text+0x1a4f): multiple definition of `netlink_send'
drivers/staging/gdm72xx/built-in.o:(.text+0x1a67): first defined here

Presumably caused by commit 61e121047645 ("staging: gdm7240: adding LTE
USB driver").  I disabled this driver using this patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 25 Jul 2013 13:16:30 +1000
Subject: [PATCH] staging: disable the gdm724x driver due to build problems

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/gdm724x/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/gdm724x/Kconfig b/drivers/staging/gdm724x/Kcon=
fig
index 10f7be1..85141bd 100644
--- a/drivers/staging/gdm724x/Kconfig
+++ b/drivers/staging/gdm724x/Kconfig
@@ -5,6 +5,7 @@
 config LTE_GDM724X
 	tristate "GCT GDM724x LTE support"
 	depends on NET && USB
+	depends on BROKEN
 	help
 	  This driver supports GCT GDM724x LTE chip based USB modem devices.
 	  It exposes 4 network devices to be used per PDN and 2 tty devices to be
--=20
1.8.3.3


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__25_Jul_2013_13_19_59_+1000_MInx8rGMCOdQKgKx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8JlkAAoJEECxmPOUX5FE/vcP/RAVma5c86pW3e+hPcbwMEGq
8BlyoAb+XEVR0Gtn7DqdOYcKOeDcXEZynnv6BR+fcaZ8IKKgnOqqU6kTKHdplWpq
XFBUoRWRPM7Escurrz25C1mvcehEhcmkfm96QFpikO6fEGmF5mBkp6ykHkC2cVPk
4PWucnFfUR7fKr0TA7dKu6TRysYAsDJE1PlENf4wG19cOka/cOdNl48l070icpAV
fTEPn67lOQuvhgWZ847f4WhWC2hGQl2j+87XX7r3G9CKTr/ADCRAgTJXgN3CjSqU
86moBbcITTGEwoD9i8ef/2ukqrqxmr4NvLsh5ID4lBqardtm/+pgvF2sy4zK+877
0nKMgHehTbaGHRAdFu8ewRS7+s8hFu1fYydnyQBP2VyazQ5zRFegqRekDnsSxcpf
cprOfbMXiXUB3G+qHUVm5Z6VMeU52sagGbuNFiUQB59ONYP9aXypXByXfd4fj4Bj
3a4MaeAvrtVJDMCHbJQ0OhiRBt+pG1+F11u5v3ccB5aiolvWKcFqbF9KN0I1sz5P
z/4J7u0MxMP7quJ4CPxL/lxrl8wvofJQka+S8gmjV2eg+55zk+NQ2GYhziYubIAb
5iInpEYpFaymzGjmtMXlTscWq9fKiKSezyjygTaqCuKxAmF3XzfUakSgvSJ9ddbO
lB8kLyqQUZn7tOFEffYR
=dj5/
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Jul_2013_13_19_59_+1000_MInx8rGMCOdQKgKx--
