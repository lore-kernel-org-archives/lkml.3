Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbaDWQm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:42:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38841 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaDWQm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:42:56 -0400
Date: Wed, 23 Apr 2014 11:40:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cwchoi00@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: extcon-next regression ?
Message-ID: <20140423164033.GR9593@saruman.home>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cYG5ZC/RuVsIq1ir"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cYG5ZC/RuVsIq1ir
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chanwoo,

I've been testing extcon-next to make sure USB3 on OMAP5 will work out
of the box but I see a regression when I merge your tree on top of
v3.15-rc2 + Tony's DT fixes.

Here's what I see (trimmed):

[    1.805870] palmas 0-0048: Muxing GPIO 2, PWM 0, LED 0
[    1.812516] ------------[ cut here ]------------
[    1.817387] WARNING: CPU: 0 PID: 6 at include/linux/kref.h:47 kobject_ge=
t+0x64/0x78()
[    1.817691]  mmcblk0boot1: unknown partition table
[    1.830601] Modules linked in:
[    1.833827] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3.1=
5.0-rc2-00041-g3019b77 #308
[    1.843333] Workqueue: deferwq deferred_probe_work_func
[    1.848728]  mmcblk0boot0: unknown partition table
[    1.853928] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_stac=
k+0x10/0x14)
[    1.862086] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x84=
/0x9c)
[    1.869667] [<c05426b4>] (dump_stack) from [<c0040928>] (warn_slowpath_c=
ommon+0x6c/0x90)
[    1.878181] [<c0040928>] (warn_slowpath_common) from [<c00409e8>] (warn_=
slowpath_null+0x1c/0x24)
[    1.887421] [<c00409e8>] (warn_slowpath_null) from [<c02d50c4>] (kobject=
_get+0x64/0x78)
[    1.895837] [<c02d50c4>] (kobject_get) from [<c0350188>] (device_add+0x1=
8/0x520)
[    1.903629] [<c0350188>] (device_add) from [<c0462a5c>] (extcon_dev_regi=
ster+0x48/0x104)
[    1.912145] [<c0462a5c>] (extcon_dev_register) from [<c0462b44>] (devm_e=
xtcon_dev_register+0x2c/0x68)
[    1.921847] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] (p=
almas_usb_probe+0x110/0x304)
[    1.931453] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platform_=
drv_probe+0x18/0x48)
[    1.940333] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
[    1.949664] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    1.958634] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    1.967003] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    1.975387] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_ad=
d+0x420/0x520)
[    1.983678] [<c0350590>] (device_add) from [<c045a310>] (of_platform_dev=
ice_create_pdata+0x6c/0x8c)
[    1.993155] [<c045a310>] (of_platform_device_create_pdata) from [<c045a4=
18>] (of_platform_bus_create+0xdc/0x168)
[    2.003818] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (of_=
platform_populate+0x5c/0xa0)
[    2.013399] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (palma=
s_i2c_probe+0x30c/0x584)
[    2.022606] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_pr=
obe_device+0x110/0x22c)
[    2.031722] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    2.040715] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    2.049098] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    2.057482] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_ad=
d+0x420/0x520)
[    2.065774] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_device+=
0x12c/0x18c)
[    2.073885] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_registe=
r_adapter+0x278/0x498)
[    2.082903] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (omap_=
i2c_probe+0x4a4/0x6d0)
[    2.091925] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_dr=
v_probe+0x18/0x48)
[    2.100582] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
[    2.109883] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    2.118823] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    2.127194] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    2.135584] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferred_=
probe_work_func+0x64/0x94)
[    2.144975] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] (p=
rocess_one_work+0x1ac/0x4cc)
[    2.154545] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_th=
read+0x114/0x3b4)
[    2.163119] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0xd4=
/0xf0)
[    2.170695] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x14=
/0x2c)
[    2.178259] ---[ end trace 3006de6450234d28 ]---
[    2.183081] kobject 'palmas_usb' (eca58c38): tried to add an uninitializ=
ed object, something is seriously wrong.
[    2.193731] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3.1=
5.0-rc2-00041-g3019b77 #308
[    2.203201] Workqueue: deferwq deferred_probe_work_func
[    2.208687] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_stac=
k+0x10/0x14)
[    2.216789] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x84=
/0x9c)
[    2.224357] [<c05426b4>] (dump_stack) from [<c02d5c28>] (kobject_add+0x8=
8/0x98)
[    2.232014] [<c02d5c28>] (kobject_add) from [<c0350250>] (device_add+0xe=
0/0x520)
[    2.239758] [<c0350250>] (device_add) from [<c0462a5c>] (extcon_dev_regi=
ster+0x48/0x104)
[    2.248235] [<c0462a5c>] (extcon_dev_register) from [<c0462b44>] (devm_e=
xtcon_dev_register+0x2c/0x68)
[    2.257901] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] (p=
almas_usb_probe+0x110/0x304)
[    2.267467] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platform_=
drv_probe+0x18/0x48)
[    2.276298] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
[    2.285591] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    2.294520] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    2.302905] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    2.311286] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_ad=
d+0x420/0x520)
[    2.319583] [<c0350590>] (device_add) from [<c045a310>] (of_platform_dev=
ice_create_pdata+0x6c/0x8c)
[    2.329063] [<c045a310>] (of_platform_device_create_pdata) from [<c045a4=
18>] (of_platform_bus_create+0xdc/0x168)
[    2.339725] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (of_=
platform_populate+0x5c/0xa0)
[    2.349296] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (palma=
s_i2c_probe+0x30c/0x584)
[    2.358496] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_pr=
obe_device+0x110/0x22c)
[    2.367609] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    2.376523] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    2.384914] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    2.393301] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_ad=
d+0x420/0x520)
[    2.401601] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_device+=
0x12c/0x18c)
[    2.409707] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_registe=
r_adapter+0x278/0x498)
[    2.418727] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (omap_=
i2c_probe+0x4a4/0x6d0)
[    2.427741] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_dr=
v_probe+0x18/0x48)
[    2.436382] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
[    2.445680] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    2.454613] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    2.463001] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    2.471385] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferred_=
probe_work_func+0x64/0x94)
[    2.480772] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] (p=
rocess_one_work+0x1ac/0x4cc)
[    2.490339] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_th=
read+0x114/0x3b4)
[    2.498906] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0xd4=
/0xf0)
[    2.506460] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x14=
/0x2c)
[    2.514023] ------------[ cut here ]------------
[    2.518870] WARNING: CPU: 0 PID: 6 at lib/kobject.c:670 kobject_put+0x80=
/0x90()
[    2.526514] kobject: 'palmas_usb' (eca58c38): is not initialized, yet ko=
bject_put() is being called.
[    2.536076] Modules linked in:
[    2.539287] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3.1=
5.0-rc2-00041-g3019b77 #308
[    2.548753] Workqueue: deferwq deferred_probe_work_func
[    2.554223] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_stac=
k+0x10/0x14)
[    2.562341] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x84=
/0x9c)
[    2.569911] [<c05426b4>] (dump_stack) from [<c0040928>] (warn_slowpath_c=
ommon+0x6c/0x90)
[    2.578391] [<c0040928>] (warn_slowpath_common) from [<c004097c>] (warn_=
slowpath_fmt+0x30/0x40)
[    2.587502] [<c004097c>] (warn_slowpath_fmt) from [<c02d5158>] (kobject_=
put+0x80/0x90)
[    2.595780] [<c02d5158>] (kobject_put) from [<c03502fc>] (device_add+0x1=
8c/0x520)
[    2.603623] [<c03502fc>] (device_add) from [<c0462a5c>] (extcon_dev_regi=
ster+0x48/0x104)
[    2.612103] [<c0462a5c>] (extcon_dev_register) from [<c0462b44>] (devm_e=
xtcon_dev_register+0x2c/0x68)
[    2.621762] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] (p=
almas_usb_probe+0x110/0x304)
[    2.631321] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platform_=
drv_probe+0x18/0x48)
[    2.640161] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
[    2.649447] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    2.658386] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    2.666757] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    2.675144] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_ad=
d+0x420/0x520)
[    2.683441] [<c0350590>] (device_add) from [<c045a310>] (of_platform_dev=
ice_create_pdata+0x6c/0x8c)
[    2.692921] [<c045a310>] (of_platform_device_create_pdata) from [<c045a4=
18>] (of_platform_bus_create+0xdc/0x168)
[    2.703575] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (of_=
platform_populate+0x5c/0xa0)
[    2.713139] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (palma=
s_i2c_probe+0x30c/0x584)
[    2.722341] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_pr=
obe_device+0x110/0x22c)
[    2.731457] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    2.740380] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    2.748764] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    2.757135] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_ad=
d+0x420/0x520)
[    2.765429] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_device+=
0x12c/0x18c)
[    2.773549] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_registe=
r_adapter+0x278/0x498)
[    2.782576] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (omap_=
i2c_probe+0x4a4/0x6d0)
[    2.791597] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_dr=
v_probe+0x18/0x48)
[    2.800261] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
[    2.809560] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    2.818489] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    2.826865] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    2.835253] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferred_=
probe_work_func+0x64/0x94)
[    2.844637] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] (p=
rocess_one_work+0x1ac/0x4cc)
[    2.854205] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_th=
read+0x114/0x3b4)
[    2.862778] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0xd4=
/0xf0)
[    2.870349] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x14=
/0x2c)
[    2.877911] ---[ end trace 3006de6450234d29 ]---
[    2.882734] ------------[ cut here ]------------
[    2.887573] WARNING: CPU: 0 PID: 6 at lib/kobject.c:670 kobject_put+0x80=
/0x90()
[    2.895209] kobject: 'palmas_usb' (eca58c38): is not initialized, yet ko=
bject_put() is being called.
[    2.904765] Modules linked in:
[    2.907971] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3.1=
5.0-rc2-00041-g3019b77 #308
[    2.917447] Workqueue: deferwq deferred_probe_work_func
[    2.922924] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_stac=
k+0x10/0x14)
[    2.931033] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x84=
/0x9c)
[    2.938606] [<c05426b4>] (dump_stack) from [<c0040928>] (warn_slowpath_c=
ommon+0x6c/0x90)
[    2.947069] [<c0040928>] (warn_slowpath_common) from [<c004097c>] (warn_=
slowpath_fmt+0x30/0x40)
[    2.956187] [<c004097c>] (warn_slowpath_fmt) from [<c02d5158>] (kobject_=
put+0x80/0x90)
[    2.964483] [<c02d5158>] (kobject_put) from [<c0462abc>] (extcon_dev_reg=
ister+0xa8/0x104)
[    2.973053] [<c0462abc>] (extcon_dev_register) from [<c0462b44>] (devm_e=
xtcon_dev_register+0x2c/0x68)
[    2.982718] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] (p=
almas_usb_probe+0x110/0x304)
[    2.992285] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platform_=
drv_probe+0x18/0x48)
[    3.001124] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
[    3.010423] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    3.019358] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    3.027746] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    3.036121] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_ad=
d+0x420/0x520)
[    3.044418] [<c0350590>] (device_add) from [<c045a310>] (of_platform_dev=
ice_create_pdata+0x6c/0x8c)
[    3.053893] [<c045a310>] (of_platform_device_create_pdata) from [<c045a4=
18>] (of_platform_bus_create+0xdc/0x168)
[    3.064550] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (of_=
platform_populate+0x5c/0xa0)
[    3.074124] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (palma=
s_i2c_probe+0x30c/0x584)
[    3.083338] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_pr=
obe_device+0x110/0x22c)
[    3.092447] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    3.101381] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    3.109767] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    3.118147] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_ad=
d+0x420/0x520)
[    3.126432] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_device+=
0x12c/0x18c)
[    3.134547] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_registe=
r_adapter+0x278/0x498)
[    3.143569] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (omap_=
i2c_probe+0x4a4/0x6d0)
[    3.152593] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_dr=
v_probe+0x18/0x48)
[    3.161249] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
[    3.170537] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_fo=
r_each_drv+0x58/0x8c)
[    3.179472] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_at=
tach+0x74/0x8c)
[    3.187854] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_de=
vice+0x88/0xb0)
[    3.196222] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferred_=
probe_work_func+0x64/0x94)
[    3.205611] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] (p=
rocess_one_work+0x1ac/0x4cc)
[    3.215174] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_th=
read+0x114/0x3b4)
[    3.223739] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0xd4=
/0xf0)
[    3.231313] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x14=
/0x2c)
[    3.238883] ---[ end trace 3006de6450234d2a ]---
[    3.243711] palmas-usb palmas_usb.7: failed to register extcon device
[    3.250493] palmas-usb: probe of palmas_usb.7 failed with error -22

