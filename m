Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab3KMFxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:53:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab3KMFxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:53:04 -0500
Date: Wed, 13 Nov 2013 16:52:43 +1100
From: NeilBrown <neilb@suse.de>
To: Bryan Wu <cooloney@gmail.com>
Cc: Joe Perches <joe@perches.com>, Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH - v2] LEDS: tca6507 - fix up some comments.
Message-ID: <20131113165243.7fde24e8@notabene.brown>
In-Reply-To: <CAK5ve-LWqoHPjKxMXbqzvazHyoNF+3pZ5fh022xaEVAjY_vXqQ@mail.gmail.com>
References: <20131101134120.13a44225@notabene.brown>
	<CAK5ve-LzYLr0xuvNA3MX=pECPPfAkDFqExPpmQt8GF+9jf5uHg@mail.gmail.com>
	<20131108142004.10e31655@notabene.brown>
	<1383881076.9263.64.camel@joe-AO722>
	<CAK5ve-LWqoHPjKxMXbqzvazHyoNF+3pZ5fh022xaEVAjY_vXqQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.+USoheSM6po1/_ygsG1OVe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.+USoheSM6po1/_ygsG1OVe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


In particular fix the capitalisation of GPIO and LED and
correct TCA6507_MAKE_CPIO, but also rewrite the comment about
platform-data to include reference to devicetree.

Also re-wrap comments to fit 80 columns.

Reported-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index 93a2b1759054..503df834c690 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -4,77 +4,87 @@
  * The TCA6507 is a programmable LED controller that can drive 7
  * separate lines either by holding them low, or by pulsing them
  * with modulated width.
- * The modulation can be varied in a simple pattern to produce a blink or
- * double-blink.
+ * The modulation can be varied in a simple pattern to produce a
+ * blink or double-blink.
  *
- * This driver can configure each line either as a 'GPIO' which is out-only
- * (no pull-up) or as an LED with variable brightness and hardware-assisted
- * blinking.
+ * This driver can configure each line either as a 'GPIO' which is
+ * out-only (pull-up resistor required) or as an LED with variable
+ * brightness and hardware-assisted blinking.
  *
- * Apart from OFF and ON there are three programmable brightness levels wh=
ich
- * can be programmed from 0 to 15 and indicate how many 500usec intervals =
in
- * each 8msec that the led is 'on'.  The levels are named MASTER, BANK0 and
- * BANK1.
+ * Apart from OFF and ON there are three programmable brightness
+ * levels which can be programmed from 0 to 15 and indicate how many
+ * 500usec intervals in each 8msec that the led is 'on'.  The levels
+ * are named MASTER, BANK0 and BANK1.
  *
- * There are two different blink rates that can be programmed, each with
- * separate time for rise, on, fall, off and second-off.  Thus if 3 or more
- * different non-trivial rates are required, software must be used for the=
 extra
- * rates. The two different blink rates must align with the two levels BAN=
K0 and
- * BANK1.
- * This driver does not support double-blink so 'second-off' always matches
- * 'off'.
+ * There are two different blink rates that can be programmed, each
+ * with separate time for rise, on, fall, off and second-off.  Thus if
+ * 3 or more different non-trivial rates are required, software must
+ * be used for the extra rates. The two different blink rates must
+ * align with the two levels BANK0 and BANK1.  This driver does not
+ * support double-blink so 'second-off' always matches 'off'.
  *
- * Only 16 different times can be programmed in a roughly logarithmic scal=
e from
- * 64ms to 16320ms.  To be precise the possible times are:
+ * Only 16 different times can be programmed in a roughly logarithmic
+ * scale from 64ms to 16320ms.  To be precise the possible times are:
  *    0, 64, 128, 192, 256, 384, 512, 768,
  *    1024, 1536, 2048, 3072, 4096, 5760, 8128, 16320
  *
- * Times that cannot be closely matched with these must be
- * handled in software.  This driver allows 12.5% error in matching.
+ * Times that cannot be closely matched with these must be handled in
+ * software.  This driver allows 12.5% error in matching.
  *
- * This driver does not allow rise/fall rates to be set explicitly.  When =
trying
- * to match a given 'on' or 'off' period, an appropriate pair of 'change' =
and
- * 'hold' times are chosen to get a close match.  If the target delay is e=
ven,
- * the 'change' number will be the smaller; if odd, the 'hold' number will=
 be
- * the smaller.
-
- * Choosing pairs of delays with 12.5% errors allows us to match delays in=
 the
