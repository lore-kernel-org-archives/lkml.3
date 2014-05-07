Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaEGQp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:45:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56038 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaEGQpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:45:54 -0400
Date: Wed, 7 May 2014 18:45:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140507164545.GR11096@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu>
 <20140505093124.GN17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405051309160.31072@vincent-weaver-1.umelst.maine.edu>
 <20140505171428.GU26782@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051443260.31072@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405052104210.1258@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405061251350.3372@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b/1sb/HZzV9blKCG"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405061251350.3372@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b/1sb/HZzV9blKCG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 12:57:08PM -0400, Vince Weaver wrote:
> On Mon, 5 May 2014, Vince Weaver wrote:
>=20
> > On Mon, 5 May 2014, Vince Weaver wrote:
> >=20
> > > Meanwhile the haswell and AMD machines have been fuzzing away without=
=20
> > > issue, I don't know why the core2 machine is always the trouble maker.
> >=20
> > The haswell has been fuzzing 12 hours with only a NMI dazed/confused=20
> > message.
>=20
> So the Haswell seemed to still be going strong after 24-hours, but then I=
=20
> killed the fuzzer with control-C and got this.
>=20
> ^C
> [87536.479011] ------------[ cut here ]------------
> [87536.484553] WARNING: CPU: 1 PID: 11978 at lib/list_debug.c:59 __list_d=
el_entry+0xa1/0xd0()
> [87536.493994] list_del corruption. prev->next should be ffff8800ce684810=
, but was 6b6b6b6b6b6b6b6b
> [87536.503915] Modules linked in: fuse x86_pkg_temp_thermal intel_powercl=
amp coretemp kvm snd_hda_codec_hdmi crct10dif_pclmul crc32_pclmul ghash_clm=
ulni_intel snd_hda_codec_realtek snd_hda_codec_generic i915 aesni_intel snd=
_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq snd_t=
imer snd_seq_device tpm_tis ppdev snd aes_x86_64 parport_pc tpm evdev mei_m=
e drm_kms_helper iTCO_wdt drm soundcore lrw gf128mul glue_helper iTCO_vendo=
r_support wmi ablk_helper i2c_algo_bit button battery processor mei psmouse=
 parport pcspkr serio_raw cryptd i2c_i801 video i2c_core lpc_ich mfd_core s=
d_mod sr_mod crc_t10dif cdrom crct10dif_common ahci libahci ehci_pci e1000e=
 libata xhci_hcd ehci_hcd ptp crc32c_intel usbcore scsi_mod pps_core usb_co=
mmon fan thermal thermal_sys
> [87536.581372] CPU: 1 PID: 11978 Comm: perf_fuzzer Tainted: G        W   =
  3.15.0-rc1+ #104
