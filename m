Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaIJJQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:16:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaIJJQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:16:43 -0400
Date: Wed, 10 Sep 2014 11:16:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: BUG uncore_assign_events
Message-ID: <20140910091626.GO16043@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MmQIYbZiCoQ2kDro"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MmQIYbZiCoQ2kDro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

While fuzzing on my ivp-ep system I ran into the following:

[  431.802976] BUG: unable to handle kernel paging request at ffffffff83223=
d88
[  431.810571] IP: [<ffffffff81025f18>] uncore_assign_events+0x188/0x250
[  431.817753] PGD 1815067 PUD 1816063 PMD 0=20
[  431.822315] Oops: 0000 [#1] PREEMPT SMP=20
[  431.826683] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs=
 lockd fscache sunrpc loop x86_pkg_temp_thermal intel_powerclamp coretemp k=
vm mgag200 crct10dif_pclmul ttm crc32_pclmul drm_kms_helper ghash_clmulni_i=
ntel snd_pcm iTCO_wdt snd_timer aesni_intel aes_x86_64 joydev lrw hid_gener=
ic iTCO_vendor_support gf128mul drm sb_edac snd syscopyarea glue_helper usb=
hid ablk_helper lpc_ich soundcore hid evdev sysfillrect mei_me sysimgblt mf=
d_core mei ioatdma edac_core i2c_i801 pcspkr cryptd wmi tpm_tis ipmi_si tpm=
 ipmi_msghandler processor thermal_sys button xfs libcrc32c sg sd_mod sr_mo=
d crc_t10dif cdrom crct10dif_common ehci_pci ehci_hcd igb isci i2c_algo_bit=
 ahci i2ccore libsas dca libahci usbcore scsi_transport_sas libata ptp crc3=
2c_intel usb_common scsi_mod pps_core
[  431.903268] CPU: 1 PID: 3791 Comm: perf_fuzzer Not tainted 3.17.0-rc4+ #=
10
[  431.910937] Hardware name: Intel Corporation S2600GZ/S2600GZ, BIOS SE5C6=
00.86B.02.02.0002.122320131210 12/23/2013
[  431.922389] task: ffff8804277d2b30 ti: ffff880424238000 task.ti: ffff880=
424238000
[  431.930737] RIP: 0010:[<ffffffff81025f18>]  [<ffffffff81025f18>] uncore_=
assign_events+0x188/0x250
[  431.940639] RSP: 0018:ffff88042423bd18  EFLAGS: 00010246
[  431.946560] RAX: 0000000000000000 RBX: ffff88042698a200 RCX: ffffffff818=
23d40
[  431.954518] RDX: ffff88042402ac00 RSI: 000000000d000064 RDI: 00000000000=
00000
[  431.962478] RBP: ffff88042423bd88 R08: ffffffff81823d80 R09: ffff8804269=
8a200
[  431.970437] R10: ffffffff81823d40 R11: 0000000000000202 R12: ffff8804269=
8a210
[  431.978397] R13: 0000000000000004 R14: 0000000000000000 R15: 00000000000=
00004
[  431.986356] FS:  00007f98827ba700(0000) GS:ffff88043f840000(0000) knlGS:=
0000000000000000
[  431.995383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  432.001790] CR2: ffffffff83223d88 CR3: 000000042760d000 CR4: 00000000001=
407e0
[  432.009748] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  432.017709] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00600
[  432.025667] Stack:
[  432.027900]  00000000000001a0 00000000ffffffff ffff88042402ac00 00000002=
00000022
[  432.036151]  ffff88042698a210 0000000000000001 ffff88042698a200 00000000=
00000000
[  432.044401]  0000000000000000 ffff880426a31400 ffff88082abab300 ffff8804=
2698a200
[  432.052652] Call Trace:
[  432.055373]  [<ffffffff8102704c>] uncore_pmu_event_init+0x1cc/0x270
[  432.062363]  [<ffffffff810b0aeb>] ? __srcu_read_lock+0x6b/0x90
[  432.068865]  [<ffffffff81138fdb>] perf_init_event+0x9b/0x140
[  432.075172]  [<ffffffff81139410>] perf_event_alloc+0x390/0x450
[  432.081675]  [<ffffffff81139cac>] SYSC_perf_event_open+0x3bc/0xad0
[  432.088567]  [<ffffffff8113a3c9>] SyS_perf_event_open+0x9/0x10
[  432.095073]  [<ffffffff8152c469>] system_call_fastpath+0x16/0x1b
[  432.101766] Code: 41 89 14 86 48 39 45 b8 8d 78 01 74 2a 48 8b 54 c3 70 =
48 83 c0 01 48 63 b2 4c 01 00 00 4c 8b 82 88 01 00 00 83 fe ff 74 32 89 c7 =
<49> 0f a3 30 45 19 c0 45 85 c0 75 ac 45 31 e4 3b 7d ac 75 1c 4d=20
[  432.122830] RIP  [<ffffffff81025f18>] uncore_assign_events+0x188/0x250
[  432.130109]  RSP <ffff88042423bd18>
[  432.133992] CR2: ffffffff83223d88
[  432.138270] ---[ end trace e28cdc70094436cc ]---


# addr2line -i -e ivb-ep-build/vmlinux ffffffff81025f18

arch/x86/include/asm/bitops.h:318
arch/x86/kernel/cpu/perf_event_intel_uncore.c:3339


--MmQIYbZiCoQ2kDro
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEBbpAAoJEHZH4aRLwOS6GdsQAITzrpjWFbq6BriWbzXXF6i/
N0VZco8isiLpU9dkIqQ6l/IKwUSa1wOCydJllFpQLLyv4Sowd6V/XjziRKcPSZYR
nJ7A8df4UG179VtlJIx6729BvNw6JvbAkbuCHHBRHBG+vOjq271/cc9jL1AjGuN6
6sgfLO3dIiLi1BMbRT7HL921X5e7pMboplXmgF691wRU4KC+6kd+Zmw4ULCHdWd3
TP6Z9HNZczAqoqQEUiRciyq72Cy8yI5eOVCPaGLg9ONVWd/R3GB4au6vCCZjxNQN
i4CWh0mkXFDfWXAAwGRZXBScN6Jowsq2DgeKleDo2XpuMRM9tWLbV4wKXUU7de+z
/v/W66lTyCimJ3pj0Eo0yAWV97FxBmSU/ryLeQ1l5VXDbpDnuTokia82o8b0lvEG
Z9z5K09oPnnCtpn7oftfOTU8YwHSENrPKi4u1rcbiu7JsUBJud7elnjf59qKBqGv
Mt1xGYhfAKaaXNQl5qOb2sRAEOiwC8ZqP+LWC+2CQ0Gwg5I6LAfsZTcA/Wl2ttxK
D6qCpkWBlB0U2N1nEoG0/faNF1hpbfz8Pr7b0gR3CYTey5RGXck+9yUtiV0+W/Gk
kpbHm5Mi9lIidRubY46mF4VSHLZywimIg1P9ygOO99D61qQpwFWOLYR1pLXz1hpk
DzZRvgMXXRcILcNrY3Qh
=d9Dk
-----END PGP SIGNATURE-----

--MmQIYbZiCoQ2kDro--