- * ranges: 56-72, 112-144, 168-216, 224-27504, 28560-36720.
- * 26% of the achievable sums can be matched by multiple pairings. For exa=
mple
- * 1536 =3D=3D 1536+0, 1024+512, or 768+768.  This driver will always choo=
se the
- * pairing with the least maximum - 768+768 in this case.  Other pairings =
are
- * not available.
+ * This driver does not allow rise/fall rates to be set explicitly.
+ * When trying to match a given 'on' or 'off' period, an appropriate
+ * pair of 'change' and 'hold' times are chosen to get a close match.
+ * If the target delay is even, the 'change' number will be the
+ * smaller; if odd, the 'hold' number will be the smaller.
+
+ * Choosing pairs of delays with 12.5% errors allows us to match
+ * delays in the ranges: 56-72, 112-144, 168-216, 224-27504,
+ * 28560-36720.
+ * 26% of the achievable sums can be matched by multiple pairings.
+ * For example 1536 =3D=3D 1536+0, 1024+512, or 768+768.
+ * This driver will always choose the pairing with the least
+ * maximum - 768+768 in this case.  Other pairings are not available.
  *
- * Access to the 3 levels and 2 blinks are on a first-come, first-served b=
asis.
- * Access can be shared by multiple leds if they have the same level and
- * either same blink rates, or some don't blink.
- * When a led changes, it relinquishes access and tries again, so it might
- * lose access to hardware blink.
- * If a blink engine cannot be allocated, software blink is used.
- * If the desired brightness cannot be allocated, the closest available no=
n-zero
- * brightness is used.  As 'full' is always available, the worst case woul=
d be
- * to have two different blink rates at '1', with Max at '2', then other l=
eds
- * will have to choose between '2' and '16'.  Hopefully this is not likely.
+ * Access to the 3 levels and 2 blinks are on a first-come,
+ * first-served basis.  Access can be shared by multiple leds if they
+ * have the same level and either same blink rates, or some don't
+ * blink.  When a led changes, it relinquishes access and tries again,
+ * so it might lose access to hardware blink.
  *
- * Each bank (BANK0 and BANK1) has two usage counts - LEDs using the brigh=
tness
- * and LEDs using the blink.  It can only be reprogrammed when the appropr=
iate
- * counter is zero.  The MASTER level has a single usage count.
+ * If a blink engine cannot be allocated, software blink is used.  If
+ * the desired brightness cannot be allocated, the closest available
+ * non-zero brightness is used.  As 'full' is always available, the
+ * worst case would be to have two different blink rates at '1', with
+ * Max at '2', then other leds will have to choose between '2' and
+ * '16'.  Hopefully this is not likely.
  *
- * Each Led has programmable 'on' and 'off' time as milliseconds.  With ea=
ch
- * there is a flag saying if it was explicitly requested or defaulted.
- * Similarly the banks know if each time was explicit or a default.  Defau=
lts
- * are permitted to be changed freely - they are not recognised when match=
ing.
+ * Each bank (BANK0 and BANK1) has two usage counts - LEDs using the
+ * brightness and LEDs using the blink.  It can only be reprogrammed
+ * when the appropriate counter is zero.  The MASTER level has a
+ * single usage count.
  *
+ * Each LED has programmable 'on' and 'off' time as milliseconds.
+ * With each there is a flag saying if it was explicitly requested or
+ * defaulted.  Similarly the banks know if each time was explicit or a
+ * default.  Defaults are permitted to be changed freely - they are
+ * not recognised when matching.
  *
- * An led-tca6507 device must be provided with platform data.  This data
- * lists for each output: the name, default trigger, and whether the signal
- * is being used as a GPiO rather than an led.  'struct led_plaform_data'
- * is used for this.  If 'name' is NULL, the output isn't used.  If 'flags'
- * is TCA6507_MAKE_CPIO, the output is a GPO.
- * The "struct led_platform_data" can be embedded in a
- * "struct tca6507_platform_data" which adds a 'gpio_base' for the GPiOs,
- * and a 'setup' callback which is called once the GPiOs are available.
  *
+ * An led-tca6507 device must be provided with platform data or
+ * configured via devicetree.
+ *
+ * The platform-data lists for each output: the name, default trigger,
+ * and whether the signal is being used as a GPIO rather than an LED.
+ * 'struct led_plaform_data' is used for this.  If 'name' is NULL, the
+ * output isn't used.  If 'flags' is TCA6507_MAKE_GPIO, the output is
+ * a GPO.  The "struct led_platform_data" can be embedded in a "struct
+ * tca6507_platform_data" which adds a 'gpio_base' for the GPIOs, and
+ * a 'setup' callback which is called once the GPIOs are available.
+ *
+ * When configured via devicetree there is one child for each output.
+ * The "reg" determines the output number and "compatible" determines
+ * whether it is an LED or a GPIO.  "linux,default-trigger" can set a
+ * default trigger.
  */
