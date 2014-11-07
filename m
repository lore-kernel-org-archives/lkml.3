Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaKGXao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:30:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbaKGXam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:30:42 -0500
Date: Sat, 8 Nov 2014 10:30:32 +1100
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>, Tony Lindgren <tony@atomide.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>
Subject: [PATCH] w1: omap-hdq: support device probing with device-tree.
Message-ID: <20141108103032.5426db7a@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/7ddOIc1J6FJuK0j4OzOtqRn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7ddOIc1J6FJuK0j4OzOtqRn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



This driver has no 'compatible' string and so is not found when
using device-tree.

Add one with value to match
		hdqw1w: 1w@480b2000 {
device in omap3.dtsi.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Documentation/devicetree/bindings/w1/omap-hdq.txt b/Documentat=
ion/devicetree/bindings/w1/omap-hdq.txt
new file mode 100644
index 000000000000..fef794741bd1
--- /dev/null
+++ b/Documentation/devicetree/bindings/w1/omap-hdq.txt
@@ -0,0 +1,17 @@
+* OMAP HDQ One wire bus master controller
+
+Required properties:
+- compatible : should be "ti,omap3-1w"
+- reg : Address and length of the register set for the device
+- interrupts : interrupt line.
+- ti,hwmods : "hdq1w"
+
+Example:
+
+- From omap3.dtsi
+  hdqw1w: 1w@480b2000 {
+	compatible =3D "ti,omap3-1w";
+	reg =3D <0x480b2000 0x1000>;
+	interrupts =3D <58>;
+	ti,hwmods =3D "hdq1w";
+  };
diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 9900e8ec7393..03321d6a2684 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -72,11 +72,18 @@ struct hdq_data {
 static int omap_hdq_probe(struct platform_device *pdev);
 static int omap_hdq_remove(struct platform_device *pdev);
=20
+static struct of_device_id omap_hdq_dt_ids[] =3D {
+	{ .compatible =3D "ti,omap3-1w" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, omap_hdq_dt_ids);
+
 static struct platform_driver omap_hdq_driver =3D {
 	.probe =3D	omap_hdq_probe,
 	.remove =3D	omap_hdq_remove,
 	.driver =3D	{
 		.name =3D	"omap_hdq",
+		.of_match_table =3D omap_hdq_dt_ids,
 	},
 };
=20

--Sig_/7ddOIc1J6FJuK0j4OzOtqRn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF1WGDnsnt1WYoG5AQKY8A//QH85O0cW6uytzdkQ9Tr1eFj7TzIm0gYF
eZ6nzYSHaqDaHn7PlBn7YHEdCxPw2hfksdFDvDoUObCxx6UvEMuuCjO+sqneVxJd
5kU9aCb6nk7rUzakfbRoUyCZDaQ03b5SUmLo840/O7alVKQcu+g/Lwom+IFLnsHC
z8XeGZNJL2OLdT5XKmrCKcgg6dhjSoqgE5AGUQK8fyinpZohFpMWWE8Kxis5NJ0R
kpYBUVzLVW+VYgRHtBo0MUt1NxThZ/Qqdq5yh6vW/t6ykamoGamVpVzJ1Kp9274+
Z89PCjJ3VKZoSV/FtcyTT8bvw7zd9odfY7vcXJYqx+XTvVYPCSFCxK1lsjjzVprF
akYQJv5Cu2XGhb/MS6gacNjtdFjJhWLMKIucpT4NPxL3UzXPdHmsiNdP/NqKIJWF
/LuiQN/4i5zF4hK05TA7gEPkCK80kH8RnSnw1MHNGQwI+n9sNEarPHIUQViKEpqw
NJad44hXgLjRo9wftEhKWlO3UGd67FKhhs4csfOILNyt0JRVRBJ21piyhS4VB87O
9PxeEoS7arA6S4XCFxe50XJwVDo2galkPepxtZJKS1zBevkH0ptUeIzFLqCUwUBe
eZbzCYBPVYzo3PGQcBwtmi499AWLV0geS4TyGL0ntLZMz60H+hdPGrIAljofoxrD
qEwTMsH1+kc=
=sYx4
-----END PGP SIGNATURE-----

--Sig_/7ddOIc1J6FJuK0j4OzOtqRn--
