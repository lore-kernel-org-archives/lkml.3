Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbaF3QqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:46:16 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59279 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaF3QqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:46:14 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: next-20140640 - fatal crash at boot time in sound drivers...
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1404146754_2021P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 30 Jun 2014 12:45:54 -0400
Message-ID: <11205.1404146754@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1404146754_2021P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Seeing this on a Dell Latitude E6530 - kernel lives for just a few
seconds before committing hari-kiri trying to initialize the sound chipse=
t.

lspci reports the following audio devices:

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Fami=
ly High Definition Audio Controller (rev 04)
01:00.1 Audio device: NVIDIA Corporation GF108 High Definition Audio Cont=
roller (rev a1)

Is working fine in next-20140618

This ring any bells, before I start doing a git bisect?

=5B    2.467707=5D netconsole: network logging started
=5B    2.467790=5D rtc_cmos 00:01: setting system clock to 2014-06-30 15:=
09:43 UTC (1404140983)
=5B    2.468008=5D BUG: unable to handle kernel NULL pointer dereference =
at           (null)
=5B    2.468077=5D IP: =5B<ffffffff8128c97d>=5D __list_add+0x6e/0x13c
=5B    2.468122=5D PGD 0=20
=5B    2.468143=5D Oops: 0000 =5B=231=5D PREEMPT SMP=20
=5B    2.468185=5D Modules linked in:
=5B    2.468214=5D CPU: 2 PID: 84 Comm: kworker/2:2 Not tainted 3.16.0-rc=
3-next-20140630 =23244
=5B    2.468244=5D ALSA device list:
=5B    2.468245=5D   No soundcards found.
=5B    2.468307=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B    2.468311=5D Workqueue: events azx_probe_work
=5B    2.468313=5D task: ffff8802237f12d0 ti: ffff8802237f4000 task.ti: f=
fff8802237f4000
=5B    2.468316=5D RIP: 0010:=5B<ffffffff8128c97d>=5D  =5B<ffffffff8128c9=
7d>=5D __list_add+0x6e/0x13c
=5B    2.468318=5D RSP: 0018:ffff8802237f7b60  EFLAGS: 00010206
=5B    2.468319=5D RAX: ffff880223752dd0 RBX: 0000000000000000 RCX: 00000=
00000000000
=5B    2.468320=5D RDX: 0000000000000000 RSI: 0000000000000000 RDI: fffff=
fff81d2a3e0
=5B    2.468322=5D RBP: ffff8802237f7b88 R08: ffff880223752d00 R09: 00000=
0000000ffff
=5B    2.468323=5D R10: ffff8802237f7ad8 R11: 00000000fffffffe R12: fffff=
fff81ea4e40
=5B    2.468324=5D R13: ffff880223752d00 R14: 0000000000000000 R15: ffff8=
8003f99fb00
=5B    2.468326=5D FS:  0000000000000000(0000) GS:ffff88022dd00000(0000) =
knlGS:0000000000000000
=5B    2.468327=5D CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
=5B    2.468328=5D CR2: 0000000000000000 CR3: 0000000001c10000 CR4: 00000=
000001407e0
=5B    2.468329=5D Stack:
=5B    2.468332=5D  ffff88003f99f040 ffffffff81ea4e40 0000000000000000 ff=
ffffff81b47254
=5B    2.468336=5D  ffff88003f99fb80 ffff8802237f7bb0 ffffffff814670a8 00=
00000000000000
=5B    2.468339=5D  ffff88003f8e9000 ffffffff818ba498 ffff8802237f7bc0 ff=
ffffff8148c830
=5B    2.468340=5D Call Trace:
=5B    2.468345=5D  =5B<ffffffff814670a8>=5D _snd_ctl_add_slave+0xb6/0xbf=

