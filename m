Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaKQIJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:09:20 -0500
Received: from ozlabs.org ([103.22.144.67]:36435 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaKQIJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:09:19 -0500
Date: Mon, 17 Nov 2014 19:09:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luc Verhaegen <libv@skynet.be>, Hans de Goede <hdegoede@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: linux-next: build failure after merge of the omap_dss2 tree
Message-ID: <20141117190905.4e96294a@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/epK8nW/5tACmWK7uTP44.BT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/epK8nW/5tACmWK7uTP44.BT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

After merging the omap_dss2 tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/video/fbdev/simplefb.c: In function 'simplefb_clocks_init':
drivers/video/fbdev/simplefb.c:207:2: error: implicit declaration of functi=
on 'of_clk_get_parent_count' [-Werror=3Dimplicit-function-declaration]
  par->clk_count =3D of_clk_get_parent_count(np);
  ^

Caused by commit fc219bfd5b2e ("simplefb: add clock handling code").
This build does not have CONFIG_COMMON_CLK set.

I have added the following fix for today (there is probably a better
one):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 17 Nov 2014 19:05:42 +1100
Subject: [PATCH] simplefb: make it depend on CONFIG_COMMON_CLK

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/video/fbdev/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 025b439d4fe1..1f0298e166c3 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2457,6 +2457,7 @@ config FB_HYPERV
 config FB_SIMPLE
 	bool "Simple framebuffer support"
 	depends on (FB =3D y)
+	depends on COMMON_CLK
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
--=20
2.1.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/epK8nW/5tACmWK7uTP44.BT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUaa0sAAoJEMDTa8Ir7ZwVWGAP/i6B1Z51iBNzwZ0xBeOjFUyX
loo3Giak4yubaTGDnp+42Yby46BuKTw/TCygkmQNmUB62h+XutjxvWnqxCdZAi0I
/+/dMD0ZGhdGGu3aobXfnS0HXQ3ewwLjhd9u7qbni1vnpxqYJ1DU4NQ5kbeMmFDR
7xl/Yfo+wjTvPZBaPi5OrzqnI2c9j9TQWVjPbOnl+R6mKlTeKZm7bhzC2loXGNCk
M9gPkFBMyknortmA7cS4MDtvApYAGjP8Fj/e3BrL1GccXhNxRZ0xVs45SbZeL0Bv
N1OuXERoahAfBGStheF/Jt9qFxhkgk8SjeoY0H+nHdT7KPHFIvRylGq2Ip77yG/R
devbbVcDzfaAKJZ9Qrj/R0RLib6DE1UjBTeI3HsKLO08mb1c/CTS6KLtvQLXhcVw
7KERSGb7iB1x7sbIRNhcSdBni8Hn7MWze729sUxZsGcgBVNSxxH/Uc08v1MkUTGP
t1mQV2iUUp+C/sjYKdBV042Xb+IygbqaTxGseYHLeF+8B2xjJ7JdaTvqeBrzyszz
YVpNeg8G8I4rD9fB1qGUfg6HliRziYzDY8aRXPkvn6u8V2abuUesP1mr/Uwz42AK
UL5xIgcZPy4DRiEfMG60x2F2e9cryofHch/8Jazm3j+VcHepZmCc2kbPJnVwynvR
tQ3ziif4CgYXciQUpNRy
=3pno
-----END PGP SIGNATURE-----

--Sig_/epK8nW/5tACmWK7uTP44.BT--
