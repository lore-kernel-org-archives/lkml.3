Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab3KSAab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:30:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3KSAa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:30:28 -0500
Date: Tue, 19 Nov 2013 11:30:13 +1100
From: NeilBrown <neilb@suse.de>
To: Jonathan Cameron <jic23@cam.ac.uk>, Grant Likely <grant.likely@linaro.org>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH v2] itg3200: add dt support.
Message-ID: <20131119113013.39dae3cd@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cPIpWNvpMxBh2XGpcbknpf0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cPIpWNvpMxBh2XGpcbknpf0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



No new configuration, just a 'compatible' string and documentation.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt new file mode 1006=
44
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
+  - interrupts : interrupt mapping for IRQ
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

--Sig_/cPIpWNvpMxBh2XGpcbknpf0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoqxFTnsnt1WYoG5AQKdPBAAoP05W/2BJzs++/WDOwUXBSUW+wziobx2
FdX3pW4pQ4iC0OKzxW9GqJYPLp6G2pqMP3yp6J5NYvxkLUf2sxPEDD4Fi6ZMyNLJ
cdFdt2+GBdFMyKnw2SH9zaQTydgT8t5DPumBuWcQTONljYnJOmtxwYRdMxzdE9Gn
QBa7yn4epf3u3BTqfexuuefoho2jWsQUSRntqXXb769GsRA14kVRyBz8MKZmnIpa
Vdpw0uOTn+7ozmg6gUQkny/OWGPwtvaAYhifORlLqHQ6sE8hmZoCqIrmwId4vfA5
wCbtAbMRc9nUcmpNtjFEzXwPtF1LQavbLKMFLa0obNQqQF4gSoliF7TOcKm8hEke
6hQW2Bx/wzhLtqCD8unWmPMwsWAXFgC6aHkUdfXOMdiOw9KW0mdKTe1HoB56o2ke
Vcm/qpUv+J1tToHZ0RA51wFvyF1ct6tQB7bkrxM7h91VfHkLNxLFjx5cFH9tLIQ4
aK8T2sV3HcsDRDwTmuc9srm8hnh5/VkHZ/GnEQ7ocQXi84QRo+r2iMp5oAIED90u
LAd7mMo6WWMf1aX7Uc/HSsflf5os+azbnTQIzdgZztW0L1AoNT6zqJKtdAuhDEqX
knM6Iq4Td9EkAspqvzQaw5atHBkdamj95b6ZTmFmdJuSxE+rYs8mqkwlat0nGl7Z
jH1PtXUPhg4=
=RZI0
-----END PGP SIGNATURE-----

--Sig_/cPIpWNvpMxBh2XGpcbknpf0--
