Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaCDD5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:57:30 -0500
Received: from outrelay03.libero.it ([212.52.84.103]:40423 "EHLO
	outrelay03.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbaCDD52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:57:28 -0500
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A0C0204.53154F26.0090,ss=1,re=0.000,fgs=0
X-libjamoibt: 1587
Message-ID: <10502473.12963741393905446746.JavaMail.defaultUser@defaultHost>
Date: Tue, 4 Mar 2014 04:57:26 +0100 (CET)
From: "valerio.vanni@inwind.it" <valerio.vanni@inwind.it>
Reply-To: "valerio.vanni@inwind.it" <valerio.vanni@inwind.it>
To: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: SAA7134 warning during resume from S3: regression 3.8.13 ->
 3.9.0
Cc: <mchehab@infradead.org>, <alan@lxorguk.ukuu.org.uk>,
        <linux@rainbow-software.org>, <pavel@suse.cz>, <hverkuil@xs4all.nl>,
        <michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-SenderIP: 88.149.208.102
X-libjamv: 2qNciQ+W7cI=
X-libjamsun: JhLF5nn7Rzf8V/nhgeUpGUX4vb2iHeYz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>----Messaggio originale----
>Da: valerio.vanni@inwind.it
>Data: 14/02/2014 16.29

>The full report is on bugzilla:
>https://bugzilla.kernel.org/show_bug.cgi?id=69581

>[1.] One line summary of the problem:
>
>Kernel gives a oops warning during resume
>from S3 sleep.
>
>[2.] Full description of the problem/report:
>
>OS is Debian Lenny, with vanilla kernel. It happens the same after upgrade to
>Squeeze.
>I've tried with kernels over kernels to find the point and I've found:
>the latest working kernel is 3.8.13, the first failing is 3.9.0
>
>I suspend the machine with s2ram and it goes off.
>During the resume it writes that warning, then it seem to work normally,
>except for serial redirection of console.



>------------[ cut here ]------------
>WARNING: CPU: 0 PID: 7928 at kernel/kmod.c:148 __request_module+0x34/0x1ae()
>Modules linked in: vmnet(O) vsock(O) vmci(O) vmmon(O) lp fbcon font bitblit
>softcursor i915 drm_kms_helper fb fbdev cfbcopyarea video backlight cfbimgblt
>cfbfillrect bnep nfsd lockd sunrpc fuse saa7134_alsa snd_seq_dummy 
snd_seq_oss
>snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_seq_device cifs 
rfcomm
>bluetooth rfkill it87 hwmon_vid isofs zlib_inflate nls_utf8 nls_iso8859_1
>nls_cp850 nls_cp437 nls_ascii cpuid vfat ntfs msdos fat udf nls_iso8859_15
>softdog loop tda1004x saa7134_dvb videobuf_dvb dvb_core tda827x mousedev
>tda8290 tuner snd_hda_codec_realtek snd_hda_intel snd_hda_codec saa7134
>v4l2_common usb_storage videodev r8169 snd_hwdep parport_pc snd_pcm_oss
>snd_mixer_oss videobuf_dma_sg mii ehci_pci parport videobuf_core snd_pcm
>uhci_hcd firewire_ohci firewire_core evdev crc_itu_t ehci_hcd psmouse 
rtc_cmos
>tveeprom pcspkr intel_agp intel_gtt snd_timer snd_page_alloc
>CPU: 0 PID: 7928 Comm: kworker/u8:12 Tainted: G           O 3.13.2 #1
>Hardware name: Gigabyte Technology Co., Ltd. G33M-S2/G33M-S2, BIOS F7f
>04/02/2008
>Workqueue: events_unbound async_run_entry_fn
>00000000 00000000 c13534fe c103d476 c102e079 00000009 f13ede00 f534f1a4
>f80630d0 f534f024 c102e099 00000009 00000000 c103d476 ffffffff 01000282
>c1036a29 00000282 f13edda4 c155c680 c155c680 c1036a5c 003a8aba c1353657
>Call Trace:
>[<c13534fe>] ? dump_stack+0x3e/0x50
>[<c103d476>] ? __request_module+0x34/0x1ae
>[<c102e079>] ? warn_slowpath_common+0x66/0x7a
>[<c102e099>] ? warn_slowpath_null+0xc/0xf
>[<c103d476>] ? __request_module+0x34/0x1ae
>[<c1036a29>] ? try_to_del_timer_sync+0x3a/0x41
>[<c1036a5c>] ? del_timer_sync+0x2c/0x36
>[<c1353657>] ? schedule_timeout+0x147/0x15d
>[<c1036aa6>] ? del_timer+0x40/0x40
>[<f8062370>] ? v4l2_i2c_new_subdev_board+0x23/0xa7 [v4l2_common]
>[<f806243d>] ? v4l2_i2c_new_subdev+0x49/0x51 [v4l2_common]
>[<f831290b>] ? saa7134_board_init2+0x869/0xb58 [saa7134]
>[<c1036a29>] ? try_to_del_timer_sync+0x3a/0x41
>[<c1036a5c>] ? del_timer_sync+0x2c/0x36
>[<c1353657>] ? schedule_timeout+0x147/0x15d
>[<c1030003>] ? do_exit+0x51a/0x7ce
>[<f8313ca7>] ? saa7134_resume+0xbf/0x150 [saa7134]
>[<c11ef0a7>] ? pci_legacy_resume+0x23/0x2c
>[<c11ef19a>] ? pci_pm_thaw+0x62/0x62
>[<c12650d5>] ? dpm_run_callback+0x25/0x60
>[<c1265308>] ? device_resume+0x10f/0x12c
>[<c1265338>] ? async_resume+0x13/0x33
>[<c1048004>] ? async_run_entry_fn+0x52/0xf3
>[<c103fba7>] ? process_one_work+0x200/0x331
>[<c103fe83>] ? worker_thread+0x1ab/0x2e1
>[<c103fcd8>] ? process_one_work+0x331/0x331
>[<c1044120>] ? kthread+0xa1/0xaa
>[<c135b837>] ? ret_from_kernel_thread+0x1b/0x28
>[<c104407f>] ? kthread_freezable_should_stop+0x4d/0x4d
>---[ end trace d02ad8471166632e ]---

