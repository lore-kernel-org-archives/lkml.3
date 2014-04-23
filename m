Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaDWRXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:23:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57507 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbaDWRXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:23:16 -0400
Date: Wed, 23 Apr 2014 12:20:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Chanwoo Choi <cwchoi00@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: extcon-next regression ?
Message-ID: <20140423172051.GS9593@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140423164033.GR9593@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kLVKJMuKEUFaIs8+"
Content-Disposition: inline
In-Reply-To: <20140423164033.GR9593@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kLVKJMuKEUFaIs8+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 23, 2014 at 11:40:33AM -0500, Felipe Balbi wrote:
> Hi Chanwoo,
>=20
> I've been testing extcon-next to make sure USB3 on OMAP5 will work out
> of the box but I see a regression when I merge your tree on top of
> v3.15-rc2 + Tony's DT fixes.
>=20
> Here's what I see (trimmed):
>=20
> [    1.805870] palmas 0-0048: Muxing GPIO 2, PWM 0, LED 0
> [    1.812516] ------------[ cut here ]------------
> [    1.817387] WARNING: CPU: 0 PID: 6 at include/linux/kref.h:47 kobject_=
get+0x64/0x78()
> [    1.817691]  mmcblk0boot1: unknown partition table
> [    1.830601] Modules linked in:
> [    1.833827] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3=
=2E15.0-rc2-00041-g3019b77 #308
> [    1.843333] Workqueue: deferwq deferred_probe_work_func
> [    1.848728]  mmcblk0boot0: unknown partition table
> [    1.853928] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_st=
ack+0x10/0x14)
> [    1.862086] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x=
84/0x9c)
> [    1.869667] [<c05426b4>] (dump_stack) from [<c0040928>] (warn_slowpath=
_common+0x6c/0x90)
> [    1.878181] [<c0040928>] (warn_slowpath_common) from [<c00409e8>] (war=
n_slowpath_null+0x1c/0x24)
> [    1.887421] [<c00409e8>] (warn_slowpath_null) from [<c02d50c4>] (kobje=
ct_get+0x64/0x78)
> [    1.895837] [<c02d50c4>] (kobject_get) from [<c0350188>] (device_add+0=
x18/0x520)
> [    1.903629] [<c0350188>] (device_add) from [<c0462a5c>] (extcon_dev_re=
gister+0x48/0x104)
> [    1.912145] [<c0462a5c>] (extcon_dev_register) from [<c0462b44>] (devm=
_extcon_dev_register+0x2c/0x68)
> [    1.921847] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] =
(palmas_usb_probe+0x110/0x304)
> [    1.931453] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platfor=
m_drv_probe+0x18/0x48)
> [    1.940333] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (drive=
r_probe_device+0x110/0x22c)
> [    1.949664] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    1.958634] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    1.967003] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    1.975387] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_=
add+0x420/0x520)
> [    1.983678] [<c0350590>] (device_add) from [<c045a310>] (of_platform_d=
evice_create_pdata+0x6c/0x8c)
> [    1.993155] [<c045a310>] (of_platform_device_create_pdata) from [<c045=
a418>] (of_platform_bus_create+0xdc/0x168)
> [    2.003818] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (o=
f_platform_populate+0x5c/0xa0)
> [    2.013399] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (pal=
mas_i2c_probe+0x30c/0x584)
> [    2.022606] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
> [    2.031722] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    2.040715] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    2.049098] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    2.057482] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_=
add+0x420/0x520)
> [    2.065774] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_devic=
e+0x12c/0x18c)
> [    2.073885] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_regis=
ter_adapter+0x278/0x498)
> [    2.082903] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (oma=
p_i2c_probe+0x4a4/0x6d0)
> [    2.091925] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_=
drv_probe+0x18/0x48)
> [    2.100582] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (drive=
r_probe_device+0x110/0x22c)
> [    2.109883] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    2.118823] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    2.127194] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    2.135584] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferre=
d_probe_work_func+0x64/0x94)
> [    2.144975] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] =
(process_one_work+0x1ac/0x4cc)
> [    2.154545] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_=
thread+0x114/0x3b4)
> [    2.163119] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0x=
d4/0xf0)
> [    2.170695] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x=
14/0x2c)
> [    2.178259] ---[ end trace 3006de6450234d28 ]---
> [    2.183081] kobject 'palmas_usb' (eca58c38): tried to add an uninitial=
ized object, something is seriously wrong.
> [    2.193731] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3=
=2E15.0-rc2-00041-g3019b77 #308
> [    2.203201] Workqueue: deferwq deferred_probe_work_func
> [    2.208687] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_st=
ack+0x10/0x14)
> [    2.216789] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x=
84/0x9c)
> [    2.224357] [<c05426b4>] (dump_stack) from [<c02d5c28>] (kobject_add+0=
x88/0x98)
> [    2.232014] [<c02d5c28>] (kobject_add) from [<c0350250>] (device_add+0=
xe0/0x520)
> [    2.239758] [<c0350250>] (device_add) from [<c0462a5c>] (extcon_dev_re=
gister+0x48/0x104)
> [    2.248235] [<c0462a5c>] (extcon_dev_register) from [<c0462b44>] (devm=
_extcon_dev_register+0x2c/0x68)
> [    2.257901] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] =
(palmas_usb_probe+0x110/0x304)
> [    2.267467] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platfor=
m_drv_probe+0x18/0x48)
> [    2.276298] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (drive=
r_probe_device+0x110/0x22c)
> [    2.285591] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    2.294520] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    2.302905] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    2.311286] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_=
add+0x420/0x520)
> [    2.319583] [<c0350590>] (device_add) from [<c045a310>] (of_platform_d=
evice_create_pdata+0x6c/0x8c)
> [    2.329063] [<c045a310>] (of_platform_device_create_pdata) from [<c045=
a418>] (of_platform_bus_create+0xdc/0x168)
> [    2.339725] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (o=
f_platform_populate+0x5c/0xa0)
> [    2.349296] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (pal=
mas_i2c_probe+0x30c/0x584)
> [    2.358496] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
> [    2.367609] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    2.376523] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    2.384914] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    2.393301] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_=
add+0x420/0x520)
> [    2.401601] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_devic=
e+0x12c/0x18c)
> [    2.409707] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_regis=
ter_adapter+0x278/0x498)
> [    2.418727] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (oma=
p_i2c_probe+0x4a4/0x6d0)
> [    2.427741] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_=
drv_probe+0x18/0x48)
> [    2.436382] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (drive=
r_probe_device+0x110/0x22c)
> [    2.445680] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    2.454613] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    2.463001] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    2.471385] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferre=
d_probe_work_func+0x64/0x94)
> [    2.480772] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] =
(process_one_work+0x1ac/0x4cc)
> [    2.490339] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_=
thread+0x114/0x3b4)
> [    2.498906] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0x=
d4/0xf0)
> [    2.506460] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x=
14/0x2c)
> [    2.514023] ------------[ cut here ]------------
> [    2.518870] WARNING: CPU: 0 PID: 6 at lib/kobject.c:670 kobject_put+0x=
80/0x90()
> [    2.526514] kobject: 'palmas_usb' (eca58c38): is not initialized, yet =
kobject_put() is being called.
> [    2.536076] Modules linked in:
> [    2.539287] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3=
=2E15.0-rc2-00041-g3019b77 #308
> [    2.548753] Workqueue: deferwq deferred_probe_work_func
> [    2.554223] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_st=
ack+0x10/0x14)
> [    2.562341] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x=
84/0x9c)
> [    2.569911] [<c05426b4>] (dump_stack) from [<c0040928>] (warn_slowpath=
_common+0x6c/0x90)
> [    2.578391] [<c0040928>] (warn_slowpath_common) from [<c004097c>] (war=
n_slowpath_fmt+0x30/0x40)
> [    2.587502] [<c004097c>] (warn_slowpath_fmt) from [<c02d5158>] (kobjec=
t_put+0x80/0x90)
> [    2.595780] [<c02d5158>] (kobject_put) from [<c03502fc>] (device_add+0=
x18c/0x520)
> [    2.603623] [<c03502fc>] (device_add) from [<c0462a5c>] (extcon_dev_re=
gister+0x48/0x104)
> [    2.612103] [<c0462a5c>] (extcon_dev_register) from [<c0462b44>] (devm=
_extcon_dev_register+0x2c/0x68)
> [    2.621762] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] =
(palmas_usb_probe+0x110/0x304)
> [    2.631321] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platfor=
m_drv_probe+0x18/0x48)
> [    2.640161] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (drive=
r_probe_device+0x110/0x22c)
> [    2.649447] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    2.658386] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    2.666757] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    2.675144] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_=
add+0x420/0x520)
> [    2.683441] [<c0350590>] (device_add) from [<c045a310>] (of_platform_d=
evice_create_pdata+0x6c/0x8c)
> [    2.692921] [<c045a310>] (of_platform_device_create_pdata) from [<c045=
a418>] (of_platform_bus_create+0xdc/0x168)
> [    2.703575] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (o=
f_platform_populate+0x5c/0xa0)
> [    2.713139] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (pal=
mas_i2c_probe+0x30c/0x584)
> [    2.722341] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
> [    2.731457] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    2.740380] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    2.748764] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    2.757135] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_=
add+0x420/0x520)
> [    2.765429] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_devic=
e+0x12c/0x18c)
> [    2.773549] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_regis=
ter_adapter+0x278/0x498)
> [    2.782576] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (oma=
p_i2c_probe+0x4a4/0x6d0)
> [    2.791597] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_=
drv_probe+0x18/0x48)
> [    2.800261] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (drive=
r_probe_device+0x110/0x22c)
> [    2.809560] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    2.818489] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    2.826865] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    2.835253] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferre=
d_probe_work_func+0x64/0x94)
> [    2.844637] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] =
(process_one_work+0x1ac/0x4cc)
> [    2.854205] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_=
thread+0x114/0x3b4)
> [    2.862778] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0x=
d4/0xf0)
> [    2.870349] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x=
14/0x2c)
> [    2.877911] ---[ end trace 3006de6450234d29 ]---
> [    2.882734] ------------[ cut here ]------------
> [    2.887573] WARNING: CPU: 0 PID: 6 at lib/kobject.c:670 kobject_put+0x=
80/0x90()
> [    2.895209] kobject: 'palmas_usb' (eca58c38): is not initialized, yet =
kobject_put() is being called.
> [    2.904765] Modules linked in:
> [    2.907971] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3=
=2E15.0-rc2-00041-g3019b77 #308
> [    2.917447] Workqueue: deferwq deferred_probe_work_func
> [    2.922924] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_st=
ack+0x10/0x14)
> [    2.931033] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x=
84/0x9c)
> [    2.938606] [<c05426b4>] (dump_stack) from [<c0040928>] (warn_slowpath=
_common+0x6c/0x90)
> [    2.947069] [<c0040928>] (warn_slowpath_common) from [<c004097c>] (war=
n_slowpath_fmt+0x30/0x40)
> [    2.956187] [<c004097c>] (warn_slowpath_fmt) from [<c02d5158>] (kobjec=
t_put+0x80/0x90)
> [    2.964483] [<c02d5158>] (kobject_put) from [<c0462abc>] (extcon_dev_r=
egister+0xa8/0x104)
> [    2.973053] [<c0462abc>] (extcon_dev_register) from [<c0462b44>] (devm=
_extcon_dev_register+0x2c/0x68)
> [    2.982718] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] =
(palmas_usb_probe+0x110/0x304)
> [    2.992285] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platfor=
m_drv_probe+0x18/0x48)
> [    3.001124] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (drive=
r_probe_device+0x110/0x22c)
> [    3.010423] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    3.019358] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    3.027746] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    3.036121] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_=
add+0x420/0x520)
> [    3.044418] [<c0350590>] (device_add) from [<c045a310>] (of_platform_d=
evice_create_pdata+0x6c/0x8c)
> [    3.053893] [<c045a310>] (of_platform_device_create_pdata) from [<c045=
a418>] (of_platform_bus_create+0xdc/0x168)
> [    3.064550] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (o=
f_platform_populate+0x5c/0xa0)
> [    3.074124] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (pal=
mas_i2c_probe+0x30c/0x584)
> [    3.083338] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_=
probe_device+0x110/0x22c)
> [    3.092447] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    3.101381] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    3.109767] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    3.118147] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_=
add+0x420/0x520)
> [    3.126432] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_devic=
e+0x12c/0x18c)
> [    3.134547] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_regis=
ter_adapter+0x278/0x498)
> [    3.143569] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (oma=
p_i2c_probe+0x4a4/0x6d0)
> [    3.152593] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_=
drv_probe+0x18/0x48)
> [    3.161249] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (drive=
r_probe_device+0x110/0x22c)
> [    3.170537] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_=
for_each_drv+0x58/0x8c)
> [    3.179472] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_=
attach+0x74/0x8c)
> [    3.187854] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_=
device+0x88/0xb0)
> [    3.196222] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferre=
d_probe_work_func+0x64/0x94)
> [    3.205611] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] =
(process_one_work+0x1ac/0x4cc)
> [    3.215174] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_=
thread+0x114/0x3b4)
> [    3.223739] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0x=
d4/0xf0)
> [    3.231313] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x=
14/0x2c)
> [    3.238883] ---[ end trace 3006de6450234d2a ]---
> [    3.243711] palmas-usb palmas_usb.7: failed to register extcon device
> [    3.250493] palmas-usb: probe of palmas_usb.7 failed with error -22
>=20
> Any ideas ??

