Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab3HNEcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 00:32:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45472 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3HNEcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 00:32:06 -0400
Date: Wed, 14 Aug 2013 14:31:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: linux-next: manual merge of the tip tree with the omap_dss2 tree
Message-Id: <20130814143152.6586492341a573f87c64a5df@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Aug_2013_14_31_52_+1000_+ImLovAU8C4nR2Aa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Aug_2013_14_31_52_+1000_+ImLovAU8C4nR2Aa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/video/simplefb.c between commit dbb5ff4c2300 ("simplefb: add
support for a8b8g8r8 pixel format") from the omap_dss2 tree and commit
5ef76da644bf ("fbdev: simplefb: add init through platform_data") from the
tip tree.

I fixed it up (I think - see below, please check - I used the latter
version of the above file) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platfor=
m_data/simplefb.h
index 53774b0..c395d4c 100644
--- a/include/linux/platform_data/simplefb.h
+++ b/include/linux/platform_data/simplefb.h
@@ -27,6 +27,7 @@
 	{ "a8r8g8b8", 32, {16, 8}, {8, 8}, {0, 8}, {24, 8}, DRM_FORMAT_ARGB8888 }=
, \
 	{ "x2r10g10b10", 32, {20, 10}, {10, 10}, {0, 10}, {0, 0}, DRM_FORMAT_XRGB=
2101010 }, \
 	{ "a2r10g10b10", 32, {20, 10}, {10, 10}, {0, 10}, {30, 2}, DRM_FORMAT_ARG=
B2101010 }, \
+	{ "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {24, 8}, DRM_FORMAT_ABGR8888 }=
, \
 }
=20
 /*

--Signature=_Wed__14_Aug_2013_14_31_52_+1000_+ImLovAU8C4nR2Aa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCwg9AAoJEECxmPOUX5FE+44P+gJFrI68rnT1bD7NjXWZ6yub
q4gS0SMB6535vUY5IjotvfLgrvDjmPQoc/I/0ap1LWjmjahG98TaZD2L7xY5XRqP
s9r4ZvVDlMTny4GJ4V+q1pn6mUbtF2DXBtIrIQ9+twYi5pzSiyAACc0noadBZHGa
V/VDNQIUVkp/iILFPcoNFPe6J8c3U1B17+Y0UMG+WFk7LqOcmL4tyNyBKjwgngFg
BxCgsOzkPR+hdthH0YMK3bZfmIdCRk+FIeGS2oeYIdsNm2SQ/2tW2yc91309dqou
x2mptrLH+anEXZLlUdy25f55f8agtiXd3/rJQW1Ojl2LlZL9XxzsnGYF2aqt/6zy
njzFlMXUmUMzrwcAcdP4HLAGuSGv4B9mXBmMnc+KOWi2beAdxLYH4/zRiBoqLThA
Ji8fDvTbSjGeF4yOPi1Mq1QjIxBYEggy2FLCQZe0kGHwn7nLcoik79/X5JibGNcX
bAvbanHFVYYN6wNP/edny7cnG0A+fcy7HxbX4aitrxqBvdzXbXn+U8AvANEcEuq2
shQHaR9AmelBEoQyNmKFudPw9a/79dDYDywpVOy7xkLXknLtvfIyXUKIzLrLCQjR
b3ziPeBVmfeUvLt1LlRVPW4XfwMXyc9pjPWbd4NREKwB+F6MtXdKPwBYCeaAamPi
fDX2cCwWVImeqbTm/s/n
=9pmN
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Aug_2013_14_31_52_+1000_+ImLovAU8C4nR2Aa--
