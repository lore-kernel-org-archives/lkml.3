Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbaBFTZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:25:50 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:47311 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaBFTZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:25:48 -0500
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH] usb: musb: Fix obex in g_nokia.ko causing kernel panic
Date: Thu,  6 Feb 2014 21:25:37 +0200
Message-Id: <1391714737-6835-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20140205230634.GA25598@kroah.com>
References: <20140205230634.GA25598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

[   18.606414] [<c037eac0>] (__schedule+0x5c/0x50c) from [<c037d3bc>] (schedule_timeout+0x1f4/0x25c)
[   18.623809] [<c037d3bc>] (schedule_timeout+0x1f4/0x25c) from [<c037f12c>] (wait_for_common+0xc8/0x1ac)
[   18.649291] [<c037f12c>] (wait_for_common+0xc8/0x1ac) from [<c028c1c0>] (omap_i2c_xfer+0x338/0x488)
[   18.674499] [<c028c1c0>] (omap_i2c_xfer+0x338/0x488) from [<c0288144>] (__i2c_transfer+0x40/0x74)
[   18.692047] [<c0288144>] (__i2c_transfer+0x40/0x74) from [<c0288a2c>] (i2c_transfer+0x6c/0x90)
[   18.709320] [<c0288a2c>] (i2c_transfer+0x6c/0x90) from [<c02351c8>] (regmap_i2c_read+0x48/0x68)
[   18.726715] [<c02351c8>] (regmap_i2c_read+0x48/0x68) from [<c023161c>] (_regmap_raw_read+0x128/0x220)
[   18.752685] [<c023161c>] (_regmap_raw_read+0x128/0x220) from [<c02317b4>] (regmap_raw_read+0xa0/0x130)
[   18.779052] [<c02317b4>] (regmap_raw_read+0xa0/0x130) from [<c023193c>] (regmap_bulk_read+0xf8/0x16c)
[   18.805694] [<c023193c>] (regmap_bulk_read+0xf8/0x16c) from [<c0238ea8>] (twl_i2c_read+0xa4/0xe0)
[   18.823730] [<c0238ea8>] (twl_i2c_read+0xa4/0xe0) from [<c0274d34>] (__twl4030_phy_power.isra.12+0x1c/0x58)
[   18.850921] [<c0274d34>] (__twl4030_phy_power.isra.12+0x1c/0x58) from [<c0274df0>]
(twl4030_phy_power.part.14+0x80/0xc8)
[   18.879699] [<c0274df0>] (twl4030_phy_power.part.14+0x80/0xc8) from [<c0274f9c>]
(twl4030_set_suspend+0x54/0x1e8)
[   18.908325] [<c0274f9c>] (twl4030_set_suspend+0x54/0x1e8) from [<c027c8c4>]
(omap2430_runtime_resume+0x5c/0x64)
[   18.937042] [<c027c8c4>] (omap2430_runtime_resume+0x5c/0x64) from [<c0225dd0>]
(pm_generic_runtime_resume+0x2c/0x38)
[   18.966461] [<c0225dd0>] (pm_generic_runtime_resume+0x2c/0x38) from [<c0229fe0>] (__rpm_callback+0x54/0x80)
[   18.995117] [<c0229fe0>] (__rpm_callback+0x54/0x80) from [<c022a04c>] (rpm_callback+0x40/0x74)
[   19.013610] [<c022a04c>] (rpm_callback+0x40/0x74) from [<c022b3c8>] (rpm_resume+0x448/0x63c)
[   19.031921] [<c022b3c8>] (rpm_resume+0x448/0x63c) from [<c022b2e4>] (rpm_resume+0x364/0x63c)
[   19.050140] [<c022b2e4>] (rpm_resume+0x364/0x63c) from [<c022b874>] (__pm_runtime_resume+0x48/0x74)
[   19.077728] [<c022b874>] (__pm_runtime_resume+0x48/0x74) from [<c027b4fc>] (musb_gadget_pullup+0x1c/0xb4)
[   19.105895] [<c027b4fc>] (musb_gadget_pullup+0x1c/0xb4) from [<bf025c14>] (usb_function_deactivate+0x54/0xa4
[libcomposite])
[   19.135955] [<bf025c14>] (usb_function_deactivate+0x54/0xa4 [libcomposite]) from [<bf05b3b8>]
(obex_bind+0x124/0x1d8 [usb_f_obex])
[   19.166870] [<bf05b3b8>] (obex_bind+0x124/0x1d8 [usb_f_obex]) from [<bf025794>] (usb_add_function+0x58/0xf4
[libcomposite])
[   19.197143] [<bf025794>] (usb_add_function+0x58/0xf4 [libcomposite]) from [<bf037420>]
(nokia_bind_config+0x204/0x250 [g_nokia])
[   19.227905] [<bf037420>] (nokia_bind_config+0x204/0x250 [g_nokia]) from [<bf0263fc>] (usb_add_config+0x28/0xc0
[libcomposite])
[   19.258483] [<bf0263fc>] (usb_add_config+0x28/0xc0 [libcomposite]) from [<bf03709c>] (nokia_bind+0x9c/0x21c
[g_nokia])
[   19.288421] [<bf03709c>] (nokia_bind+0x9c/0x21c [g_nokia]) from [<bf0275bc>] (composite_bind+0x74/0x180
[libcomposite])
[   19.318420] [<bf0275bc>] (composite_bind+0x74/0x180 [libcomposite]) from [<c027d658>]
(udc_bind_to_driver+0x2c/0xc4)
[   19.348114] [<c027d658>] (udc_bind_to_driver+0x2c/0xc4) from [<c027d764>] (usb_gadget_probe_driver+0x74/0x94)
[   19.377166] [<c027d764>] (usb_gadget_probe_driver+0x74/0x94) from [<c00086f8>] (do_one_initcall+0x94/0x138)
[   19.406005] [<c00086f8>] (do_one_initcall+0x94/0x138) from [<c007a460>] (load_module+0x113c/0x13c4)
[   19.434051] [<c007a460>] (load_module+0x113c/0x13c4) from [<c007a7b4>] (SyS_init_module+0xcc/0xec)
[   19.462127] [<c007a7b4>] (SyS_init_module+0xcc/0xec) from [<c000dd40>] (ret_fast_syscall+0x0/0x30)
[   19.490753] Code: 0a00002e e1a00004 eb001438 e598300c (e5d3202c)
[   19.506805] ---[ end trace 060b62ec0d68a78b ]---
[   19.523132] Kernel panic - not syncing: Fatal exception in interrupt

dump is from 3.12-rc5 kernel

Reported-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/usb/musb/omap2430.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 2a408cd..8aa59a2 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -659,7 +659,6 @@ static int omap2430_runtime_suspend(struct device *dev)
 				OTG_INTERFSEL);
 
 		omap2430_low_level_exit(musb);
-		phy_power_off(musb->phy);
 	}
 
 	return 0;
@@ -674,7 +673,6 @@ static int omap2430_runtime_resume(struct device *dev)
 		omap2430_low_level_init(musb);
 		musb_writel(musb->mregs, OTG_INTERFSEL,
 				musb->context.otg_interfsel);
-		phy_power_on(musb->phy);
 	}
 
 	return 0;
-- 
1.7.9.5

