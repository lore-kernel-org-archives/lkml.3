Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3KHDUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 22:20:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab3KHDUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 22:20:18 -0500
Date: Fri, 8 Nov 2013 14:20:04 +1100
From: NeilBrown <neilb@suse.de>
To: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: PATCH] LEDS: tca6507 - fix up some comments.
Message-ID: <20131108142004.10e31655@notabene.brown>
In-Reply-To: <CAK5ve-LzYLr0xuvNA3MX=pECPPfAkDFqExPpmQt8GF+9jf5uHg@mail.gmail.com>
References: <20131101134120.13a44225@notabene.brown>
	<CAK5ve-LzYLr0xuvNA3MX=pECPPfAkDFqExPpmQt8GF+9jf5uHg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/35mmyz68LUF1WSnJ4UzQUfW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/35mmyz68LUF1WSnJ4UzQUfW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


In particular fix the capitalisation of GPIO and LED and
correct TCA6507_MAKE_CPIO, but also rewrite the comment about
platform-data to include reference to devicetree.

Reported-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index 93a2b1759054..80c9d69e2bdd 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -8,7 +8,7 @@
  * double-blink.
  *
  * This driver can configure each line either as a 'GPIO' which is out-only
- * (no pull-up) or as an LED with variable brightness and hardware-assisted
+ * (pull-up resistor required) or as an LED with variable brightness and h=
ardware-assisted
  * blinking.
  *
  * Apart from OFF and ON there are three programmable brightness levels wh=
ich
@@ -60,21 +60,26 @@
  * and LEDs using the blink.  It can only be reprogrammed when the appropr=
iate
  * counter is zero.  The MASTER level has a single usage count.
  *
- * Each Led has programmable 'on' and 'off' time as milliseconds.  With ea=
ch
+ * Each LED has programmable 'on' and 'off' time as milliseconds.  With ea=
ch
  * there is a flag saying if it was explicitly requested or defaulted.
  * Similarly the banks know if each time was explicit or a default.  Defau=
lts
  * are permitted to be changed freely - they are not recognised when match=
ing.
  *
  *
- * An led-tca6507 device must be provided with platform data.  This data
- * lists for each output: the name, default trigger, and whether the signal
- * is being used as a GPiO rather than an led.  'struct led_plaform_data'
- * is used for this.  If 'name' is NULL, the output isn't used.  If 'flags'
- * is TCA6507_MAKE_CPIO, the output is a GPO.
- * The "struct led_platform_data" can be embedded in a
- * "struct tca6507_platform_data" which adds a 'gpio_base' for the GPiOs,
- * and a 'setup' callback which is called once the GPiOs are available.
+ * An led-tca6507 device must be provided with platform data or configured
+ * via devicetree.
+ * The platform-data lists for each output: the name, default trigger,
+ * and whether the signal is being used as a GPIO rather than an LED.
+ * 'struct led_plaform_data' is used for this.  If 'name' is NULL, the
+ * output isn't used.  If 'flags' is TCA6507_MAKE_GPIO, the output is
+ * a GPO.  The "struct led_platform_data" can be embedded in a "struct
+ * tca6507_platform_data" which adds a 'gpio_base' for the GPIOs, and
+ * a 'setup' callback which is called once the GPIOs are available.
  *
+ * When configured via devicetree there is one child for each output.
+ * The "reg" determines the output number and "compatible" determines
+ * whether it is an LED or a GPIO.  "linux,default-trigger" can set a
+ * default trigger.
  */
=20
 #include <linux/module.h>
@@ -309,7 +314,7 @@ static void set_level(struct tca6507_chip *tca, int ban=
k, int level)
 	tca->bank[bank].level =3D level;
 }
=20
-/* Record all relevant time code for a given bank */
+/* Record all relevant time codes for a given bank */
 static void set_times(struct tca6507_chip *tca, int bank)
 {
 	int c1, c2;

--Sig_/35mmyz68LUF1WSnJ4UzQUfW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnxYZDnsnt1WYoG5AQJ3UA/7Bv1503iG+UJrfHGukYyYUxvWSrmfO8MU
244E8zXSxImkrtLrd1ok12GGBbmLrG/XJL1FUUMVUZcTMJ3y0RCpbeNbCSjhuLtB
zKl9r7TeixXLePXVQSwzHxagjQtcOZmQgGItTLzEWBq5Ue8J3eHSr7l9S30dB2MC
RdUr1/2sISGon1rvZtCZRjoYFxQ6iCCnJru8vMeJEmmRaZFolmc4wmOEOCmrnpIJ
Od8LfJHJa8xWh1Ug5HEAv+IXVx7r7dgTrQH1WOehlM108MX/rmUnCCKZmex7nnhG
TerriMNTESGEHgFRLHZ25e4GJ9FNQ9p+c1uvx27zzPwYS2TuKQ1xJFx53uY8sc3n
0TubzxpyNx0hufrGx2BlBeHdiclOAnqV9vpinH1oA8PGqnOjhD0NYT2cN3paF9wt
5rGRPuLyat16ODIdyRxdpXwPsFTTbCKupWfDQ8vZM4pVGT3QsZAA4aV0lpEFAip+
k+cNsBhoE6dEld6t9Oc9WuVjY8hX2QBceG/0Ec8gkijRmTTVANTRDNal79ybhGsu
8FQzon7gP3BpRKesMUPvkv3uOHcBoMRTHvWmSjDwL3eom0DlByw5kVILHaoWGZUJ
wOo39SSAilSxBMTHhUKsniununN8B5PXit+y0cNRfAiP69jaT4VXuIYZsUfGti4i
41S4wuMpWUg=
=N1uo
-----END PGP SIGNATURE-----

--Sig_/35mmyz68LUF1WSnJ4UzQUfW--
