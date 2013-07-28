Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3G1RzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 13:55:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40668 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab3G1RzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 13:55:14 -0400
X-Sasl-enc: h3oNblU0VyaMhrnUT4/XcxhcVQyGl42rNNVrQx/Tbo+G 1375034113
Message-ID: <51F55AF5.5040402@imap.cc>
Date: Sun, 28 Jul 2013 19:55:01 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [3.10] [nouveau] INFO: possible circular locking dependency detected
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCF653CFDCA2E8E78BDD48D8F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCF653CFDCA2E8E78BDD48D8F
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

To whom it may concern.

With kernel 3.10.x I see this lockdep warning in my boot
log during the switch to nouveaufb:

<6>[   23.243923] fbcon: nouveaufb (fb0) is primary device
<4>[   23.245629]
<4>[   23.245631] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
<4>[   23.245632] [ INFO: possible circular locking dependency detected ]=

<4>[   23.245635] 3.10.3-capigig #1 Tainted: G        W
<4>[   23.245637] -------------------------------------------------------=

<4>[   23.245639] swapper/0/0 is trying to acquire lock:
<4>[   23.245666]  (&(&dev->vblank_time_lock)->rlock){-.....}, at: [<ffff=
ffffa00b71c1>] drm_handle_vblank+0x3a/0x28f [drm]
<4>[   23.245667]
<4>[   23.245667] but task is already holding lock:
<4>[   23.245710]  (&(&event->lock)->rlock#2){-.....}, at: [<ffffffffa012=
8aa4>] nouveau_event_trigger+0x25/0xcb [nouveau]
<4>[   23.245711]
<4>[   23.245711] which lock already depends on the new lock.
<4>[   23.245711]
<4>[   23.245712]
<4>[   23.245712] the existing dependency chain (in reverse order) is:
<4>[   23.245716]
<4>[   23.245716] -> #1 (&(&event->lock)->rlock#2){-.....}:
<4>[   23.245724]        [<ffffffff8107fa26>] lock_acquire+0x7e/0x94
<4>[   23.245730]        [<ffffffff8144694a>] _raw_spin_lock_irqsave+0x44=
/0x57
<4>[   23.245758]        [<ffffffffa0128a1a>] nouveau_event_get+0x1b/0x80=
 [nouveau]
<4>[   23.245806]        [<ffffffffa018842b>] nouveau_drm_vblank_enable+0=
xb3/0xbf [nouveau]
<4>[   23.245819]        [<ffffffffa00b782c>] drm_vblank_get+0x90/0x22c [=
drm]
<4>[   23.245831]        [<ffffffffa00b79fc>] drm_vblank_pre_modeset+0x34=
/0x49 [drm]
<4>[   23.245881]        [<ffffffffa019991c>] nv_crtc_prepare+0x48/0xdf [=
nouveau]
<4>[   23.245888]        [<ffffffffa010e9ce>] drm_crtc_helper_set_mode+0x=
25a/0x400 [drm_kms_helper]
<4>[   23.245893]        [<ffffffffa010f641>] drm_crtc_helper_set_config+=
0x6e7/0x976 [drm_kms_helper]
<4>[   23.245909]        [<ffffffffa00bed36>] drm_mode_set_config_interna=
l+0x25/0x52 [drm]
<4>[   23.245914]        [<ffffffffa010dd72>] drm_fb_helper_set_par+0x59/=
0xa2 [drm_kms_helper]
<4>[   23.245919]        [<ffffffff8124085c>] fbcon_init+0x406/0x523
<4>[   23.245923]        [<ffffffff8128f7f1>] visual_init+0xba/0x111
<4>[   23.245927]        [<ffffffff81291191>] do_bind_con_driver+0x1c7/0x=
2de
<4>[   23.245930]        [<ffffffff8129132b>] do_take_over_console+0x38/0=
x45
<4>[   23.245933]        [<ffffffff8123fe35>] do_fbcon_takeover+0x57/0x91=