=5B    2.468349=5D  =5B<ffffffff8148c830>=5D snd_ctl_add_slave+0xb/0xd
=5B    2.468352=5D  =5B<ffffffff8148c71d>=5D map_slaves+0xb4/0xec
=5B    2.468354=5D  =5B<ffffffff8148c825>=5D ? snd_hda_enum_helper_info+0=
x4b/0x4b
=5B    2.468358=5D  =5B<ffffffff8148d9a0>=5D __snd_hda_add_vmaster+0x9b/0=
xfc
=5B    2.468361=5D  =5B<ffffffff81499c9e>=5D snd_hda_gen_build_controls+0=
xff/0x1ab
=5B    2.468365=5D  =5B<ffffffff81491a63>=5D snd_hda_codec_build_controls=
+0x38/0x196
=5B    2.468368=5D  =5B<ffffffff81491bed>=5D snd_hda_build_controls+0x2c/=
0x87
=5B    2.468370=5D  =5B<ffffffff81496c4e>=5D azx_mixer_create+0x10/0x12
=5B    2.468373=5D  =5B<ffffffff814a2c06>=5D azx_probe_work+0x3db/0x519
=5B    2.468378=5D  =5B<ffffffff81057523>=5D process_one_work+0x296/0x4b8=

=5B    2.468381=5D  =5B<ffffffff81057f2c>=5D worker_thread+0x3fc/0x54e
=5B    2.468384=5D  =5B<ffffffff81057b30>=5D ? cancel_delayed_work+0xb7/0=
xb7
=5B    2.468387=5D  =5B<ffffffff8105dbfc>=5D kthread+0xd6/0xde
=5B    2.468390=5D  =5B<ffffffff8105db26>=5D ? __kthread_parkme+0x62/0x62=

=5B    2.468394=5D  =5B<ffffffff8168bfac>=5D ret_from_fork+0x7c/0xb0
=5B    2.468396=5D  =5B<ffffffff8105db26>=5D ? __kthread_parkme+0x62/0x62=

=5B    2.468443=5D Code: be 1d 00 00 00 48 c7 c2 f4 51 b0 81 48 c7 c7 41 =
52 b0 81 31 c0 e8 d3 0d db ff 31 d2 44 89 f6 48 c7 c7 e0 a3 d2 81 e8 62 c=
a e4 ff <4c> 39 23 48 c7 c7 b8 a3 d2 81 41 0f 95 c7 31 d2 45 0f b6 f7 44 =

=5B    2.468445=5D RIP  =5B<ffffffff8128c97d>=5D __list_add+0x6e/0x13c
=5B    2.468446=5D  RSP <ffff8802237f7b60>
=5B    2.468447=5D CR2: 0000000000000000
=5B    2.468449=5D ---=5B end trace 2ff29d6bc6a184d4 =5D---
=5B    2.605416=5D tsc: Refined TSC clocksource calibration: 2691.263 MHz=

=5B    2.687337=5D usb 1-1: new high-speed USB device number 2 using ehci=
-pci
=5B    2.741253=5D ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=

=5B    2.742914=5D ata2.00: ATAPI: MATSHITA DVD+/-RW UJ8C2, 1.02, max UDM=
A/133
=5B    2.744350=5D ata2.00: configured for UDMA/133
=5B    2.745510=5D scsi 1:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ8C2=
    1.02 PQ: 0 ANSI: 5
=5B    2.804514=5D usb 1-1: New USB device found, idVendor=3D8087, idProd=
uct=3D0024
=5B    2.804545=5D usb 1-1: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
=5B    2.804909=5D hub 1-1:1.0: USB hub found
=5B    2.805005=5D hub 1-1:1.0: 6 ports detected
=5B    2.908047=5D usb 2-1: new high-speed USB device number 2 using ehci=
-pci
=5B    3.024199=5D usb 2-1: New USB device found, idVendor=3D8087, idProd=
uct=3D0024
=5B    3.024253=5D usb 2-1: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
=5B    3.024612=5D hub 2-1:1.0: USB hub found
=5B    3.024694=5D hub 2-1:1.0: 8 ports detected
=5B    3.179680=5D usb 3-1: new low-speed USB device number 2 using xhci_=
hcd
=5B    3.358523=5D usb 3-1: New USB device found, idVendor=3D045e, idProd=
uct=3D0023
=5B    3.358578=5D usb 3-1: New USB device strings: Mfr=3D1, Product=3D2,=
 SerialNumber=3D0