> [87536.590762] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS =
01/26/2014
> [87536.599435]  0000000000000009 ffff880117b57ad8 ffffffff81649ca0 ffff88=
0117b57b20
> [87536.608228]  ffff880117b57b10 ffffffff810646ad ffff8800ce684800 ffff88=
0036a64000
> [87536.616970]  ffff8800ce684810 ffff8800ce684800 0000000000000001 ffff88=
0117b57b70
> [87536.625688] Call Trace:
> [87536.629039]  [<ffffffff81649ca0>] dump_stack+0x45/0x56
> [87536.635247]  [<ffffffff810646ad>] warn_slowpath_common+0x7d/0xa0
> [87536.642374]  [<ffffffff8106471c>] warn_slowpath_fmt+0x4c/0x50
> [87536.649211]  [<ffffffff813c9fe1>] __list_del_entry+0xa1/0xd0
> [87536.655953]  [<ffffffff81131ec4>] list_del_event+0xe4/0xf0
> [87536.662477]  [<ffffffff811326c0>] perf_remove_from_context+0xb0/0x120
> [87536.670005]  [<ffffffff81133d8f>] perf_event_release_kernel+0x3f/0x80
> [87536.677530]  [<ffffffff81133ea3>] put_event+0xd3/0x100
> [87536.683702]  [<ffffffff81133e00>] ? put_event+0x30/0x100
> [87536.690047]  [<ffffffff81133ee5>] perf_release+0x15/0x20
> [87536.696292]  [<ffffffff811b69fc>] __fput+0xdc/0x1e0
> [87536.702191]  [<ffffffff811b6b4e>] ____fput+0xe/0x10
> [87536.708038]  [<ffffffff81085154>] task_work_run+0xc4/0xe0
> [87536.714503]  [<ffffffff81066d5c>] do_exit+0x2cc/0xa50
> [87536.720546]  [<ffffffff81076949>] ? get_signal_to_deliver+0x249/0x650
> [87536.728117]  [<ffffffff8106756c>] do_group_exit+0x4c/0xc0
> [87536.734480]  [<ffffffff81076991>] get_signal_to_deliver+0x291/0x650
> [87536.741814]  [<ffffffff81012438>] do_signal+0x48/0x990
> [87536.747877]  [<ffffffff81090c4d>] ? finish_task_switch+0x7d/0x120
> [87536.754994]  [<ffffffff81651437>] ? _raw_spin_unlock_irq+0x27/0x40
> [87536.762243]  [<ffffffff81090c4d>] ? finish_task_switch+0x7d/0x120
> [87536.769465]  [<ffffffff81090c0f>] ? finish_task_switch+0x3f/0x120
> [87536.776622]  [<ffffffff81012df0>] do_notify_resume+0x70/0xa0
> [87536.783323]  [<ffffffff81651fbc>] retint_signal+0x48/0x8c
> [87536.789726] ---[ end trace 2b5a3d32e8d767a7 ]---
> [87537.231116] ------------[ cut here ]------------

Of course it did :/ This thing can't ever _just_ work..

My WSM is playing silly buggers and prefers the endless loop (which you
saw on Core2 iirc) when I press ^C.

I'll see if I can make it do something useful.. No immediate ideas
though.

--b/1sb/HZzV9blKCG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTamM5AAoJEHZH4aRLwOS6u/MP/RhArdQ61O5fbiiwlPmP/Nlx
9dF0yqXgrJCghNNI5ElWX9A0RwF40dgqsa8R05AUWn4cVsyZZBfTFRRs2mLzaYwn
q01vUpJFq0SHitM3whiXneMj1vRF5gx8Yyxlu1BP7yAjESiSYYreEcCsvy9Yw11S
xoGU2G3Fu3A+73gRfPDy1X1BRTt2T/77g8WrTe98pBCDC+Qn36TOwTbRDMzHFZsm
+eEBFQRVKJga0pV6MQS5TZ1opQzrrLwnqlaDXrpYIIc1WHltNw6pq4EpBodD9D7R
ECcRi6f/BkNWywbvN7fkMvVDBHscDOL+ClxNQPUbrxTtmfkiAY+OAIWGN+sX51TB
d2rVPmAvLmNQ4x+pbPi3IbqrHQsbMhlw8xrc/fyjEt8vmeN9REApmSVZUuTodSfd
2q7rE8VWQBOpYe44VMpmSxVYwLC1ok8FA+uqwpBKTo9kwKHYkv1R+EuCL5YMCDEe
Th/5U9PA4/dn6N2hVHnHDSslMxKpPkUCZVpspTfykVl7UAA5rBEqaVlQdp+6I4VN
J+wzQW4u6e9UhhN4ol4unyCBGJCN71elz6LYulxM41xtIWzdVrpXR/mlb1MXtCjS
FXm0+/0bqzh4BTVfyWUThBR//pQaMx6/2pH+g8pgKrHMw0STr6/tiHi5wSIAJQ2R
UfH4kLAA0Vp2ZQJLLy8I
=LSIv
-----END PGP SIGNATURE-----

--b/1sb/HZzV9blKCG--