=20
 #include <linux/module.h>
@@ -192,17 +202,18 @@ MODULE_DEVICE_TABLE(i2c, tca6507_id);
 static int choose_times(int msec, int *c1p, int *c2p)
 {
 	/*
-	 * Choose two timecodes which add to 'msec' as near as possible.
-	 * The first returned is the 'on' or 'off' time.  The second is to be
-	 * used as a 'fade-on' or 'fade-off' time.  If 'msec' is even,
-	 * the first will not be smaller than the second.  If 'msec' is odd,
-	 * the first will not be larger than the second.
-	 * If we cannot get a sum within 1/8 of 'msec' fail with -EINVAL,
-	 * otherwise return the sum that was achieved, plus 1 if the first is
-	 * smaller.
-	 * If two possibilities are equally good (e.g. 512+0, 256+256), choose
-	 * the first pair so there is more change-time visible (i.e. it is
-	 * softer).
+	 * Choose two timecodes which add to 'msec' as near as
+	 * possible.  The first returned is the 'on' or 'off' time.
+	 * The second is to be used as a 'fade-on' or 'fade-off' time.
+	 * If 'msec' is even, the first will not be smaller than the
+	 * second.  If 'msec' is odd, the first will not be larger
+	 * than the second.
+	 * If we cannot get a sum within 1/8 of 'msec' fail with
+	 * -EINVAL, otherwise return the sum that was achieved, plus 1
+	 * if the first is smaller.
+	 * If two possibilities are equally good (e.g. 512+0,
+	 * 256+256), choose the first pair so there is more
+	 * change-time visible (i.e. it is softer).
 	 */
 	int c1, c2;
 	int tmax =3D msec * 9 / 8;
@@ -255,8 +266,8 @@ static int choose_times(int msec, int *c1p, int *c2p)
 }
=20
 /*
- * Update the register file with the appropriate 3-bit state for
- * the given led.
+ * Update the register file with the appropriate 3-bit state for the
+ * given led.
  */
 static void set_select(struct tca6507_chip *tca, int led, int val)
 {
@@ -274,9 +285,9 @@ static void set_select(struct tca6507_chip *tca, int le=
d, int val)
 	}
 }
=20
-/* Update the register file with the appropriate 4-bit code for
- * one bank or other.  This can be used for timers, for levels, or
- * for initialisation.
+/* Update the register file with the appropriate 4-bit code for one
+ * bank or other.  This can be used for timers, for levels, or for
+ * initialization.
  */
 static void set_code(struct tca6507_chip *tca, int reg, int bank, int new)
 {
@@ -309,7 +320,7 @@ static void set_level(struct tca6507_chip *tca, int ban=
k, int level)
 	tca->bank[bank].level =3D level;
 }