=5B    3.358634=5D usb 3-1: Product: Microsoft Trackball Optical=AE
=5B    3.358678=5D usb 3-1: Manufacturer: Microsoft
=5B    3.358930=5D usb 3-1: ep 0x81 - rounding interval to 64 microframes=
, ep desc says 80 microframes
=5B    3.365460=5D input: Microsoft Microsoft Trackball Optical=AE as /de=
vices/pci0000:00/0000:00:14.0/usb3/3-1/3-1:1.0/0003:045E:0023.0001/input/=
input9
=5B    3.365884=5D hid-generic 0003:045E:0023.0001: input,hidraw0: USB HI=
D v1.00 Mouse =5BMicrosoft Microsoft Trackball Optical=AE=5D on usb-0000:=
00:14.0-1/input0
=5B    3.518233=5D usb 3-4: new high-speed USB device number 3 using xhci=
_hcd
=5B    4.742601=5D Switched to clocksource tsc
=5B    4.742844=5D kworker/2:2 (84) used greatest stack depth: 11888 byte=
s left
=5B    4.743118=5D BUG: unable to handle kernel paging request at fffffff=
fffffffa8
=5B    4.746083=5D IP: =5B<ffffffff8105dfd2>=5D kthread_data+0xc/0x11
=5B    4.749966=5D PGD 1c11067 PUD 1c13067 PMD 0=20
=5B    4.754807=5D Oops: 0000 =5B=232=5D PREEMPT SMP=20
=5B    4.759798=5D Modules linked in:
=5B    4.764668=5D CPU: 2 PID: 84 Comm: kworker/2:2 Tainted: G      D    =
    3.16.0-rc3-next-20140630 =23244
=5B    4.769503=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B    4.774468=5D task: ffff8802237f12d0 ti: ffff8802237f4000 task.ti: f=
fff8802237f4000
=5B    4.779351=5D RIP: 0010:=5B<ffffffff8105dfd2>=5D  =5B<ffffffff8105df=
d2>=5D kthread_data+0xc/0x11
=5B    4.784250=5D RSP: 0018:ffff8802237f77a0  EFLAGS: 00010002
=5B    4.789373=5D RAX: 0000000000000000 RBX: ffff88022dd13d00 RCX: 00000=
0000000000f
=5B    4.794280=5D RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff8=
802237f12d0
=5B    4.799157=5D RBP: ffff8802237f77c8 R08: ffff88022dd13da8 R09: fffff=
fff81ea3000
=5B    4.804085=5D R10: ffff8802237f7650 R11: ffff8802249ac780 R12: 00000=
00000000000
=5B    4.808950=5D R13: 0000000000000002 R14: 0000000000000040 R15: ffff8=
802237f7898
=5B    4.813761=5D FS:  0000000000000000(0000) GS:ffff88022dd00000(0000) =
knlGS:0000000000000000
=5B    4.818642=5D CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
=5B    4.823588=5D CR2: 0000000000000028 CR3: 0000000001c10000 CR4: 00000=
000001407e0
=5B    4.828539=5D Stack:
=5B    4.833335=5D  ffffffff81058150 ffff88022dd13d00 0000000000000000 00=
00000000000002
=5B    4.838307=5D  0000000000000040 ffff8802237f7838 ffffffff8168639f ff=
ff8802237f7fd8
=5B    4.843246=5D  ffff8802237f12d0 ffff8802249ac780 0000000000013d00 ff=
ff88022dd13d00
=5B    4.848167=5D Call Trace:
=5B    4.853149=5D  =5B<ffffffff81058150>=5D ? wq_worker_sleeping+0x13/0x=
105
=5B    4.858028=5D  =5B<ffffffff8168639f>=5D __schedule+0x2a3/0xa91
=5B    4.862946=5D  =5B<ffffffff81686bf1>=5D schedule+0x64/0x66
=5B    4.867860=5D  =5B<ffffffff8103f119>=5D do_exit+0xbbf/0xc0c
=5B    4.872616=5D  =5B<ffffffff8107fc72>=5D ? arch_local_irq_save+0x9/0x=
c
=5B    4.877432=5D  =5B<ffffffff8100577f>=5D oops_end+0x7c/0x81
=5B    4.882219=5D  =5B<ffffffff8102f336>=5D no_context+0x25c/0x2b0
=5B    4.887043=5D  =5B<ffffffff8102f3f9>=5D __bad_area_nosemaphore+0x6f/=
0x1fe
=5B    4.892019=5D  =5B<ffffffff8102f596>=5D bad_area_nosemaphore+0xe/0x1=
0
=5B    4.897024=5D  =5B<ffffffff8102f955>=5D __do_page_fault+0x3bd/0x724
=5B    4.901834=5D  =5B<ffffffff81081c77>=5D ? mark_lock+0x2a/0x203
=5B    4.906643=5D  =5B<ffffffff810829a6>=5D ? __lock_acquire+0x68c/0xed1=

