Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3KAFfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 01:35:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab3KAFfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 01:35:43 -0400
Date: Fri, 1 Nov 2013 16:35:23 +1100
From: NeilBrown <neilb@suse.de>
To: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: [PATCH] hmc5843 - add basic dt support
Message-ID: <20131101163523.10fed501@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HVL5=Zr4ubuUMeMxrO4j793"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HVL5=Zr4ubuUMeMxrO4j793
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



No configuration, just a compatible string and documentation.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt=
 b/Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt
new file mode 100644
index 000000000000..90d5f34db04e
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt
@@ -0,0 +1,17 @@
+* Honeywell HMC5843 magnetometer sensor
+
+Required properties:
+
+  - compatible : should be "honeywell,hmc5843"
+  - reg : the I2C address of the magnetometer - typically 0x1e
+
+Optional properties:
+
+  - gpios : should be device tree identifier of the magnetometer DRDY pin
+
+Example:
+
+hmc5843@1e {
+        compatible =3D "honeywell,hmc5843"
+        reg =3D <0x1e>;
+};
diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/i=
io/magnetometer/hmc5843.c
index c3f3f539e787..829734a82f69 100644
--- a/drivers/staging/iio/magnetometer/hmc5843.c
+++ b/drivers/staging/iio/magnetometer/hmc5843.c
@@ -719,10 +719,17 @@ static const struct i2c_device_id hmc5843_id[] =3D {
 };
 MODULE_DEVICE_TABLE(i2c, hmc5843_id);
=20
+static const struct of_device_id hmc5843_of_match[] =3D {
+	{ .compatible =3D "honeywell,hmc5843" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, hmc5843_of_match);
+
 static struct i2c_driver hmc5843_driver =3D {
 	.driver =3D {
 		.name	=3D "hmc5843",
 		.pm	=3D HMC5843_PM_OPS,
+		.of_match_table =3D of_match_ptr(hmc5843_of_match),
 	},
 	.id_table	=3D hmc5843_id,
 	.probe		=3D hmc5843_probe,

--Sig_/HVL5=Zr4ubuUMeMxrO4j793
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnM9mznsnt1WYoG5AQIzRA//VnX2/SZp33/xFK51uzRi3bF0803q2h4G
0uErbMF/y6DAF00qMveLMrkRcgBxagtLeg83oGpmCXSzBHLUCPusCfCdGE7Yx96v
1nEogmthAuOUMGxup9p0I3ERStGIvWHtrFKM66Mr1CYYD4Cgbp+HmWQsr3J1P2h+
9J7rGSlshwrOHrR9K/CNm4ylFXwnHmXB8ZaeCwpOQ1A7113Znzv42CoYJLiR7Vqp
nrX4mrhq8jms8uxKNg+7kOqvp5Sr3whm11Ivbe1CcrsEvmP3Qu9EgizaBNbN/xwC
cyzLDEuCSFFws3YPeF5B5dNfuxDZDW0SjfbNwAwcFWfr8R4CdQ9jEk4ikHBOQb8M
LwImKUMFDRqgQ2DgEFxYjmb2spGTLz1S6Wy6et47BC5cZ0aTof3fPW8owOMKK88z
xatQnffG7KhqclQKZZFefT9UIIP6idc+3aPMnNiy6vsfSN64ZZFTvq7gL3exF5Tc
2f1OJ6gg9UD5jSTN0TAA+i5BsC4DitH17pteY4aw2MgeL/Ov1TBysBSEXsl6myuy
wsybOqmaiCO/4iu1RdcOX4gd3L2shGirLvSSUVRr9GxgRToQ3vzZEbRcv/YQgA7o
yHAqwrpyQNuLiRpXqUUfsB6H3mkBpohoYHHF65WSZgbh81GcqmY/tz9Y/E0PM5fc
gdXGhErJtgo=
=wKGC
-----END PGP SIGNATURE-----

--Sig_/HVL5=Zr4ubuUMeMxrO4j793--