=20
-/* Record all relevant time code for a given bank */
+/* Record all relevant time codes for a given bank */
 static void set_times(struct tca6507_chip *tca, int bank)
 {
 	int c1, c2;
@@ -317,7 +328,8 @@ static void set_times(struct tca6507_chip *tca, int ban=
k)
=20
 	result =3D choose_times(tca->bank[bank].ontime, &c1, &c2);
 	dev_dbg(&tca->client->dev,
-		"Chose on  times %d(%d) %d(%d) for %dms\n", c1, time_codes[c1],
+		"Chose on  times %d(%d) %d(%d) for %dms\n",
+		c1, time_codes[c1],
 		c2, time_codes[c2], tca->bank[bank].ontime);
 	set_code(tca, TCA6507_FADE_ON, bank, c2);
 	set_code(tca, TCA6507_FULL_ON, bank, c1);
@@ -325,7 +337,8 @@ static void set_times(struct tca6507_chip *tca, int ban=
k)
=20
 	result =3D choose_times(tca->bank[bank].offtime, &c1, &c2);
 	dev_dbg(&tca->client->dev,
-		"Chose off times %d(%d) %d(%d) for %dms\n", c1, time_codes[c1],
+		"Chose off times %d(%d) %d(%d) for %dms\n",
+		c1, time_codes[c1],
 		c2, time_codes[c2], tca->bank[bank].offtime);
 	set_code(tca, TCA6507_FADE_OFF, bank, c2);
 	set_code(tca, TCA6507_FIRST_OFF, bank, c1);
@@ -373,7 +386,8 @@ static void led_release(struct tca6507_led *led)
=20
 static int led_prepare(struct tca6507_led *led)
 {
-	/* Assign this led to a bank, configuring that bank if necessary. */
+	/* Assign this led to a bank, configuring that bank if
+	 * necessary. */
 	int level =3D TO_LEVEL(led->led_cdev.brightness);
 	struct tca6507_chip *tca =3D led->chip;
 	int c1, c2;
@@ -389,10 +403,10 @@ static int led_prepare(struct tca6507_led *led)
=20
 	if (led->ontime =3D=3D 0 || led->offtime =3D=3D 0) {
 		/*
-		 * Just set the brightness, choosing first usable bank.
-		 * If none perfect, choose best.
-		 * Count backwards so we check MASTER bank first
-		 * to avoid wasting a timer.
+		 * Just set the brightness, choosing first usable
+		 * bank.  If none perfect, choose best.  Count
+		 * backwards so we check MASTER bank first to avoid
+		 * wasting a timer.
 		 */
 		int best =3D -1;/* full-on */
 		int diff =3D 15-level;
@@ -433,9 +447,9 @@ static int led_prepare(struct tca6507_led *led)
 	}
=20
 	/*
-	 * We have on/off time so we need to try to allocate a timing bank.
-	 * First check if times are compatible with hardware and give up if
-	 * not.
+	 * We have on/off time so we need to try to allocate a timing
+	 * bank.  First check if times are compatible with hardware
+	 * and give up if not.
 	 */
 	if (choose_times(led->ontime, &c1, &c2) < 0)
 		return -EINVAL;
@@ -523,8 +537,8 @@ static int led_assign(struct tca6507_led *led)
 	err =3D led_prepare(led);
 	if (err) {
 		/*
-		 * Can only fail on timer setup.  In that case we need to
-		 * re-establish as steady level.
+		 * Can only fail on timer setup.  In that case we need
+		 * to re-establish as steady level.
 		 */
 		led->ontime =3D 0;
 		led->offtime =3D 0;
@@ -594,8 +608,8 @@ static void tca6507_gpio_set_value(struct gpio_chip *gc,
=20
 	spin_lock_irqsave(&tca->lock, flags);
 	/*
-	 * 'OFF' is floating high, and 'ON' is pulled down, so it has the
-	 * inverse sense of 'val'.
+	 * 'OFF' is floating high, and 'ON' is pulled down, so it has
+	 * the inverse sense of 'val'.
 	 */
 	set_select(tca, tca->gpio_map[offset],
 		   val ? TCA6507_LS_LED_OFF : TCA6507_LS_LED_ON);

--Sig_/.+USoheSM6po1/_ygsG1OVe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoMTqznsnt1WYoG5AQL5rRAAugXx+Q1AVPXTSickDIGGnzXtqM6uq2RT
7ISoOpXPUT8NqBBjNmM+515lv1W4RnsbNdfvqSNSZ0chwnq4jA5UEqIacnf777Us
W559HAqVlhzKzGLuYuNq4lj33o1Qm5PXJNMdGp/nun0zUhtfNgW9+CBUqbXGhNyT
c+qdQNKzrMk0L3pPzmVlKvf8drzzHUajY3y2E7dsy+NlbStxtUjAgmo35PsR8Jup
5dKXUROMLi6RtUqraCh33BKQalD+MrQDASpRzUz5ZO8MYZasYOc4Dibqc0aaPhuG
idt3RcLqilcJ14+nYdIOjfXpJmX1k3NiZlFhND/eoDKZuAVcJBPrzf5feAYW6ulD
mw3sZcJ/7Ub9e4/+zY4etziRRMo+nGG/NYHEVPKB2+esayvtryf8YKRN7W5gat8K
L+jzth2yF7IkOoY50pmA5GBxc49IiNZafKIZ1zX9Qc/eROH6K5ctgqpf3SinBY/o
711d0MJUSnQImjqXq4oxQlBo4rdINf4bLa5A2ERHeLHQtEr8wuKmFpNKbGFM+pS7
q95nnB/n/BENlomB5u/ShdAUEgREs73Zp3o8Hk+oCDxiSO4lNPvTb2lSxyMlJlSF
cx2xnL6vpcjW6haqa/3Ifdi+vCMwFxHHl7RwlGY5QiK4/HXNtlszp1YrOYNwU3ZH
+CORM/dc3Uw=
=KPk5
-----END PGP SIGNATURE-----

--Sig_/.+USoheSM6po1/_ygsG1OVe--