=5B    4.911611=5D  =5B<ffffffff810d89c4>=5D ? time_hardirqs_off+0x1b/0x2=
f
=5B    4.916428=5D  =5B<ffffffff8107ff5a>=5D ? trace_hardirqs_off_caller+=
0x4c/0xb9
=5B    4.921245=5D  =5B<ffffffff81282e0a>=5D ? trace_hardirqs_off_thunk+0=
x3a/0x3c
=5B    4.926095=5D  =5B<ffffffff8102fcc8>=5D do_page_fault+0xc/0xe
=5B    4.930911=5D  =5B<ffffffff8168dc52>=5D page_fault+0x22/0x30
=5B    4.935712=5D  =5B<ffffffff8128c97d>=5D ? __list_add+0x6e/0x13c
=5B    4.940601=5D  =5B<ffffffff814670a8>=5D _snd_ctl_add_slave+0xb6/0xbf=

=5B    4.945404=5D  =5B<ffffffff8148c830>=5D snd_ctl_add_slave+0xb/0xd
=5B    4.950219=5D  =5B<ffffffff8148c71d>=5D map_slaves+0xb4/0xec
=5B    4.954877=5D  =5B<ffffffff8148c825>=5D ? snd_hda_enum_helper_info+0=
x4b/0x4b
=5B    4.959733=5D  =5B<ffffffff8148d9a0>=5D __snd_hda_add_vmaster+0x9b/0=
xfc
=5B    4.964346=5D  =5B<ffffffff81499c9e>=5D snd_hda_gen_build_controls+0=
xff/0x1ab
=5B    4.968948=5D  =5B<ffffffff81491a63>=5D snd_hda_codec_build_controls=
+0x38/0x196
=5B    4.973562=5D  =5B<ffffffff81491bed>=5D snd_hda_build_controls+0x2c/=
0x87
=5B    4.978178=5D  =5B<ffffffff81496c4e>=5D azx_mixer_create+0x10/0x12
=5B    4.982693=5D  =5B<ffffffff814a2c06>=5D azx_probe_work+0x3db/0x519
=5B    4.987371=5D  =5B<ffffffff81057523>=5D process_one_work+0x296/0x4b8=

=5B    4.991806=5D  =5B<ffffffff81057f2c>=5D worker_thread+0x3fc/0x54e
=5B    4.996432=5D  =5B<ffffffff81057b30>=5D ? cancel_delayed_work+0xb7/0=
xb7
=5B    5.000828=5D  =5B<ffffffff8105dbfc>=5D kthread+0xd6/0xde
=5B    5.005151=5D  =5B<ffffffff8105db26>=5D ? __kthread_parkme+0x62/0x62=

