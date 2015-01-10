Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbbAJN74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 08:59:56 -0500
Received: from mout.gmx.net ([212.227.15.15]:61569 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbbAJN7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 08:59:53 -0500
Message-ID: <54B13052.8070100@gmx.de>
Date: Sat, 10 Jan 2015 14:59:46 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: "linux-kernel@vger.kernel.org >> Linux Kernel" 
	<linux-kernel@vger.kernel.org>
Subject: drivers/base/firmware_class.c:1127  can't find firmware file
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:5srXDRJjtnC9u29INsF+oSkTXspSJ2MfiynTEfGynj1/zSqcOY3
 ddxjuJD+rI1I4pCAHZhA9dImZJWwQ2WQ038i+BPRHmtSfL4/T9fwXKjDZXQ/9pHLwEo9eXb
 j/pOuOEVClrkWDY//gcDLaDQi7VKTAfE9p479cpYm7KAaqmLR1++nnNtznn2cXnYbEaW4OG
 i+Zo5v8gb4Ag2Q5VLZvvw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

at a hardened 64 bit Gentoo Linux (Lenove T440s) I played with s2disk/s2ram and observed then this in the syslog (the firmware is there, I happened just today 2x and at 15th of December -and I do s2mem few times  per day) :

Jan 10 14:54:18 t44 kernel: [115622.951776] usb 2-3.4.1: reset high-speed USB device number 46 using xhci_hcd
Jan 10 14:54:18 t44 kernel: [115623.035895] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88032e907200
Jan 10 14:54:18 t44 kernel: [115623.035897] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88032e907248
Jan 10 14:54:18 t44 kernel: [115623.035898] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88032e907290
Jan 10 14:54:18 t44 kernel: [115623.035899] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88032e9072d8
Jan 10 14:54:18 t44 kernel: [115623.036484] PM: restore of devices complete after 3677.637 msecs
Jan 10 14:54:18 t44 kernel: [115623.036713] dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in cold state, will try to load a firmware
Jan 10 14:54:18 t44 kernel: [115623.036719] ------------[ cut here ]------------
Jan 10 14:54:18 t44 kernel: [115623.036725] WARNING: CPU: 1 PID: 6738 at drivers/base/firmware_class.c:1127 _request_firmware+0x715/0x740()
Jan 10 14:54:18 t44 kernel: [115623.036726] Modules linked in: vhost_net vhost macvtap macvlan ext4 jbd2 mbcache usb_storage nfsd auth_rpcgss oid_registry lockd ctr ccm sunrpc ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_multiport nf_log_ipv4 nf_log_common xt_LOG xt_limit ipt_REJECT xt_recent xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack iptable_filter ip_tables x_tables nf_conntrack_ftp nf_conntrack af_packet bridge stp llc rc_dib0700_rc5 tun dib7000p dvb_usb_dib0700 dib3000mc dvb_usb dvb_core dib0070 dib7000m dibx000_common dib0090 rc_core usblp hid_generic hid_cherry usbhid hid uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev arc4 snd_hda_codec_generic rtsx_pci_sdmmc mmc_core evdev x86_pkg_temp_thermal coretemp kvm_intel iwlmvm kvm mac80211 aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd psmouse iwlwifi atkbd pcspkr cfg80211 thermal rtsx_pci wmi tpm_tis tpm battery ehci_pci xhci_hcd ehci_hcd thinkpad_acpi i915 nvram rf
kill fbcon cfbfillrect bitblit cfbimgblt ac i2c_algo_bit softcursor cfbcopyarea font drm_kms_helper snd_hda_intel snd_hda_controller snd_hda_codec drm snd_pcm intel_gtt video i2c_i801 agpgart processor e1000e snd_timer fb ptp usbcore thermal_sys fbdev pps_core i2c_core hwmon lpc_ich usb_common snd button mfd_core soundcore [last unloaded: microcode]
Jan 10 14:54:18 t44 kernel: [115623.036824] CPU: 1 PID: 6738 Comm: suspend.sh Tainted: G        W      3.17.7-hardened-r1 #4
Jan 10 14:54:18 t44 kernel: [115623.036826] Hardware name: LENOVO 20AQCTO1WW/20AQCTO1WW, BIOS GJET80WW (2.30 ) 10/20/2014
Jan 10 14:54:18 t44 kernel: [115623.036827]  ffffffff818147d3 0000000000000000 0000000000000009 ffffc9002ac2b9c0
Jan 10 14:54:18 t44 kernel: [115623.036830]  ffffffff81522548 0000000000000000 ffffc9002ac2b9f8 ffffffff81053d2d
Jan 10 14:54:18 t44 kernel: [115623.036833]  ffffffff81768de0 0000000000000467 ffff88030f105480 ffffc9002ac2bad8
Jan 10 14:54:18 t44 kernel: [115623.036836] Call Trace:
Jan 10 14:54:18 t44 kernel: [115623.036842]  [<ffffffff81522548>] dump_stack+0x45/0x5c
Jan 10 14:54:18 t44 kernel: [115623.036846]  [<ffffffff81053d2d>] warn_slowpath_common+0x7d/0xa0
Jan 10 14:54:18 t44 kernel: [115623.036848]  [<ffffffff81053e79>] warn_slowpath_null+0x29/0x40
Jan 10 14:54:18 t44 kernel: [115623.036857]  [<ffffffffc0310696>] ? __param_str_force_lna_activation+0xe86/0x11f8 [dvb_usb_dib0700]
Jan 10 14:54:18 t44 kernel: [115623.036860]  [<ffffffff813e7c55>] _request_firmware+0x715/0x740
Jan 10 14:54:18 t44 kernel: [115623.036865]  [<ffffffffc02a3de0>] ? __param_str_debug+0x2ad/0xbae [dvb_usb]
Jan 10 14:54:18 t44 kernel: [115623.036870]  [<ffffffffc02a3de0>] ? __param_str_debug+0x2ad/0xbae [dvb_usb]
Jan 10 14:54:18 t44 kernel: [115623.036875]  [<ffffffffc0310696>] ? __param_str_force_lna_activation+0xe86/0x11f8 [dvb_usb_dib0700]
Jan 10 14:54:18 t44 kernel: [115623.036879]  [<ffffffff813e7cb1>] request_firmware+0x31/0x50
Jan 10 14:54:18 t44 kernel: [115623.036884]  [<ffffffffc02a1344>] dvb_usb_download_firmware+0x34/0x100 [dvb_usb]
Jan 10 14:54:18 t44 kernel: [115623.036889]  [<ffffffffc02a1adc>] dvb_usb_device_init+0x53c/0x620 [dvb_usb]
Jan 10 14:54:18 t44 kernel: [115623.036898]  [<ffffffffc030940a>] dib0700_probe+0x6a/0xf0 [dvb_usb_dib0700]
Jan 10 14:54:18 t44 kernel: [115623.036903]  [<ffffffff81527425>] ? mutex_unlock+0x15/0x20
Jan 10 14:54:18 t44 kernel: [115623.036922]  [<ffffffffc00a1a39>] usb_probe_interface+0x1c9/0x2c0 [usbcore]
Jan 10 14:54:18 t44 kernel: [115623.036928]  [<ffffffff813d7527>] driver_probe_device+0x97/0x270
Jan 10 14:54:18 t44 kernel: [115623.036932]  [<ffffffff813d7700>] ? driver_probe_device+0x270/0x270
Jan 10 14:54:18 t44 kernel: [115623.036935]  [<ffffffff813d7753>] __device_attach+0x53/0x60
Jan 10 14:54:18 t44 kernel: [115623.036939]  [<ffffffff813d7700>] ? driver_probe_device+0x270/0x270
Jan 10 14:54:18 t44 kernel: [115623.036942]  [<ffffffff813d5583>] bus_for_each_drv+0x73/0xc0
Jan 10 14:54:18 t44 kernel: [115623.036945]  [<ffffffff813d7448>] device_attach+0x98/0xb0
Jan 10 14:54:18 t44 kernel: [115623.036958]  [<ffffffffc00a1631>] rebind_marked_interfaces.isra.11+0x81/0xb0 [usbcore]
Jan 10 14:54:18 t44 kernel: [115623.036971]  [<ffffffffc00a16b0>] usb_resume_complete+0x20/0x30 [usbcore]
Jan 10 14:54:18 t44 kernel: [115623.036981]  [<ffffffffc0090395>] usb_dev_complete+0x15/0x20 [usbcore]
Jan 10 14:54:18 t44 kernel: [115623.036986]  [<ffffffff813e4d19>] dpm_complete+0x119/0x380
Jan 10 14:54:18 t44 kernel: [115623.036996]  [<ffffffffc0090380>] ? usb_dev_poweroff+0x30/0x30 [usbcore]
Jan 10 14:54:18 t44 kernel: [115623.037002]  [<ffffffff8109a347>] hibernation_snapshot+0x117/0x350
Jan 10 14:54:18 t44 kernel: [115623.037005]  [<ffffffff8109ad5a>] hibernate+0x13a/0x1a0
Jan 10 14:54:18 t44 kernel: [115623.037008]  [<ffffffff810985a1>] state_store+0xe1/0xf0
Jan 10 14:54:18 t44 kernel: [115623.037013]  [<ffffffff8131d59b>] kobj_attr_store+0x3b/0x60
Jan 10 14:54:18 t44 kernel: [115623.037017]  [<ffffffff811faa81>] sysfs_kf_write+0x51/0x70
Jan 10 14:54:18 t44 kernel: [115623.037020]  [<ffffffff811fa0de>] kernfs_fop_write+0x23e/0x350
Jan 10 14:54:18 t44 kernel: [115623.037024]  [<ffffffff81181417>] ? __sb_start_write+0x57/0xf0
Jan 10 14:54:18 t44 kernel: [115623.037027]  [<ffffffff8117e424>] vfs_write+0x154/0x2d0
Jan 10 14:54:18 t44 kernel: [115623.037030]  [<ffffffff8117f18f>] SyS_write+0x4f/0xc0
Jan 10 14:54:18 t44 kernel: [115623.037035]  [<ffffffff81529cb8>] system_call_fastpath+0x16/0x1b
Jan 10 14:54:18 t44 kernel: [115623.037037] ---[ end trace 5083b133a6b73ab5 ]---
Jan 10 14:54:18 t44 kernel: [115623.037040] usb 2-3.4.1: firmware: dvb-usb-dib0700-1.20.fw will not be loaded
Jan 10 14:54:18 t44 kernel: [115623.037043] dvb-usb: did not find the firmware file. (dvb-usb-dib0700-1.20.fw) Please see linux/Documentation/dvb/ for more details on firmware-problems. (-11)
Jan 10 14:54:18 t44 kernel: [115623.038776] usblp 2-3.3:1.0: usblp0: USB Bidirectional printer dev 44 if 0 alt 0 proto 2 vid 0x043D pid 0x0078
                                                                                                                                                     


-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E

