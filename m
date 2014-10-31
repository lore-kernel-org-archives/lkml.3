Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbaJaUD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:03:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40202 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbaJaUDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:03:21 -0400
Date: Fri, 31 Oct 2014 21:03:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: Nokia n900 problems in 3.18-rc1 (was Re: USB Ethernet gadget on
 Nokia n900)
Message-ID: <20141031200318.GA6949@amd>
References: <20141019090107.GA19132@amd>
 <201410262222.39892@pali>
 <20141026215548.GA9004@amd>
 <201410262323.17891@pali>
 <20141027195209.GP2560@atomide.com>
 <20141027223114.GU2560@atomide.com>
 <20141028220450.GA27667@amd>
 <20141028221124.GT2542@atomide.com>
 <20141029084637.GA30662@amd>
 <20141029140943.GX2542@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029140943.GX2542@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tried enabling audio. It works ...sometimes... after fixing
kconfig. But I'm getting WARN_ON, about 50% of time. Ideas welcome.

								Pavel

[    2.398681] rx51-audio n900-audio: GPIO lookup for consumer speaker-amplifier
[    2.398681] rx51-audio n900-audio: using device tree for GPIO lookup
[    2.398742] of_get_named_gpiod_flags: parsed 'speaker-amplifier-gpios' property of node '/n900-audio[0]' - status (0)
[    2.404663] rx51-audio n900-audio: Failed to add TPA6130A2 controls
[    2.411010] rx51-audio n900-audio: ASoC: failed to init TLV320AIC34: -19
[    2.416992] rx51-audio n900-audio: ASoC: failed to instantiate card -19
[    2.423370] gpiod_unexport: invalid GPIO
[    2.429077] ------------[ cut here ]------------
[    2.434661] WARNING: CPU: 0 PID: 6 at drivers/gpio/gpiolib.c:864 gpiod_free+0x2c/0x44()
[    2.440399] Modules linked in:
[    2.445892] CPU: 0 PID: 6 Comm: kworker/u2:0 Tainted: G        W      3.18.0-rc1-omap3-67808-gc4dc985-dirty #554
[    2.458648] Workqueue: deferwq deferred_probe_work_func
[    2.464080] Backtrace: 
[    2.469573] [<c00116ec>] (dump_backtrace) from [<c0011888>] (show_stack+0x18/0x1c)
[    2.475189]  r6:00000360 r5:00000009 r4:00000000 r3:00000000
[    2.480895] [<c0011870>] (show_stack) from [<c0569fd4>] (dump_stack+0x20/0x28)
[    2.486663] [<c0569fb4>] (dump_stack) from [<c0039434>] (warn_slowpath_common+0x6c/0x8c)
[    2.492584] [<c00393c8>] (warn_slowpath_common) from [<c0039478>] (warn_slowpath_null+0x24/0x2c)
[    2.498626]  r8:c079e394 r7:00000000 r6:00000001 r5:00000001 r4:00000000
[    2.504821] [<c0039454>] (warn_slowpath_null) from [<c02336cc>] (gpiod_free+0x2c/0x44)
[    2.511199] [<c02336a0>] (gpiod_free) from [<c02336f4>] (gpiod_put+0x10/0x14)
[    2.517608]  r4:c079e330 r3:ffffffe0
[    2.523895] [<c02336e4>] (gpiod_put) from [<c040f808>] (snd_soc_jack_free_gpios+0x4c/0x60)
[    2.530517] [<c040f7bc>] (snd_soc_jack_free_gpios) from [<c041b140>] (rx51_card_remove+0x1c/0x2c)
[    2.537384]  r7:00000001 r6:cfb76d80 r5:cf991010 r4:ffffffed
[    2.544158] [<c041b124>] (rx51_card_remove) from [<c04098dc>] (snd_soc_register_card+0xabc/0x13b4)
[    2.557525] [<c0408e20>] (snd_soc_register_card) from [<c0415f30>] (devm_snd_soc_register_card+0x34/0x70)
[    2.571624]  r10:00000000 r9:00000000 r8:0000002c r7:cf96d410 r6:c079e2d8 r5:cf3f2250
[    2.579193]  r4:c079e394
[    2.586517] [<c0415efc>] (devm_snd_soc_register_card) from [<c041b2e0>] (rx51_soc_probe+0x190/0x2e8)
[    2.601348]  r7:cf96d410 r6:c079e2d8 r5:cf3f2050 r4:00000000
[    2.608947] [<c041b150>] (rx51_soc_probe) from [<c02a3770>] (platform_drv_probe+0x50/0xac)
[    2.616516]  r7:c079e2ec r6:fffffdfb r5:cf96d410 r4:ffffffed
[    2.624176] [<c02a3720>] (platform_drv_probe) from [<c02a2010>] (driver_probe_device+0x10c/0x22c)
[    2.632049]  r7:c079e2ec r6:00000000 r5:cf96d410 r4:c08b8ab0
[    2.639984] [<c02a1f04>] (driver_probe_device) from [<c02a2210>] (__device_attach+0x48/0x4c)
[    2.647918]  r8:cf025700 r7:cf86c000 r6:c02a21c8 r5:cf96d410 r4:c079e2ec r3:c02a3cb0
[    2.656005] [<c02a21c8>] (__device_attach) from [<c02a05e8>] (bus_for_each_drv+0x4c/0x94)
[    2.664093]  r5:cf96d410 r4:00000000
[    2.672058] [<c02a059c>] (bus_for_each_drv) from [<c02a1ec0>] (device_attach+0x78/0x90)
[    2.680114]  r6:c0787fa0 r5:cf96d444 r4:cf96d410
[    2.688110] [<c02a1e48>] (device_attach) from [<c02a1590>] (bus_probe_device+0x8c/0xb0)
[    2.696166]  r6:c0787fa0 r5:cf96d410 r4:cf96d410 r3:cf8410c0
[    2.704284] [<c02a1504>] (bus_probe_device) from [<c02a1984>] (deferred_probe_work_func+0x64/0x90)
[    2.720275]  r6:c0787f44 r5:c0787f50 r4:cf96d410 r3:c07885c4
[    2.728363] [<c02a1920>] (deferred_probe_work_func) from [<c004c0f8>] (process_one_work+0x120/0x338)
[    2.744140]  r6:cf803e00 r5:c0787f68 r4:cf838280 r3:c02a1920
[    2.752105] [<c004bfd8>] (process_one_work) from [<c004c4a4>] (worker_thread+0x158/0x518)
[    2.760070]  r10:00000088 r9:cf838280 r8:cf838298 r7:00000001 r6:cf803e10 r5:cf86c000
[    2.768035]  r4:cf803e00
[    2.775695] [<c004c34c>] (worker_thread) from [<c0050d0c>] (kthread+0xc8/0xe4)
[    2.783477]  r10:00000000 r9:00000000 r8:00000000 r7:c004c34c r6:cf838280 r5:cf839640
[    2.791320]  r4:00000000
[    2.798889] [<c0050c44>] (kthread) from [<c000ebd8>] (ret_from_fork+0x14/0x3c)
[    2.806518]  r7:00000000 r6:00000000 r5:c0050c44 r4:cf839640
[    2.814178] ---[ end trace 7377fd58b39bf1ee ]---
[    2.821899] rx51-audio n900-audio: snd_soc_register_card failed (-19)
[    2.831146] of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio_keys/camera_lens_cover[0]' - status (0)
[    2.831237] of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio_keys/camera_focus[0]' - status (0)
[    2.831329] of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio_keys/camera_capture[0]' - status (0)
[    2.831390] of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio_keys/lock_button[0]' - status (0)
[    2.831451] of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio_keys/keypad_slide[0]' - status (0)
[    2.831512] of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio_keys/proximity_sensor[0]' - status (0)
[    2.832733] input: gpio_keys as /devices/gpio_keys/input/input5
[    2.857971] twl_rtc 48070000.i2c:twl@48:rtc: setting system clock to 2014-10-31 19:54:47 UTC (1414785287)
[    3.777465]  musb-hdrc.0.auto: registering UDC driver [g_ether]
[    3.777679] using random self ethernet address
[    3.785003] using random host ethernet address
[    3.791900] g_ether gadget: adding config #1 'CDC Ethernet (ECM)'/c0793078
[    3.791961] g_ether gadget: adding 'cdc_ethernet'/cf3ef300 to config 'CDC Ethernet (ECM)'/c0793078
[    3.793579] usb0: HOST MAC 26:c1:fc:d6:eb:34
[    3.800994] usb0: MAC be:19:8e:16:b0:da
[    3.807708] g_ether gadget: CDC Ethernet: dual speed IN/ep1in OUT/ep1out NOTIFY/ep2in

commit 85a6aea58dbfe1068098d4160c17d3dad530ea50
Author: Pavel <pavel@ucw.cz>
Date:   Thu Oct 30 23:35:31 2014 +0100

    Nokia N900 audio driver should be selectable even without RX51 support
    enabled (as is the case with RX51 booting using device tree).
    
    Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
index d44463a..0d7b707 100644
--- a/sound/soc/omap/Kconfig
+++ b/sound/soc/omap/Kconfig
@@ -26,7 +26,7 @@ config SND_OMAP_SOC_N810
 
 config SND_OMAP_SOC_RX51
 	tristate "SoC Audio support for Nokia RX-51"
-	depends on SND_OMAP_SOC && ARM && (MACH_NOKIA_RX51 || COMPILE_TEST) && I2C
+	depends on SND_OMAP_SOC && ARM && I2C
 	select SND_OMAP_SOC_MCBSP
 	select SND_SOC_TLV320AIC3X
 	select SND_SOC_TPA6130A2


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