=5B    5.009500=5D  =5B<ffffffff8168bfac>=5D ret_from_fork+0x7c/0xb0
=5B    5.013921=5D  =5B<ffffffff8105db26>=5D ? __kthread_parkme+0x62/0x62=

=5B    5.018307=5D Code: 48 8b 04 25 80 b9 00 00 48 8b 80 d8 04 00 00 48 =
89 e5 5d 48 8b 40 98 48 c1 e8 02 83 e0 01 c3 48 8b 87 d8 04 00 00 55 48 8=
9 e5 5d <48> 8b 40 a8 c3 55 ba 08 00 00 00 48 89 e5 50 48 8b b7 d8 04 00 =

=5B    5.023570=5D RIP  =5B<ffffffff8105dfd2>=5D kthread_data+0xc/0x11
=5B    5.028173=5D  RSP <ffff8802237f77a0>
=5B    5.032760=5D CR2: ffffffffffffffa8
=5B    5.037505=5D ---=5B end trace 2ff29d6bc6a184d5 =5D---
=5B    5.211674=5D Fixing recursive fault but reboot is needed=21
=5B    5.216280=5D BUG: scheduling while atomic: kworker/2:2/84/0x0000000=
4
=5B    5.220852=5D INFO: lockdep is turned off.
=5B    5.225435=5D Modules linked in:
=5B    5.230060=5D irq event stamp: 4640
=5B    5.234609=5D hardirqs last  enabled at (4639): =5B<ffffffff8113286a=
>=5D __kmalloc+0x94/0x10d
=5B    5.239246=5D hardirqs last disabled at (4640): =5B<ffffffff8168de43=
>=5D error_sti+0x5/0x6
=5B    5.244073=5D softirqs last  enabled at (4294): =5B<ffffffff81041faa=
>=5D __do_softirq+0x2ab/0x403
=5B    5.248509=5D softirqs last disabled at (4255): =5B<ffffffff810423a5=
>=5D irq_exit+0x4c/0xbb
=5B    5.253019=5D CPU: 2 PID: 84 Comm: kworker/2:2 Tainted: G      D    =
    3.16.0-rc3-next-20140630 =23244
