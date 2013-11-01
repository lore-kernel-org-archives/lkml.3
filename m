Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab3KAEtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 00:49:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab3KAEtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 00:49:08 -0400
Date: Fri, 1 Nov 2013 15:48:54 +1100
From: NeilBrown <neilb@suse.de>
To: Jonathan Cameron <jic23@cam.ac.uk>, Grant Likely <grant.likely@linaro.org>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH] itg3200: add dt support.
Message-ID: <20131101154854.2d7d1432@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1D4iUvW/8qhMypbgIll/z08"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1D4iUvW/8qhMypbgIll/z08
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



No new configuration, just a 'compatible' string and documentation.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Documentation/devicetree/bindings/iio/gyro/itg3200.txt b/Docum=
entation/devicetree/bindings/iio/gyro/itg3200.txt
new file mode 100644
index 000000000000..4581620632df
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
@@ -0,0 +1,20 @@
+* InvenSense ITG3200 3-axis gyroscope
+
+Required properties:
+
+  - compatible : "invensense,itg3200"
+  - reg : I2C address, typically 0x68
+
+Optional properties:
+
+  - interrupt-parent : should be the phandle for the interrupt controller
+  - interrupts : interrupt mapping for GPIO IRQ
+
+Example:
+
+itg3200@68 {
+	compatible =3D "invensense,itg3200";
+	reg =3D <0x68>;
+	interrupt-parent =3D <&gpio2>;
+	interrupts =3D <24 IRQ_TYPE_EDGE_RISING>;
+};
diff --git a/drivers/iio/gyro/itg3200_core.c b/drivers/iio/gyro/itg3200_cor=
e.c
index 4d3f3b92b361..1ed3003ef41a 100644
--- a/drivers/iio/gyro/itg3200_core.c
+++ b/drivers/iio/gyro/itg3200_core.c
@@ -374,10 +374,17 @@ static const struct i2c_device_id itg3200_id[] =3D {
 };
 MODULE_DEVICE_TABLE(i2c, itg3200_id);
=20
+static const struct of_device_id itg3200_of_match[] =3D {
+	{ .compatible =3D "invensense,itg3200", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, itg3200_of_match);
+
 static struct i2c_driver itg3200_driver =3D {
 	.driver =3D {
 		.owner  =3D THIS_MODULE,
 		.name	=3D "itg3200",
+		.of_match_table =3D of_match_ptr(itg3200_of_match),
 	},
 	.id_table	=3D itg3200_id,
 	.probe		=3D itg3200_probe,

--Sig_/1D4iUvW/8qhMypbgIll/z08
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnMytjnsnt1WYoG5AQLiWA/+Nibv+NNGtFcOpNN04LERDj55EdvwGdCz
4rExzoKTb6/aE7SvuyfQ1Vv1eZemJxOW8SOyepunzE/ZiSO4hX226FKZzMYFm4Gj
TN30sugLVkggjf/tJKOG6RQOdxfod9OYEZac1clF/7DIZG4luRTvEJjd+09Pqjrp
g2bkNwk0+zfqa4a5wNdqZo1OZSgA1vypuatNTL/KLkqZMqKiTvgfi8oCxVXmpPuB
82g4ajGR0TBmiTG8NcwvWut1v2X4Fywp1JGyVv+g5MFa+YtH8N8hCNdAYC05l8d5
TTRciV2ILR2srw65z3cj9+2w+VQVOzvxz4NafOjmx4/W7K27HjTq51b35uin6Mz9
65ef6hiQGtsPt0JFJy7LDvc6OIijIcRFM+QvYYJSDnCziQ8klb5wxdAIj3wlOYDk
ts4hvLN19/oZjMxqjkanXfi1mHGabJo1R6Vhf3Vo8aZxvfR0V2DXoJSfi01rexjW
IhANs19D3lXLRKDdLEQx0f6DoCYxGcHJtfGTYHMBFriLBnCqnguLceRYMJ/1JJaJ
HTj+itF5gq9VnkSOre9owIC8SW5O9tiw2H6aT1id0dJIlCLTVHD3Qdxm4+4g9kXM
BVikGWRGs7k7AN5RTjEoXvSI2Wfx4qWmtEnzcFtkVVWjm18JYW01hWXwlg/Thr/e
RVXn9bkyL5U=
=VA0q
-----END PGP SIGNATURE-----

--Sig_/1D4iUvW/8qhMypbgIll/z08--