<4>[   23.245936]        [<ffffffff8124119d>] fbcon_event_notify+0x4df/0x=
832
<4>[   23.245940]        [<ffffffff81057f3c>] notifier_call_chain+0x32/0x=
5e
<4>[   23.245944]        [<ffffffff810581b3>] __blocking_notifier_call_ch=
ain+0x46/0x5b
<4>[   23.245947]        [<ffffffff810581d7>] blocking_notifier_call_chai=
n+0xf/0x11
<4>[   23.245951]        [<ffffffff81232f4e>] fb_notifier_call_chain+0x16=
/0x18
<4>[   23.245955]        [<ffffffff812340fb>] register_framebuffer+0x28b/=
0x2b7
<4>[   23.245960]        [<ffffffffa010dba0>] drm_fb_helper_initial_confi=
g+0x38c/0x44f [drm_kms_helper]
<4>[   23.246010]        [<ffffffffa01945f4>] nouveau_fbcon_init+0xe3/0xf=
3 [nouveau]
<4>[   23.246057]        [<ffffffffa0188c6e>] nouveau_drm_load+0x4a6/0x4e=
f [nouveau]
<4>[   23.246071]        [<ffffffffa00bbb7e>] drm_get_pci_dev+0x14f/0x25a=
 [drm]
<4>[   23.246117]        [<ffffffffa01882cc>] nouveau_drm_probe+0x1d2/0x1=
f6 [nouveau]
<4>[   23.246122]        [<ffffffff81222f84>] local_pci_probe+0x39/0x61
<4>[   23.246126]        [<ffffffff81223f0d>] pci_device_probe+0xc8/0xf3
<4>[   23.246130]        [<ffffffff812acb19>] driver_probe_device+0x12a/0=
x2f9
<4>[   23.246133]        [<ffffffff812acd32>] __driver_attach+0x4a/0x6b
<4>[   23.246137]        [<ffffffff812ab0fc>] bus_for_each_dev+0x5c/0x89
<4>[   23.246140]        [<ffffffff812ac692>] driver_attach+0x19/0x1b
<4>[   23.246143]        [<ffffffff812ac110>] bus_add_driver+0xe4/0x21e
<4>[   23.246146]        [<ffffffff812ad241>] driver_register+0x8e/0x108
<4>[   23.246149]        [<ffffffff8122401c>] __pci_register_driver+0x5f/=
0x64
<4>[   23.246163]        [<ffffffffa00bbd13>] drm_pci_init+0x8a/0xef [drm=
]
<4>[   23.246189]        [<ffffffffa01f004d>] nouveau_drm_init+0x4d/0x100=
0 [nouveau]
<4>[   23.246193]        [<ffffffff81000283>] do_one_initcall+0x9b/0x130
<4>[   23.246197]        [<ffffffff8108a0d9>] load_module+0x1d83/0x20dd
<4>[   23.246201]        [<ffffffff8108a507>] SyS_init_module+0xd4/0xd6
<4>[   23.246205]        [<ffffffff81447d12>] system_call_fastpath+0x16/0=
x1b
<4>[   23.246209]
<4>[   23.246209] -> #0 (&(&dev->vblank_time_lock)->rlock){-.....}:
<4>[   23.246212]        [<ffffffff8107f29d>] __lock_acquire+0xc46/0xf61
<4>[   23.246215]        [<ffffffff8107fa26>] lock_acquire+0x7e/0x94
<4>[   23.246218]        [<ffffffff8144694a>] _raw_spin_lock_irqsave+0x44=
/0x57
<4>[   23.246230]        [<ffffffffa00b71c1>] drm_handle_vblank+0x3a/0x28=
f [drm]
<4>[   23.246277]        [<ffffffffa0188451>] nouveau_drm_vblank_handler+=
0x1a/0x21 [nouveau]
<4>[   23.246305]        [<ffffffffa0128ad1>] nouveau_event_trigger+0x52/=
0xcb [nouveau]
<4>[   23.246345]        [<ffffffffa014afa2>] nv04_disp_intr+0x50/0xa2 [n=
ouveau]
<4>[   23.246382]        [<ffffffffa01406b2>] nouveau_mc_intr+0x5e/0xa6 [=
nouveau]
<4>[   23.246386]        [<ffffffff810ad00d>] handle_irq_event_percpu+0x2=
9/0x128
<4>[   23.246389]        [<ffffffff810ad148>] handle_irq_event+0x3c/0x5c
<4>[   23.246393]        [<ffffffff810af849>] handle_fasteoi_irq+0x76/0xa=
a
<4>[   23.246397]        [<ffffffff81005413>] handle_irq+0x157/0x16a
<4>[   23.246400]        [<ffffffff81004fae>] do_IRQ+0x48/0x9f
<4>[   23.246403]        [<ffffffff8144746f>] ret_from_intr+0x0/0x13
<4>[   23.246407]        [<ffffffff8100b635>] arch_cpu_idle+0x13/0x1d
<4>[   23.246410]        [<ffffffff81073767>] cpu_startup_entry+0xec/0x14=
9
<4>[   23.246415]        [<ffffffff814330ad>] rest_init+0xc1/0xc8
<4>[   23.246419]        [<ffffffff81ac7d4c>] start_kernel+0x3da/0x3e7
<4>[   23.246423]        [<ffffffff81ac748d>] x86_64_start_reservations+0=
x2a/0x2c
<4>[   23.246426]        [<ffffffff81ac7577>] x86_64_start_kernel+0xe8/0x=
ef
<4>[   23.246427]
<4>[   23.246427] other info that might help us debug this:
<4>[   23.246427]
<4>[   23.246428]  Possible unsafe locking scenario:
<4>[   23.246428]
<4>[   23.246429]        CPU0                    CPU1
<4>[   23.246430]        ----                    ----
<4>[   23.246433]   lock(&(&event->lock)->rlock#2);
<4>[   23.246436]                                lock(&(&dev->vblank_time=
_lock)->rlock);
<4>[   23.246439]                                lock(&(&event->lock)->rl=
ock#2);
<4>[   23.246441]   lock(&(&dev->vblank_time_lock)->rlock);
<4>[   23.246442]
<4>[   23.246442]  *** DEADLOCK ***
<4>[   23.246442]
<4>[   23.246444] 1 lock held by swapper/0/0:
<4>[   23.246475]  #0:  (&(&event->lock)->rlock#2){-.....}, at: [<fffffff=
fa0128aa4>] nouveau_event_trigger+0x25/0xcb [nouveau]
<4>[   23.246476]
<4>[   23.246476] stack backtrace:
<4>[   23.246480] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.=
10.3-capigig #1
<4>[   23.246482] Hardware name:                  /DQ965GF, BIOS CO96510J=
=2E86A.5953.2007.0730.2059 07/30/2007
<4>[   23.246488]  ffffffff81d97690 ffff8801a7c03b28 ffffffff81444164 fff=
f8801a7c03b78
<4>[   23.246492]  ffffffff8107d878 ffffffff8107dc49 ffff8801a7c03bc8 fff=
fffff81a10b10
<4>[   23.246496]  ffffffff81a10400 ffffffff81a10b10 ffffffff81a10ae8 000=
0000000000001
<4>[   23.246497] Call Trace:
<4>[   23.246504]  <IRQ>  [<ffffffff81444164>] dump_stack+0x19/0x1d
<4>[   23.246508]  [<ffffffff8107d878>] print_circular_bug+0x1f8/0x209
<4>[   23.246511]  [<ffffffff8107dc49>] ? print_irq_inversion_bug+0x1d2/0=
x1d2
<4>[   23.246515]  [<ffffffff8107f29d>] __lock_acquire+0xc46/0xf61
<4>[   23.246519]  [<ffffffff8107fa26>] lock_acquire+0x7e/0x94
<4>[   23.246532]  [<ffffffffa00b71c1>] ? drm_handle_vblank+0x3a/0x28f [d=
rm]
<4>[   23.246536]  [<ffffffff8144694a>] _raw_spin_lock_irqsave+0x44/0x57
<4>[   23.246548]  [<ffffffffa00b71c1>] ? drm_handle_vblank+0x3a/0x28f [d=
rm]
<4>[   23.246558]  [<ffffffffa00b71c1>] drm_handle_vblank+0x3a/0x28f [drm=
]
<4>[   23.246558]  [<ffffffffa0128aa4>] ? nouveau_event_trigger+0x25/0xcb=
 [nouveau]
<4>[   23.246558]  [<ffffffffa0188451>] nouveau_drm_vblank_handler+0x1a/0=
x21 [nouveau]
<4>[   23.246558]  [<ffffffffa0128ad1>] nouveau_event_trigger+0x52/0xcb [=
nouveau]
<4>[   23.246558]  [<ffffffffa014afa2>] nv04_disp_intr+0x50/0xa2 [nouveau=
]
<4>[   23.246558]  [<ffffffffa01406b2>] nouveau_mc_intr+0x5e/0xa6 [nouvea=
u]
<4>[   23.246558]  [<ffffffff810ad00d>] handle_irq_event_percpu+0x29/0x12=
8
<4>[   23.246558]  [<ffffffff810ad148>] handle_irq_event+0x3c/0x5c
<4>[   23.246558]  [<ffffffff81446859>] ? _raw_spin_lock+0x3e/0x45
<4>[   23.246558]  [<ffffffff810af7ec>] ? handle_fasteoi_irq+0x19/0xaa
<4>[   23.246558]  [<ffffffff810af849>] handle_fasteoi_irq+0x76/0xaa
<4>[   23.246558]  [<ffffffff81005413>] handle_irq+0x157/0x16a
<4>[   23.246558]  [<ffffffff8103ce47>] ? __local_bh_enable+0x9a/0x9e
<4>[   23.246558]  [<ffffffff81004fae>] do_IRQ+0x48/0x9f
<4>[   23.246558]  [<ffffffff8144746f>] common_interrupt+0x6f/0x6f
<4>[   23.246558]  <EOI>  [<ffffffff81447520>] ? retint_restore_args+0xe/=
0xe
<4>[   23.246558]  [<ffffffff8100af27>] ? default_idle+0x10/0x17
<4>[   23.246558]  [<ffffffff8100af25>] ? default_idle+0xe/0x17
<4>[   23.246558]  [<ffffffff8100b635>] arch_cpu_idle+0x13/0x1d
<4>[   23.246558]  [<ffffffff81073767>] cpu_startup_entry+0xec/0x149
<4>[   23.246558]  [<ffffffff814330ad>] rest_init+0xc1/0xc8
<4>[   23.246558]  [<ffffffff8143302c>] ? rest_init+0x40/0xc8
<4>[   23.246558]  [<ffffffff81ac7d4c>] start_kernel+0x3da/0x3e7
<4>[   23.246558]  [<ffffffff81ac76e6>] ? repair_env_string+0x56/0x56
<4>[   23.246558]  [<ffffffff81ac748d>] x86_64_start_reservations+0x2a/0x=
2c
<4>[   23.246558]  [<ffffffff81ac7577>] x86_64_start_kernel+0xe8/0xef
<6>[   23.256206] nouveau  [     DRM] 0xD179: Parsing digital output scri=
pt table
<6>[   23.319086] nouveau  [     DRM] 0xD1C2: Parsing digital output scri=
pt table
<6>[   23.369297] Console: switching to colour frame buffer device 160x64=

<6>[   23.479124] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer devic=
e
<6>[   23.480107] nouveau 0000:01:00.0: registered panic notifier
<6>[   23.481097] [drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00=
=2E0 on minor 0

The warning appears with kernels 3.10.3 and 3.10.1 but not 3.9.x.

The W taint flag seems to come from:

<4>[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory,=
 losing 64MB of RAM.

The machine is an Intel Pentium D on an Intel DQ965GF board
(ICH7 chipset) with an nVidia GeForce 6200TC PCIe card and
dual monitors, running a 64 bit kernel.

Everything is running fine so it appears to be a false positive.


--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigCF653CFDCA2E8E78BDD48D8F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlH1WwAACgkQQ3+did9BuFuDaQCgggqgwrZzjE0ZyIj8gyRFpwQs
tP4Ani5/rm2MxT5npGiBAqiBh36uj8qF
=Z/2Y
-----END PGP SIGNATURE-----

--------------enigCF653CFDCA2E8E78BDD48D8F--