=5B    5.257493=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B    5.261861=5D  0000000000000000 ffff8802237f73f0 ffffffff81680ccb ff=
ff8802237f12d0
=5B    5.266268=5D  0000000000000001 ffff8802237f7408 ffffffff8106667f ff=
ff88022dd13d00
=5B    5.270961=5D  ffff8802237f7478 ffffffff816861b6 ffff8802237f7fd8 ff=
ff8802237f12d0
=5B    5.275445=5D Call Trace:
=5B    5.279729=5D  =5B<ffffffff81680ccb>=5D dump_stack+0x51/0xaa
=5B    5.284243=5D  =5B<ffffffff8106667f>=5D __schedule_bug+0x5e/0x6d
=5B    5.288769=5D  =5B<ffffffff816861b6>=5D __schedule+0xba/0xa91
=5B    5.293159=5D  =5B<ffffffff81686bf1>=5D schedule+0x64/0x66
=5B    5.297348=5D  =5B<ffffffff8103e700>=5D do_exit+0x1a6/0xc0c
=5B    5.301489=5D  =5B<ffffffff8107fc72>=5D ? arch_local_irq_save+0x9/0x=
c
=5B    5.305667=5D  =5B<ffffffff81090e0b>=5D ? __rcu_read_unlock+0xf2/0xf=
9
=5B    5.309791=5D  =5B<ffffffff8108ab84>=5D ? kmsg_dump+0x18b/0x194
=5B    5.313868=5D  =5B<ffffffff8100577f>=5D oops_end+0x7c/0x81
=5B    5.317922=5D  =5B<ffffffff8102f336>=5D no_context+0x25c/0x2b0
=5B    5.321983=5D  =5B<ffffffff8102f3f9>=5D __bad_area_nosemaphore+0x6f/=
0x1fe
=5B    5.326018=5D  =5B<ffffffff8102f596>=5D bad_area_nosemaphore+0xe/0x1=
0
=5B    5.330032=5D  =5B<ffffffff8102f955>=5D __do_page_fault+0x3bd/0x724
=5B    5.334012=5D  =5B<ffffffff81083554>=5D ? lock_acquire+0xc1/0x14e
=5B    5.337966=5D  =5B<ffffffff810d89c4>=5D ? time_hardirqs_off+0x1b/0x2=
f
=5B    5.341895=5D  =5B<ffffffff8168de43>=5D ? error_sti+0x5/0x6
=5B    5.345767=5D  =5B<ffffffff8107ff2d>=5D ? trace_hardirqs_off_caller+=
0x1f/0xb9
=5B    5.349649=5D  =5B<ffffffff81282e0a>=5D ? trace_hardirqs_off_thunk+0=
x3a/0x3c
=5B    5.353528=5D  =5B<ffffffff8102fcc8>=5D do_page_fault+0xc/0xe
=5B    5.357389=5D  =5B<ffffffff8168dc52>=5D page_fault+0x22/0x30
=5B    5.361234=5D  =5B<ffffffff8105dfd2>=5D ? kthread_data+0xc/0x11
=5B    5.365089=5D  =5B<ffffffff81058150>=5D ? wq_worker_sleeping+0x13/0x=
105
=5B    5.368997=5D  =5B<ffffffff8168639f>=5D __schedule+0x2a3/0xa91
=5B    5.372809=5D  =5B<ffffffff81686bf1>=5D schedule+0x64/0x66
=5B    5.376729=5D  =5B<ffffffff8103f119>=5D do_exit+0xbbf/0xc0c
=5B    5.380532=5D  =5B<ffffffff8107fc72>=5D ? arch_local_irq_save+0x9/0x=
c
=5B    5.384415=5D  =5B<ffffffff8100577f>=5D oops_end+0x7c/0x81
=5B    5.388189=5D  =5B<ffffffff8102f336>=5D no_context+0x25c/0x2b0
=5B    5.392030=5D  =5B<ffffffff8102f3f9>=5D __bad_area_nosemaphore+0x6f/=
0x1fe
=5B    5.396037=5D  =5B<ffffffff8102f596>=5D bad_area_nosemaphore+0xe/0x1=
0
=5B    5.400019=5D  =5B<ffffffff8102f955>=5D __do_page_fault+0x3bd/0x724
=5B    5.403823=5D  =5B<ffffffff81081c77>=5D ? mark_lock+0x2a/0x203
=5B    5.407624=5D  =5B<ffffffff810829a6>=5D ? __lock_acquire+0x68c/0xed1=

=5B    5.411405=5D  =5B<ffffffff810d89c4>=5D ? time_hardirqs_off+0x1b/0x2=
f
=5B    5.415209=5D  =5B<ffffffff8107ff5a>=5D ? trace_hardirqs_off_caller+=
0x4c/0xb9
=5B    5.419107=5D  =5B<ffffffff81282e0a>=5D ? trace_hardirqs_off_thunk+0=
x3a/0x3c
=5B    5.422894=5D  =5B<ffffffff8102fcc8>=5D do_page_fault+0xc/0xe
=5B    5.426916=5D  =5B<ffffffff8168dc52>=5D page_fault+0x22/0x30
=5B    5.430708=5D  =5B<ffffffff8128c97d>=5D ? __list_add+0x6e/0x13c
=5B    5.434489=5D  =5B<ffffffff814670a8>=5D _snd_ctl_add_slave+0xb6/0xbf=

