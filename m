Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab3CZGTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:19:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46836 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759050Ab3CZGTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:19:03 -0400
Date: Tue, 26 Mar 2013 17:18:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>, Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the final tree (v4l-dvb
 tree related)
Message-Id: <20130326171847.18cd41b85d3caee6373d9447@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_17_18_47_+1100_=o/P5CXbM8431v4d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_17_18_47_+1100_=o/P5CXbM8431v4d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c: In function 'solo_enc_d=
efault':
drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:1031:7: error: case labe=
l does not reduce to an integer constant
drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:1035:7: error: case labe=
l does not reduce to an integer constant

I am not sure why this has suddenly appeared, but I have disabled the
driver for now using this patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 26 Mar 2013 17:14:47 +1100
Subject: [PATCH] disable solo6x10 driver due to build errors

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/media/solo6x10/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media=
/solo6x10/Kconfig
index ec32776..a6a970f 100644
--- a/drivers/staging/media/solo6x10/Kconfig
+++ b/drivers/staging/media/solo6x10/Kconfig
@@ -1,6 +1,7 @@
 config SOLO6X10
 	tristate "Softlogic 6x10 MPEG codec cards"
 	depends on PCI && VIDEO_DEV && SND && I2C
+	depends on BROKEN
 	select VIDEOBUF2_DMA_SG
 	select VIDEOBUF2_DMA_CONTIG
 	select SND_PCM
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Mar_2013_17_18_47_+1100_=o/P5CXbM8431v4d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUT3HAAoJEECxmPOUX5FE9RMP/15Ek741drlKSfXJ/OE639Yt
Nqc2N3+IwASsqtVUTKRYPBhEfqUi3xMDszEhJ7WRR4zF33MNl0JZ3rIVDWmUOj/M
i/QlaEhWm9CZZfQqyBuGpLKmPbrm3BgpTkBpHTwa1gr2DvNiv0pozq5i+Fu8dhvy
Npaxx8LhBVKIW/BqmJqxcKX4OfBhn6QEVFDm/xL+zkMG61jugh48qfCR4Dyu+LQk
Up94m7e0bm1jLGrYs+gpqxkxqaYfCIUK0gn/eEW3seYoGiQG3jOesw5eyj0u7Mcs
aN8OquX75TZvZAp6IgzZY5SqyR2akfojIEA3PFjBGUmP4NTqyWuIT8jBTMDJ4hja
41wXf9d6mE9cNf8c6f/6TtngBG2Tq4ggtLhN5xGKi9WVAjvjYoZo40d1qCf6nB1n
pxErezKUy/0z5NtuPb96XxA19WWaiseidw4LgZFtBbkvnU0Av1kwQfAwT/mO4rX7
glmX0RpKg5GzrAjsK/0cF43S59TYacgFYx29BG7YVzUsbGsg4I8MSQWg2pUwldIk
gxph8lR4EdbUhWu8CKQq4G/Zzaa1Yf7uziLbJ0zfvMVMq7GgxdtSW1CkW13C6e04
BzWuJUiHum96uLTPRnG2Ow9Fia1lcALkL+IPUf6pTWxORNI5px3BFwQfaz6L8rxP
U08IGoQ6+e3/zp7p3OS7
=/uUH
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_17_18_47_+1100_=o/P5CXbM8431v4d--
