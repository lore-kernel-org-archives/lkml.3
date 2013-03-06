Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3CFAfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:35:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33703 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab3CFAfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:35:19 -0500
Date: Wed, 6 Mar 2013 11:35:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20130306113508.9c868be103b6b140295c548f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Mar_2013_11_35_08_+1100_Sdlnboqs7UrxdvPv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Mar_2013_11_35_08_+1100_Sdlnboqs7UrxdvPv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/staging/zcache/debug.c:2:0:
drivers/staging/zcache/debug.h: In function 'dec_zcache_obj_count':
drivers/staging/zcache/debug.h:16:2: error: implicit declaration of functio=
n 'BUG_ON' [-Werror=3Dimplicit-function-declaration]

Caused by commit 95bdaee2140e ("zcache: Move debugfs code out of
zcache-main.c file").

I applied this patch for today:

=46rom 24b03cf426007c4e94c6bed81560e436afcc136c Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 6 Mar 2013 11:31:06 +1100
Subject: [PATCH] disable ZCACHE_DEBUG due to build error

In file included from drivers/staging/zcache/debug.c:2:0:
drivers/staging/zcache/debug.h: In function 'dec_zcache_obj_count':
drivers/staging/zcache/debug.h:16:2: error: implicit declaration of functio=
n 'BUG_ON' [-Werror=3Dimplicit-function-declaration]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/zcache/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 2da6cc4..ad47b4b 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -13,6 +13,7 @@ config ZCACHE
 config ZCACHE_DEBUG
 	bool "Enable debug statistics"
 	depends on DEBUG_FS && ZCACHE
+	depends on BROKEN
 	default n
 	help
 	  This is used to provide an debugfs directory with counters of
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__6_Mar_2013_11_35_08_+1100_Sdlnboqs7UrxdvPv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRNo88AAoJEECxmPOUX5FE32QP/Rz9w3FXwtFa1q4CN147zGTk
dyuiFbmjhwSXQHRPjht8pV7IV16dLyQRSM1ljYMxz12uhb8pbznrTqFarLkm44HY
+dNINrHNiDfr5YMm/nYtn4TFyFJYd2UyJcbmh8kHWqmz/ExOo1DEAXTfUCp8ZSBb
QnsE6tFqvawdpJendXVI9EiqVycPnepJQNuHTh29ffmg5KsjNWrWOjJTsr9VzHM+
3xqv05tVFbTKVxfFg6NHbZDA8QjdZCFWGi5nelwTY+2OqWCj3YBOTfgl/DGaW5wq
4bLIHNA2u2Khz5oESgosy2qirqdbc33qxtSbN1zrHVHiibFFV+tsJOHkex2CqlbJ
sXuxt1R3gEJR6KwRAuX1ydVBCwB8WCutkEwDXIxk/XctNvqWv2FqzGeXCp3B938y
60Y9cmkZVVjNqvKcm1eTz3dbwo3z+4Y4fD6wWpGktMyDM6j2xlN/Nd/m7CS60RX0
7gWTsCB8EQEzHpD+ZtlkzSvOcen2i4A/99QkxRalyJPHkdxJ6IsqREENDvcq9ZOx
qmmqK0d7Be0uW2Ke8IaOEGANFH2iUJbl9GjDtUxDGYFcpINKr6Jg+g7UXKlDKY0H
U/tTmZ21uLwmPuYN4XHxV15yM0or/gIqB+s1IGhncES94OmReKPN5J0f2tzSIysn
oPV9SVUzcQxT6rBHEPwy
=xm7T
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Mar_2013_11_35_08_+1100_Sdlnboqs7UrxdvPv--
