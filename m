Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaKHAWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:22:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaKHAWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:22:37 -0500
Date: Sat, 8 Nov 2014 11:22:27 +1100
From: NeilBrown <neilb@suse.de>
To: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>
Subject: [PATCH] mfd: twl4030-power: Support compatible = "ti,twl4030-power"
 again.
Message-ID: <20141108112227.256f93ce@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cq09/Z+29dLrLUzHxY=9//p"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cq09/Z+29dLrLUzHxY=9//p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


commit e7cd1d1eb16fcdf53001b926187a82f1f3e1a7e6
    mfd: twl4030-power: Add generic reset configuration

claims:
    Let's add device tree support and configure things for warm reset
    as the default when compatible =3D "ti,twl4030-power".
and
    Documentation/devicetree/bindings/mfd/twl4030-power.txt
claims that "ti,twl4030-power" is still a valid "compatible" setting.

However the current driver fails to probe with that 'compatible'
setting.
Restore the old default.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 4d3ff3771491..1a7794f6be15 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -776,6 +776,10 @@ static struct twl4030_power_data osc_off_idle =3D {
=20
 static struct of_device_id twl4030_power_of_match[] =3D {
 	{
+		.compatible =3D "ti,twl4030-power",
+		.data =3D NULL,
+	},
+	{
 		.compatible =3D "ti,twl4030-power-reset",
 		.data =3D &omap3_reset,
 	},

--Sig_/cq09/Z+29dLrLUzHxY=9//p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF1iQznsnt1WYoG5AQJe6w//T2X8r6OoiUx10lZB7NOECJCoRU3tdgIV
5BWHSe8pfsnDb5EXBKFG+UMPSOmKC7QkmT2bY5s4mOqV+E7kHGOWnLOuMbDQ4TnS
V1qhw45dojq4un+AYL2JD5FEFWWXdvWtKlQAI9hfKEDZhJ/b/FxW2+RBQ7PokPda
GPJV8tj4NzOwjhsgKKGwn25K1JZzbGzvhARXZDbBvublPY4u8fnSA413OMgyHZki
0ed8FOCoiNDDWdKbSpRXF4b1kBATjsd58WAyvAI0uRlFT/yK4ktzgOUkucjqohy3
Nw7g4bx/ZV0XlDeFi0o9Ckz52IkgjOs8t0g+K/YRCmEKYPOhdVbJwYOxa22agYUV
05Obe3msp2Z5QlTYfZh7uXR88tNkdpdzV2Je4fvobwR1V7bFdACLdgu8gDzvjIf9
yT0NoGrJpABXrDgQFAXeYZHJvMUvK4k582/G7Ty637XeG6GpI/pMSLQ3TigF7dSY
4EF5Ex3AvE/i+AMl30A/INqp1oqS1LLRNrN0183puYuh0p/MiAvYEIjZu6VgMBJl
WeHWmupIZX7VwH+cwTdtWfPBrSaajSVW1lfSWrSVEZ8H2Cqd4Sv/VGxOL1pL2qRL
/kWuMlZRzpCRyqQUM0c1LdhyM1xgcd2usXvuNSiK1cC73pnPoImr9lZovMCn9xD1
LIQHLFdx0p0=
=TVOe
-----END PGP SIGNATURE-----

--Sig_/cq09/Z+29dLrLUzHxY=9//p--