Any ideas ??

--=20
balbi

--cYG5ZC/RuVsIq1ir
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV+0BAAoJEIaOsuA1yqREqX4P/RzhUlxHWn0SneTu1He+SAOH
iZQm/50Jn2NYJJSpCJ5B6lzPTS/9O/jU3fSlet0574Q5MDDPhISDalNGlcriO6Gf
I/n+NpVp5ShVIZ57EHt0Ec99SVzKvCDNBcoVSEVD3v40E23PNGscP7zxKm1W+CSJ
QSjygOHSTWgiiI9jwVHqfcqnpCKpazUU/gwLDZPhokIaomqIYqUM2vhpHACspfyg
OQgjKq7y3yDga1b1sPdla8DQ0UTPLk8LOW9RmXzpej/AjspmRVeeIJafxAx+ZdLZ
QCaZmQMA5+tgv3WoZxoH1hyU7wfIbK+vB++QbOCQNxwKVuCL0ZxMx9XybGHkLeSm
hgQPWH08Y9jjgjyK5lJobUHEhA0jQRkgvI65BRsQKw1tLbvuz8+4J+gKlENt2WKc
zCwpY+2+TExmY3zIs4kd4WQ1fPl5E4jg4JqXnndrNDj8H832feZbgn86h5TpdX6t
9x9EkH22IC/bSGL/ahGZqlA+OTxMDS57UHXfaXqCyyjovSTlLGNjzsnjM4FRZRiL
UTxRfw+AwjuTWkqBRYzaHR2e8xYBQpUId6oSEegTyYSJ9qXAD62tm8EwzHIn4bw/
+e3OhmUCe2QOVBrdvgZnLW002agBSSoSiKJiKN1XKkl0Wd6GD/j8SCt7nUD9Stlv
rSZHX1f5tTgaRtash+9n
=Vo1t
-----END PGP SIGNATURE-----

--cYG5ZC/RuVsIq1ir--