=5B    5.438290=5D  =5B<ffffffff8148c830>=5D snd_ctl_add_slave+0xb/0xd
=5B    5.442229=5D  =5B<ffffffff8148c71d>=5D map_slaves+0xb4/0xec
=5B    5.446010=5D  =5B<ffffffff8148c825>=5D ? snd_hda_enum_helper_info+0=
x4b/0x4b
=5B    5.450140=5D  =5B<ffffffff8148d9a0>=5D __snd_hda_add_vmaster+0x9b/0=
xfc
=5B    5.453932=5D  =5B<ffffffff81499c9e>=5D snd_hda_gen_build_controls+0=
xff/0x1ab
=5B    5.457821=5D  =5B<ffffffff81491a63>=5D snd_hda_codec_build_controls=
+0x38/0x196
=5B    5.461724=5D  =5B<ffffffff81491bed>=5D snd_hda_build_controls+0x2c/=
0x87
=5B    5.465524=5D  =5B<ffffffff81496c4e>=5D azx_mixer_create+0x10/0x12
=5B    5.469319=5D  =5B<ffffffff814a2c06>=5D azx_probe_work+0x3db/0x519
=5B    5.473161=5D  =5B<ffffffff81057523>=5D process_one_work+0x296/0x4b8=

=5B    5.476952=5D  =5B<ffffffff81057f2c>=5D worker_thread+0x3fc/0x54e
=5B    5.480734=5D  =5B<ffffffff81057b30>=5D ? cancel_delayed_work+0xb7/0=
xb7
=5B    5.484603=5D  =5B<ffffffff8105dbfc>=5D kthread+0xd6/0xde
=5B    5.488415=5D  =5B<ffffffff8105db26>=5D ? __kthread_parkme+0x62/0x62=

=5B    5.492334=5D  =5B<ffffffff8168bfac>=5D ret_from_fork+0x7c/0xb0
=5B    5.496116=5D  =5B<ffffffff8105db26>=5D ? __kthread_parkme+0x62/0x62=

=5B   56.430656=5D Kernel panic - not syncing: Watchdog detected hard LOC=
KUP on cpu 2
=5B   57.577582=5D Shutting down cpus with NMI
=5B   57.580830=5D Kernel Offset: 0x0 from 0xffffffff81000000 (relocation=
 range: 0xffffffff80000000-0xffffffff9fffffff)


--==_Exmh_1404146754_2021P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU7GUQgdmEQWDXROgAQKkFhAAt8K9SeKdUXsSYvAXAg390ImFOkm2n59N
NiMbx/8TZP8zqX5mlFnvMhZKCqVEbyED+chZkt3P8q5n4HLY0DEz+YSFLJIcEVL8
GHui+0/N0E9tPrXoRyqeBpl0SiNQj636Zs2+ed6+WshoAn7z+A4lz9l+s+db7dlX
FETFRudAfCejbT09RVI/o3HmGAnwc3QJMkS9XhLh5N+bpTQg4k5XcXP1sB4gmDDX
khPX+yXMLMsN8uLFxtQ4iO96EBPi/42Nxz6Lt1HH5YXTk2ea91p+FhIs3yd5QDiG
Wld6W7aTUVHTRvPtEfKnfOjS5kzAR5jZivOP0YAfPuflJSqZlBEEjYYLbVjA57Oy
0pTArB2txOLqBuZVgZ9i93XQ6e3uWkjQ6BmfQFn5Zo+SbQB+aBuT2piWpDPhS2Lp
0k1xd2AiFDkwekFJo3+h0Hceswr2X3ymliMFkrGcbY0Q4UjliyQrtvwJV4dcg6Ia
xKbk6tGp70gOm46cHfAw4iqffsZhNRTK1trQl/U3H95njPKDCnDKbbYNwZwSLx0l
G4nx1zGKJHwBC6TXaxuWsMfsWhyrPnAU2tT6tMRTkBOpFu2QToSeGP9AX/WzIfJ+
LOr5rDSBToZdK4vRTXN+OOM6qDjAuKRAc4CUlo59OoL2yTQysJIuBeGtUagkYnU2
BP+a8Dt/CGE=
=FtbB
-----END PGP SIGNATURE-----

--==_Exmh_1404146754_2021P--