bisected down to:

commit 854b85057cc6b90a326b731174b6c6dbbf34222a
Author: Chanwoo Choi <cw00.choi@samsung.com>
Date:   Mon Apr 21 19:46:51 2014 +0900

    extcon: Add extcon_dev_allocate/free() to control the memory of extcon =
device
   =20
    This patch add APIs to control the extcon device on extcon provider dri=
ver.
    The extcon_dev_allocate() allocates the memory of extcon device and ini=
tializes
    supported cables. And then extcon_dev_free() decrement the reference of=
 the
    device of extcon device and free the memory of the extcon device. This =
APIs
    must need to implement devm_extcon_dev_allocate()/free() APIs.
   =20
    Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index f6df689..3e485bc 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -558,6 +558,9 @@ static int create_extcon_class(void)
=20
 static void extcon_dev_release(struct device *dev)
 {
+	struct extcon_dev *edev =3D dev_to_extcon_dev(dev);
+
+	kfree(edev);
 }
=20
 static const char *muex_name =3D "mutually_exclusive";
@@ -576,7 +579,7 @@ static void dummy_sysfs_dev_release(struct device *dev)
  */
 int extcon_dev_register(struct extcon_dev *edev)
 {
-	int ret, index =3D 0;
+	int ret;
=20
 	if (!extcon_class) {
 		ret =3D create_extcon_class();
@@ -584,80 +587,150 @@ int extcon_dev_register(struct extcon_dev *edev)
 			return ret;
 	}
=20
-	if (edev->supported_cable) {
-		/* Get size of array */
-		for (index =3D 0; edev->supported_cable[index]; index++)
-			;
-		edev->max_supported =3D index;
-	} else {
-		edev->max_supported =3D 0;
+	edev->name =3D edev->name ? edev->name : dev_name(edev->dev.parent);
+	if (IS_ERR_OR_NULL(edev->name)) {
+		dev_err(&edev->dev, "extcon device name is null\n");
+		return -EINVAL;
 	}
+	dev_set_name(&edev->dev, "%s", edev->name);
=20
-	if (index > SUPPORTED_CABLE_MAX) {
-		dev_err(&edev->dev, "extcon: maximum number of supported cables exceeded=
=2E\n");
-		return -EINVAL;
+	ret =3D device_add(&edev->dev);
+	if (ret) {
+		put_device(&edev->dev);
+		return ret;
 	}
+#if defined(CONFIG_ANDROID)
+	if (switch_class)
+		ret =3D class_compat_create_link(switch_class, &edev->dev, NULL);
+#endif /* CONFIG_ANDROID */
=20
-	edev->dev.class =3D extcon_class;
-	edev->dev.release =3D extcon_dev_release;
+	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
=20
-	edev->name =3D edev->name ? edev->name : dev_name(edev->dev.parent);
-	if (IS_ERR_OR_NULL(edev->name)) {
-		dev_err(&edev->dev,
-			"extcon device name is null\n");
-		return -EINVAL;
+	dev_set_drvdata(&edev->dev, edev);
+	edev->state =3D 0;
+
+	mutex_lock(&extcon_dev_list_lock);
+	list_add(&edev->entry, &extcon_dev_list);
+	mutex_unlock(&extcon_dev_list_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(extcon_dev_register);
+
+/**
+ * extcon_dev_unregister() - Unregister the extcon device.
+ * @edev:	the extcon device instance to be unregistered.
+ */
+void extcon_dev_unregister(struct extcon_dev *edev)
+{
+	mutex_lock(&extcon_dev_list_lock);
+	list_del(&edev->entry);
+	mutex_unlock(&extcon_dev_list_lock);
+
+	if (IS_ERR_OR_NULL(get_device(&edev->dev))) {
+		dev_err(&edev->dev, "Failed to unregister extcon_dev (%s)\n",
+				dev_name(&edev->dev));
+		return;
 	}
-	dev_set_name(&edev->dev, "%s", edev->name);
=20
-	if (edev->max_supported) {
-		char buf[10];
-		char *str;
-		struct extcon_cable *cable;
+	device_unregister(&edev->dev);
=20
-		edev->cables =3D kzalloc(sizeof(struct extcon_cable) *
-				       edev->max_supported, GFP_KERNEL);
-		if (!edev->cables) {
+#if defined(CONFIG_ANDROID)
+	if (switch_class)
+		class_compat_remove_link(switch_class, &edev->dev, NULL);
+#endif
+}
+EXPORT_SYMBOL_GPL(extcon_dev_unregister);
+
+/*
+ * extcon_dev_allocate() - Allocate the memory of extcon device.
+ * @supported_cable:	Array of supported cable names ending with NULL.
+ *			If supported_cable is NULL, cable name related APIs
+ *			are disabled.
+ *
+ * This function allocates the memory for extcon device without allocating
+ * memory in each extcon provider driver and initialize default setting for
+ * extcon device.
+ *
+ * Return the pointer of extcon device if success or ERR_PTR(err) if fail
+ */
+struct extcon_dev *extcon_dev_allocate(const char **supported_cable)
+{
+	struct extcon_dev *edev;
+	int index, ret, count =3D 0;
+
+	edev =3D kzalloc(sizeof(*edev), GFP_KERNEL);
+	if (!edev) {
+		pr_err("Failed to allocate the memory for extcon device\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	edev->max_supported =3D 0;
+	edev->supported_cable =3D supported_cable;
+	if (edev->supported_cable) {
+		for (count =3D 0; edev->supported_cable[count]; count++)
+			;
+		edev->max_supported =3D count;
+		if (count > SUPPORTED_CABLE_MAX) {
+			pr_err("Exceed max number of supported cables\n");
 			ret =3D -ENOMEM;
-			goto err_sysfs_alloc;
+			goto err;
 		}
-		for (index =3D 0; index < edev->max_supported; index++) {
-			cable =3D &edev->cables[index];
+	}
=20
-			snprintf(buf, 10, "cable.%d", index);
-			str =3D kzalloc(sizeof(char) * (strlen(buf) + 1),
-				      GFP_KERNEL);
-			if (!str) {
-				for (index--; index >=3D 0; index--) {
-					cable =3D &edev->cables[index];
-					kfree(cable->attr_g.name);
-				}
-				ret =3D -ENOMEM;
+	edev->dev.class =3D extcon_class;
+	edev->dev.release =3D extcon_dev_release;
+	device_initialize(&edev->dev);
+	spin_lock_init(&edev->lock);
+
+	if (!edev->max_supported)
+		return 0;
+
+	edev->cables =3D kzalloc(sizeof(struct extcon_cable) *
+			       edev->max_supported, GFP_KERNEL);
+	if (!edev->cables) {
+		ret =3D -ENOMEM;
+		goto err;
+	}
=20
-				goto err_alloc_cables;
+	for (index =3D 0; index < edev->max_supported; index++) {
+		struct extcon_cable *cable =3D &edev->cables[index];
+		char buf[10];
+		char *str;
+
+		snprintf(buf, 10, "cable.%d", index);
+		str =3D kzalloc(sizeof(char) * (strlen(buf) + 1),
+			      GFP_KERNEL);
+		if (!str) {
+			for (index--; index >=3D 0; index--) {
+				cable =3D &edev->cables[index];
+				kfree(cable->attr_g.name);
 			}
-			strcpy(str, buf);
-
-			cable->edev =3D edev;
-			cable->cable_index =3D index;
-			cable->attrs[0] =3D &cable->attr_name.attr;
-			cable->attrs[1] =3D &cable->attr_state.attr;
-			cable->attrs[2] =3D NULL;
-			cable->attr_g.name =3D str;
-			cable->attr_g.attrs =3D cable->attrs;
-
-			sysfs_attr_init(&cable->attr_name.attr);
-			cable->attr_name.attr.name =3D "name";
-			cable->attr_name.attr.mode =3D 0444;
-			cable->attr_name.show =3D cable_name_show;
-
-			sysfs_attr_init(&cable->attr_state.attr);
-			cable->attr_state.attr.name =3D "state";
-			cable->attr_state.attr.mode =3D 0444;
-			cable->attr_state.show =3D cable_state_show;
+			ret =3D -ENOMEM;
+			goto err_alloc_cables;
 		}
+		strcpy(str, buf);
+
+		cable->edev =3D edev;
+		cable->cable_index =3D index;
+		cable->attrs[0] =3D &cable->attr_name.attr;
+		cable->attrs[1] =3D &cable->attr_state.attr;
+		cable->attrs[2] =3D NULL;
+		cable->attr_g.name =3D str;
+		cable->attr_g.attrs =3D cable->attrs;
+
+		sysfs_attr_init(&cable->attr_name.attr);
+		cable->attr_name.attr.name =3D "name";
+		cable->attr_name.attr.mode =3D 0444;
+		cable->attr_name.show =3D cable_name_show;
+
+		sysfs_attr_init(&cable->attr_state.attr);
+		cable->attr_state.attr.name =3D "state";
+		cable->attr_state.attr.mode =3D 0444;
+		cable->attr_state.show =3D cable_state_show;
 	}
=20
-	if (edev->max_supported && edev->mutually_exclusive) {
+	if (edev->mutually_exclusive) {
 		char buf[80];
 		char *name;
=20
@@ -703,59 +776,32 @@ int extcon_dev_register(struct extcon_dev *edev)
 		}
 		edev->attr_g_muex.name =3D muex_name;
 		edev->attr_g_muex.attrs =3D edev->attrs_muex;
-
 	}
=20
-	if (edev->max_supported) {
-		edev->extcon_dev_type.groups =3D
-			kzalloc(sizeof(struct attribute_group *) *
-				(edev->max_supported + 2), GFP_KERNEL);
-		if (!edev->extcon_dev_type.groups) {
-			ret =3D -ENOMEM;
-			goto err_alloc_groups;
-		}
-
-		edev->extcon_dev_type.name =3D dev_name(&edev->dev);
-		edev->extcon_dev_type.release =3D dummy_sysfs_dev_release;
-
-		for (index =3D 0; index < edev->max_supported; index++)
-			edev->extcon_dev_type.groups[index] =3D
-				&edev->cables[index].attr_g;
-		if (edev->mutually_exclusive)
-			edev->extcon_dev_type.groups[index] =3D
-				&edev->attr_g_muex;
-
-		edev->dev.type =3D &edev->extcon_dev_type;
+	edev->extcon_dev_type.groups =3D
+		kzalloc(sizeof(struct attribute_group *) *
+			(edev->max_supported + 2), GFP_KERNEL);
+	if (!edev->extcon_dev_type.groups) {
+		ret =3D -ENOMEM;
+		goto err_alloc_groups;
 	}
=20
-	ret =3D device_register(&edev->dev);
-	if (ret) {
-		put_device(&edev->dev);
-		goto err_dev;
-	}
-#if defined(CONFIG_ANDROID)
-	if (switch_class)
-		ret =3D class_compat_create_link(switch_class, &edev->dev, NULL);
-#endif /* CONFIG_ANDROID */
-
-	spin_lock_init(&edev->lock);
-
-	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
+	edev->extcon_dev_type.name =3D dev_name(&edev->dev);
+	edev->extcon_dev_type.release =3D dummy_sysfs_dev_release;
=20
-	dev_set_drvdata(&edev->dev, edev);
-	edev->state =3D 0;
+	for (index =3D 0; index < edev->max_supported; index++)
+		edev->extcon_dev_type.groups[index] =3D
+			&edev->cables[index].attr_g;
+	if (edev->mutually_exclusive)
+		edev->extcon_dev_type.groups[index] =3D
+			&edev->attr_g_muex;
=20
-	mutex_lock(&extcon_dev_list_lock);
-	list_add(&edev->entry, &extcon_dev_list);
-	mutex_unlock(&extcon_dev_list_lock);
+	edev->dev.type =3D &edev->extcon_dev_type;
=20
-	return 0;
+	return edev;
=20
-err_dev:
-	if (edev->max_supported)
-		kfree(edev->extcon_dev_type.groups);
 err_alloc_groups:
-	if (edev->max_supported && edev->mutually_exclusive) {
+	if (edev->mutually_exclusive) {
 		for (index =3D 0; edev->mutually_exclusive[index]; index++)
 			kfree(edev->d_attrs_muex[index].attr.name);
 		kfree(edev->d_attrs_muex);
@@ -765,36 +811,22 @@ err_muex:
 	for (index =3D 0; index < edev->max_supported; index++)
 		kfree(edev->cables[index].attr_g.name);
 err_alloc_cables:
-	if (edev->max_supported)
-		kfree(edev->cables);
-err_sysfs_alloc:
-	return ret;
+	kfree(edev->cables);
+err:
+	kfree(edev);
+
+	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(extcon_dev_register);
+EXPORT_SYMBOL_GPL(extcon_dev_allocate);
=20
-/**
- * extcon_dev_unregister() - Unregister the extcon device.
- * @edev:	the extcon device instance to be unregistered.
- *
- * Note that this does not call kfree(edev) because edev was not allocated
- * by this class.
+/*
+ * extcon_dev_free() - Free the memory of extcon device.
+ * @edev:	the extcon device to free
  */
-void extcon_dev_unregister(struct extcon_dev *edev)
+void extcon_dev_free(struct extcon_dev *edev)
 {
 	int index;
=20
-	mutex_lock(&extcon_dev_list_lock);
-	list_del(&edev->entry);
-	mutex_unlock(&extcon_dev_list_lock);
-
-	if (IS_ERR_OR_NULL(get_device(&edev->dev))) {
-		dev_err(&edev->dev, "Failed to unregister extcon_dev (%s)\n",
-				dev_name(&edev->dev));
-		return;
-	}
-
-	device_unregister(&edev->dev);
-
 	if (edev->mutually_exclusive && edev->max_supported) {
 		for (index =3D 0; edev->mutually_exclusive[index];
 				index++)
@@ -811,13 +843,10 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 		kfree(edev->cables);
 	}
=20
-#if defined(CONFIG_ANDROID)
-	if (switch_class)
-		class_compat_remove_link(switch_class, &edev->dev, NULL);
-#endif
-	put_device(&edev->dev);
+	if (edev)
+		put_device(&edev->dev);
 }
-EXPORT_SYMBOL_GPL(extcon_dev_unregister);
+EXPORT_SYMBOL_GPL(extcon_dev_free);
=20
 static void devm_extcon_dev_unreg(struct device *dev, void *res)
 {
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 85a8a5b..20587ee 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -179,6 +179,8 @@ struct extcon_specific_cable_nb {
=20
 #if IS_ENABLED(CONFIG_EXTCON)
=20
+#define dev_to_extcon_dev(d) container_of(d, struct extcon_dev, dev)
+
 /*
  * Following APIs are for notifiers or configurations.
  * Notifiers are the external port and connection devices.
@@ -250,6 +252,12 @@ extern int extcon_unregister_notifier(struct extcon_de=
v *edev,
 				      struct notifier_block *nb);
=20
 /*
+ * Following APIs control the memory of extcon device.
+ */
+extern struct extcon_dev *extcon_dev_allocate(const char **cables);
+extern void extcon_dev_free(struct extcon_dev *edev);
+
+/*
  * Following API get the extcon device from devicetree.
  * This function use phandle of devicetree to get extcon device directly.
  */
@@ -353,5 +361,12 @@ static inline struct extcon_dev *extcon_get_edev_by_ph=
andle(struct device *dev,
 {
 	return ERR_PTR(-ENODEV);
 }
+
+static inline struct extcon_dev *extcon_dev_allocate(const char **cables)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+static inline void extcon_dev_free(struct extcon_dev *edev) { }
 #endif /* CONFIG_EXTCON */
 #endif /* __LINUX_EXTCON_H__ */


here's full bisection log:

git bisect start
# good: [a798c10faf62a505d24e5f6213fbaf904a39623f] Linux 3.15-rc2
git bisect good a798c10faf62a505d24e5f6213fbaf904a39623f
# bad: [3019b77470c1f10b23438917f73cad386e4f7f02] Merge branch 'extcon-next=
' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon into merge
git bisect bad 3019b77470c1f10b23438917f73cad386e4f7f02
# bad: [f68f3aeb530b1efe3d6bf583db7a6255d15544eb] extcon: max14577: Use dev=
m_extcon_dev_allocate for extcon_dev
git bisect bad f68f3aeb530b1efe3d6bf583db7a6255d15544eb
# good: [489096faca790b75653478d2f9d4774dd4f07b93] extcon: gpio: Use devm_e=
xtcon_dev_register()
git bisect good 489096faca790b75653478d2f9d4774dd4f07b93
# good: [5a451cded8793798e0d409e6ed6f8c53785ae929] extcon: arizona: Use dev=
m_extcon_dev_register()
git bisect good 5a451cded8793798e0d409e6ed6f8c53785ae929
# bad: [cbe68e2d93df61fe40ddfea4d75f169fabadc155] extcon: Add devm_extcon_d=
ev_allocate/free to manage the resource of extcon device
git bisect bad cbe68e2d93df61fe40ddfea4d75f169fabadc155
# bad: [854b85057cc6b90a326b731174b6c6dbbf34222a] extcon: Add extcon_dev_al=
locate/free() to control the memory of extcon device
git bisect bad 854b85057cc6b90a326b731174b6c6dbbf34222a
# first bad commit: [854b85057cc6b90a326b731174b6c6dbbf34222a] extcon: Add =
extcon_dev_allocate/free() to control the memory of extcon device

And the bug is very simple and affects *all* users of extcon class,
which tells me that this big series switching over to devm_* resources
wasn't tested at all. Originally extcon_dev_register() was calling
device_register(&edev->dev) which will call device_initialize(dev)
followed by device_add(dev).

After this commit, extcon_dev_register() now calls
device_add(&edev->dev) directly but never calls device_initialize()
anywhere. Was this *ever* tested anywhere ????? I suppose not!

Please fix that up ASAP.

cheers

--=20
balbi

--kLVKJMuKEUFaIs8+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV/ZzAAoJEIaOsuA1yqREQbkP/0im/qbPFPcZdkyZRUoVNopJ
xtcwLgpRWgFkhScWT/zgIv5+jRM9OTdzoSkGcBmN51tDdE1/CiOk17JMKUq3xRPD
31h9eq5Ew1GjSy4zXiw4Gkk3Kgj1ENGt1E10P56DywkmPY97TTwy9UiQ+p5mFpFN
Pj7kB3+XUSS2QCx2c2GWpSA70LWXDeN3mu3E01filJyPQphQyr/vVI6jPXGTUwnX
1Y1qvH6AmSj0NEqaMbYDk+8ZfeLK/39qnkJMK4r+m3ViI3y9qvqadQqK3pwNUowd
ssMChkZSk3TlR32X/PEtCD0SgkeXyah+E/q1K35UUz20NLaN9jnMkClHEJ4b/PbY
CJcKYkUbA5Nx8AzqiSL3RIQ7iuIzpWlWAkOD/IOztP4neY4TsLl5xY0FaX1veecR
NuGixDRSoi5VVJa0L1vT7627u6OQ/f3cHE+3uGpW6nmOuZwpgMbt5xlmVgrd3Iaw
HNwBhIF4puz/wUsqTI7xLVcyJ8qv7VgDng+b6a2NRGwPs5O9CFa/jNXhcpSGrzZq
H9t+oLol3Fk2/W60I9Dq2om1w/nVv8exe+AiKmm+BI0z6JOkTuorOvnt07j0WbxS
Nx1a99tBVqF1DWGjOGiSN+X/rYC8DQhPzI3Z/2Wdp9FlzqAAlcLR/m3a8zzj37Zx
vTjkDYn9Cfu5cfcahK7K
=+HfH
-----END PGP SIGNATURE-----

--kLVKJMuKEUFaIs8+--
