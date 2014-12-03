Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaLCPW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:22:57 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:61599 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaLCPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:22:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAL8zT=iXizKqJjWDcLT-chZ7=ioPYtQcB4GeqZpiL7kCpGOKZw@mail.gmail.com>
References: <CAL8zT=iXizKqJjWDcLT-chZ7=ioPYtQcB4GeqZpiL7kCpGOKZw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Dec 2014 15:22:33 +0000
X-Google-Sender-Auth: kpxzri-d3wnHfrLF-Z9N4oPf4dY
Message-ID: <CACxGe6sRULEmOvdxFvR=Mcbf4Cgd3YijrJg1q9Uz1vgYw5tG+w@mail.gmail.com>
Subject: Re: DT parsing : duplicate name error
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 1:27 PM, Jean-Michel Hautbois
<jean-michel.hautbois@vodalys.com> wrote:
> Hi,
>
> I am using linux-next on a i.MX6 board, and it seems that there is a
> regression probably in DT parsing.

Are you able to bisect down to the offending commit?

Thanks,
g.

>
> Here is the DT I am using :
>     vbx-leds {
>         compatible = "gpio-leds";
>         pinctrl-names = "default";
>         pinctrl-0 = <&pinctrl_gpio_leds>;
>
>         led0-red {
>             gpios = <&gpio6 11 GPIO_ACTIVE_LOW>;
>             default-state = "off";
>         };
>         led0-green {
>             gpios = <&gpio6 14 GPIO_ACTIVE_LOW>;
>             default-state = "on";
>         };
>         led1-red {
>             gpios = <&gpio6 15 GPIO_ACTIVE_LOW>;
>             default-state = "off";
>         };
>         led1-green {
>             gpios = <&gpio6 16 GPIO_ACTIVE_LOW>;
>             default-state = "on";
>         };
>     };
>
> On linux-stable v3.17 it works correctly.
> On linux-next I get :
>
> [    1.566876] ------------[ cut here ]------------
> [    1.566899] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:31
> sysfs_warn_dup+0x68/0x88()
> [    1.566906] sysfs: cannot create duplicate filename
> '/devices/soc0/vbx-leds/leds/(null)'
> [    1.566913] Modules linked in:
> [    1.566924] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 3.18.0-rc6-next-20141126+g0076d1c #1
> [    1.566929] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [    1.566935] Backtrace:
> [    1.566957] [<80013bbc>] (dump_backtrace) from [<80013f10>]
> (show_stack+0x20/0x24)
> [    1.566975]  r6:80c68954 r5:00000000 r4:00000000 r3:00000000
> [    1.566995] [<80013ef0>] (show_stack) from [<8079e498>]
> (dump_stack+0x8c/0xa4)
> [    1.567010] [<8079e40c>] (dump_stack) from [<8002ed10>]
> (warn_slowpath_common+0x8c/0xc8)
> [    1.567026]  r6:8019b544 r5:00000009 r4:be0d1bb0 r3:00000000
> [    1.567037] [<8002ec84>] (warn_slowpath_common) from [<8002ed8c>]
> (warn_slowpath_fmt+0x40/0x48)
> [    1.567055]  r8:be22f410 r7:bd931ec0 r6:bd930de0 r5:bd934100 r4:80abda98
> [    1.567068] [<8002ed50>] (warn_slowpath_fmt) from [<8019b544>]
> (sysfs_warn_dup+0x68/0x88)
> [    1.567078]  r3:be03efe4 r2:80abda98
> [    1.567085]  r4:be03e000
> [    1.567096] [<8019b4dc>] (sysfs_warn_dup) from [<8019b5f4>]
> (sysfs_create_dir_ns+0x90/0xa8)
> [    1.567109]  r6:bd930de0 r5:bd89bc08 r4:ffffffef
> [    1.567131] [<8019b564>] (sysfs_create_dir_ns) from [<803284e8>]
> (kobject_add_internal+0xb4/0x33c)
> [    1.567144]  r6:bd931ec0 r5:00000000 r4:bd89bc08
> [    1.567157] [<80328434>] (kobject_add_internal) from [<80328920>]
> (kobject_add+0x54/0x98)
> [    1.567173]  r7:00000000 r6:bd931ec0 r5:00000000 r4:bd89bc08
> [    1.567189] [<803288d0>] (kobject_add) from [<80405098>]
> (device_add+0xf0/0x564)
> [    1.567198]  r3:be22f434 r2:00000000
> [    1.567212]  r6:bd89bc00 r5:be22f410 r4:bd89bc08
> [    1.567223] [<80404fa8>] (device_add) from [<804056c8>]
> (device_create_groups_vargs+0xb4/0xd0)
> [    1.567244]  r10:00000000 r9:00000000 r8:be22f410 r7:bd8eb170
> r6:bd89bc08 r5:bd89bc00
> [    1.567250]  r4:00000000
> [    1.567262] [<80405614>] (device_create_groups_vargs) from
> [<80405784>] (device_create_with_groups+0x30/0x38)
> [    1.567283]  r9:80c08d90 r8:00000000 r7:be0d1d84 r6:814d0d98
> r5:be22f410 r4:00000000
> [    1.567298] [<80405754>] (device_create_with_groups) from
> [<8058c7d4>] (led_classdev_register+0x54/0x198)
> [    1.567304]  r4:bd8eb170
> [    1.567316] [<8058c780>] (led_classdev_register) from [<8058d74c>]
> (create_gpio_led+0xfc/0x194)
> [    1.567330]  r6:be22f410 r5:814c5fe0 r4:bd8eb170
> [    1.567340] [<8058d650>] (create_gpio_led) from [<8058d8c8>]
> (gpio_led_probe+0xe4/0x2f8)
> [    1.567360]  r8:be22f400 r7:bd8eb010 r6:00000000 r5:be22f410
> r4:be7e4e1c r3:00000000
> [    1.567377] [<8058d7e4>] (gpio_led_probe) from [<8040a248>]
> (platform_drv_probe+0x54/0xb4)
> [    1.567398]  r10:00000000 r9:80c08d90 r8:80c98f58 r7:fffffdfb
> r6:80c98f58 r5:be22f410
> [    1.567404]  r4:814cd180
> [    1.567418] [<8040a1f4>] (platform_drv_probe) from [<804082d8>]
> (driver_probe_device+0x144/0x3a0)
> [    1.567435]  r7:00000000 r6:80cbb2c8 r5:be22f410 r4:814cd180
> [    1.567446] [<80408194>] (driver_probe_device) from [<8040862c>]
> (__driver_attach+0xa4/0xa8)
> [    1.567467]  r10:00000000 r9:80c08d90 r8:80cc3280 r7:00000000
> r6:be22f444 r5:80c98f58
> [    1.567473]  r4:be22f410
> [    1.567485] [<80408588>] (__driver_attach) from [<80406250>]
> (bus_for_each_dev+0x7c/0xb0)
> [    1.567501]  r6:80408588 r5:80c98f58 r4:00000000 r3:be216f5c
> [    1.567512] [<804061d4>] (bus_for_each_dev) from [<80407c88>]
> (driver_attach+0x28/0x30)
> [    1.567525]  r6:80c76ce0 r5:bd8f5600 r4:80c98f58
> [    1.567536] [<80407c60>] (driver_attach) from [<8040787c>]
> (bus_add_driver+0x164/0x230)
> [    1.567549] [<80407718>] (bus_add_driver) from [<80408e78>]
> (driver_register+0x88/0x108)
> [    1.567566]  r7:80be948c r6:bd931b40 r5:80c44620 r4:80c98f58
> [    1.567578] [<80408df0>] (driver_register) from [<8040a168>]
> (__platform_driver_register+0x58/0x6c)
> [    1.567588]  r5:80c44620 r4:80c44620
> [    1.567605] [<8040a110>] (__platform_driver_register) from
> [<80be94a4>] (gpio_led_driver_init+0x18/0x20)
> [    1.567619] [<80be948c>] (gpio_led_driver_init) from [<80008b1c>]
> (do_one_initcall+0xb8/0x208)
> [    1.567632] [<80008a64>] (do_one_initcall) from [<80ba0e3c>]
> (kernel_init_freeable+0x118/0x1e0)
> [    1.567653]  r10:80ba0604 r9:80c08d90 r8:80cc3280 r7:000000ca
> r6:80cc3280 r5:00000006
> [    1.567659]  r4:80c32270
> [    1.567673] [<80ba0d24>] (kernel_init_freeable) from [<80799b2c>]
> (kernel_init+0x18/0xfc)
> [    1.567693]  r10:00000000 r9:00000000 r8:00000000 r7:00000000
> r6:00000000 r5:80799b14
> [    1.567699]  r4:00000000
> [    1.567713] [<80799b14>] (kernel_init) from [<8000fb88>]
> (ret_from_fork+0x14/0x2c)
> [    1.567722]  r4:00000000 r3:00000000
> [    1.567751] ---[ end trace aa4c820e66f8b9bb ]---
> [    1.567758] ------------[ cut here ]------------
> [    1.567774] WARNING: CPU: 0 PID: 1 at lib/kobject.c:240
> kobject_add_internal+0x2b0/0x33c()
> [    1.567780] kobject_add_internal failed for (null) with -EEXIST,
> don't try to register things with the same name in the same directory.
> [    1.567787] Modules linked in:
> [    1.567796] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
> 3.18.0-rc6-next-20141126+g0076d1c #1
> [    1.567801] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [    1.567807] Backtrace:
> [    1.567820] [<80013bbc>] (dump_backtrace) from [<80013f10>]
> (show_stack+0x20/0x24)
> [    1.567837]  r6:80c68954 r5:00000000 r4:00000000 r3:00000000
> [    1.567847] [<80013ef0>] (show_stack) from [<8079e498>]
> (dump_stack+0x8c/0xa4)
> [    1.567860] [<8079e40c>] (dump_stack) from [<8002ed10>]
> (warn_slowpath_common+0x8c/0xc8)
> [    1.567877]  r6:803286e4 r5:00000009 r4:be0d1c00 r3:00000000
> [    1.567887] [<8002ec84>] (warn_slowpath_common) from [<8002ed8c>]
> (warn_slowpath_fmt+0x40/0x48)
> [    1.567907]  r8:be22f410 r7:bd931ec0 r6:bd931ec0 r5:ffffffef r4:80adefb4
> [    1.567919] [<8002ed50>] (warn_slowpath_fmt) from [<803286e4>]
> (kobject_add_internal+0x2b0/0x33c)
> [    1.567928]  r3:807e849c r2:80adefb4
> [    1.567935]  r4:bd89bc08
> [    1.567947] [<80328434>] (kobject_add_internal) from [<80328920>]
> (kobject_add+0x54/0x98)
> [    1.567963]  r7:00000000 r6:bd931ec0 r5:00000000 r4:bd89bc08
> [    1.567974] [<803288d0>] (kobject_add) from [<80405098>]
> (device_add+0xf0/0x564)
> [    1.567985]  r3:be22f434 r2:00000000
> [    1.567997]  r6:bd89bc00 r5:be22f410 r4:bd89bc08
> [    1.568008] [<80404fa8>] (device_add) from [<804056c8>]
> (device_create_groups_vargs+0xb4/0xd0)
> [    1.568029]  r10:00000000 r9:00000000 r8:be22f410 r7:bd8eb170
> r6:bd89bc08 r5:bd89bc00
> [    1.568035]  r4:00000000
> [    1.568046] [<80405614>] (device_create_groups_vargs) from
> [<80405784>] (device_create_with_groups+0x30/0x38)
> [    1.568067]  r9:80c08d90 r8:00000000 r7:be0d1d84 r6:814d0d98
> r5:be22f410 r4:00000000
> [    1.568078] [<80405754>] (device_create_with_groups) from
> [<8058c7d4>] (led_classdev_register+0x54/0x198)
> [    1.568085]  r4:bd8eb170
> [    1.568096] [<8058c780>] (led_classdev_register) from [<8058d74c>]
> (create_gpio_led+0xfc/0x194)
> [    1.568109]  r6:be22f410 r5:814c5fe0 r4:bd8eb170
> [    1.568118] [<8058d650>] (create_gpio_led) from [<8058d8c8>]
> (gpio_led_probe+0xe4/0x2f8)
> [    1.568139]  r8:be22f400 r7:bd8eb010 r6:00000000 r5:be22f410
> r4:be7e4e1c r3:00000000
> [    1.568151] [<8058d7e4>] (gpio_led_probe) from [<8040a248>]
> (platform_drv_probe+0x54/0xb4)
> [    1.568172]  r10:00000000 r9:80c08d90 r8:80c98f58 r7:fffffdfb
> r6:80c98f58 r5:be22f410
> [    1.568236]  r4:814cd180
> [    1.568253] [<8040a1f4>] (platform_drv_probe) from [<804082d8>]
> (driver_probe_device+0x144/0x3a0)
> [    1.568271]  r7:00000000 r6:80cbb2c8 r5:be22f410 r4:814cd180
> [    1.568284] [<80408194>] (driver_probe_device) from [<8040862c>]
> (__driver_attach+0xa4/0xa8)
> [    1.568306]  r10:00000000 r9:80c08d90 r8:80cc3280 r7:00000000
> r6:be22f444 r5:80c98f58
> [    1.568312]  r4:be22f410
> [    1.568324] [<80408588>] (__driver_attach) from [<80406250>]
> (bus_for_each_dev+0x7c/0xb0)
> [    1.568340]  r6:80408588 r5:80c98f58 r4:00000000 r3:be216f5c
> [    1.568351] [<804061d4>] (bus_for_each_dev) from [<80407c88>]
> (driver_attach+0x28/0x30)
> [    1.568364]  r6:80c76ce0 r5:bd8f5600 r4:80c98f58
> [    1.568375] [<80407c60>] (driver_attach) from [<8040787c>]
> (bus_add_driver+0x164/0x230)
> [    1.568386] [<80407718>] (bus_add_driver) from [<80408e78>]
> (driver_register+0x88/0x108)
> [    1.568402]  r7:80be948c r6:bd931b40 r5:80c44620 r4:80c98f58
> [    1.568415] [<80408df0>] (driver_register) from [<8040a168>]
> (__platform_driver_register+0x58/0x6c)
> [    1.568425]  r5:80c44620 r4:80c44620
> [    1.568442] [<8040a110>] (__platform_driver_register) from
> [<80be94a4>] (gpio_led_driver_init+0x18/0x20)
> [    1.568454] [<80be948c>] (gpio_led_driver_init) from [<80008b1c>]
> (do_one_initcall+0xb8/0x208)
> [    1.568466] [<80008a64>] (do_one_initcall) from [<80ba0e3c>]
> (kernel_init_freeable+0x118/0x1e0)
> [    1.568487]  r10:80ba0604 r9:80c08d90 r8:80cc3280 r7:000000ca
> r6:80cc3280 r5:00000006
> [    1.568493]  r4:80c32270
> [    1.568505] [<80ba0d24>] (kernel_init_freeable) from [<80799b2c>]
> (kernel_init+0x18/0xfc)
> [    1.568526]  r10:00000000 r9:00000000 r8:00000000 r7:00000000
> r6:00000000 r5:80799b14
> [    1.568532]  r4:00000000
> [    1.568544] [<80799b14>] (kernel_init) from [<8000fb88>]
> (ret_from_fork+0x14/0x2c)
> [    1.568553]  r4:00000000 r3:00000000
> [    1.568558] ---[ end trace aa4c820e66f8b9bc ]---
>
> It seems Fabio (CC'ed here) experiences the same issue with another
> device too on i.MX53.
>
> Any idea ?
> Thanks,
> JM
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
