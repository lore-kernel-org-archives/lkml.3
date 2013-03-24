Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab3CXKvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 06:51:32 -0400
Received: from mout.gmx.net ([212.227.17.22]:62604 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab3CXKva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 06:51:30 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19OhEAVTwZO1DZl4WzmwkPWJXwnJ3MZbjWR2s40Fc
	JqLGUQtAJa43PZ
Message-ID: <514EDAAE.6030702@gmx.de>
Date: Sun, 24 Mar 2013 11:51:26 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130309 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: kernel 3.8.4 : kernel BUG at fs/locks.c:2093!
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Observed it today at a 32 bit Gentoo Linux w/ kernel 3.8.4 :


2013-03-24T11:39:48.749+01:00 n22 kernel: ------------[ cut here ]------------
2013-03-24T11:39:48.749+01:00 n22 kernel: kernel BUG at fs/locks.c:2093!
2013-03-24T11:39:48.749+01:00 n22 kernel: invalid opcode: 0000 [#1] SMP
2013-03-24T11:39:48.749+01:00 n22 kernel: Modules linked in: microcode cpufreq_stats md5 nfsd auth_rpcgss loop nls_iso8859_1 nls_cp437 vfat fat ipt_MASQUERADE xt_owner xt_multiport ipt_REJECT xt_tcpudp xt_recent xt_conntrack nf_conntrack_ftp xt_limit xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables af_packet pppoe pppox ppp_generic slhc bridge stp llc tun msr i915 arc4 cfbfillrect cfbimgblt iwldvm mac80211 i2c_algo_bit cfbcopyarea intel_agp intel_gtt fbcon snd_hda_codec_conexant bitblit softcursor font drm_kms_helper drm uvcvideo agpgart coretemp kvm_intel usblp acpi_cpufreq mperf iwlwifi cfg80211 snd_hda_intel fb i2c_i801 videobuf2_vmalloc kvm snd_hda_codec videobuf2_memops video e1000e processor fbdev videobuf2_core sdhci_pci snd_pcm videodev snd_page_alloc sdhci snd_timer mmc_core thermal wmi 8250_pci 8250_core serial_core thermal_sys thinkpad_acpi i2c_core battery button nvram snd soundcore rfkill ac tpm_tis hwmo
n tpm psmouse evdev tpm_bios aesni_intel ablk_helper cryptd lrw aes_i586 xts gf128mul cbc sha256_generic fuse nfs lockd sunrpc dm_crypt dm_mod hid_monterey hid_microsoft hid_logitech hid_ezkey hid_cypress hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech hid_generic usbhid hid sr_mod cdrom sg [last unloaded: microcode]
2013-03-24T11:39:48.749+01:00 n22 kernel: Pid: 7869, comm: kworker/3:2 Not tainted 3.8.4 #7 LENOVO 4180F65/4180F65
2013-03-24T11:39:48.749+01:00 n22 kernel: EIP: 0060:[<c11600c9>] EFLAGS: 00010246 CPU: 3
2013-03-24T11:39:48.749+01:00 n22 kernel: EIP is at locks_remove_flock+0xe9/0xf0
2013-03-24T11:39:48.749+01:00 n22 kernel: EAX: 00000001 EBX: ea81ae40 ECX: 00000032 EDX: 00003232
2013-03-24T11:39:48.749+01:00 n22 kernel: ESI: c6489e88 EDI: ef7c2100 EBP: e9a3dec0 ESP: e9a3de44
2013-03-24T11:39:48.749+01:00 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
2013-03-24T11:39:48.750+01:00 n22 kernel: CR0: 80050033 CR2: 4003455c CR3: 11384000 CR4: 000407f0
2013-03-24T11:39:48.750+01:00 n22 kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
2013-03-24T11:39:48.750+01:00 n22 kernel: DR6: ffff0ff0 DR7: 00000400
2013-03-24T11:39:48.750+01:00 n22 kernel: Process kworker/3:2 (pid: 7869, ti=e9a3c000 task=dfde9ea0 task.ti=e9a3c000)
2013-03-24T11:39:48.750+01:00 n22 kernel: Stack:
2013-03-24T11:39:48.750+01:00 n22 kernel: c6489dc8 e9a3de70 c1065355 e9a3de02 f37e0100 e9c4a840 00000199 c8667a20
2013-03-24T11:39:48.750+01:00 n22 kernel: f37e0100 dfde9ea0 f37e0100 00000003 eb08c928 c13d6fc0 dfc09a74 eb08c900
2013-03-24T11:39:48.750+01:00 n22 kernel: dfc09a7c e9a3de9c c1066011 eb08c900 dfc09a74 ea81ae48 c6489dc8 00000008
2013-03-24T11:39:48.750+01:00 n22 kernel: Call Trace:
2013-03-24T11:39:48.750+01:00 n22 kernel: [<c1065355>] ? sched_clock_cpu+0xf5/0x160
2013-03-24T11:39:48.750+01:00 n22 kernel: [<c1066011>] ? set_next_entity+0x31/0x80
2013-03-24T11:39:48.750+01:00 n22 kernel: [<c111df59>] __fput+0x79/0x1f0
2013-03-24T11:39:48.750+01:00 n22 kernel: [<c111e15c>] delayed_fput+0x7c/0x90
2013-03-24T11:39:48.750+01:00 n22 kernel: [<c104d992>] process_one_work+0x132/0x3a0
2013-03-24T11:39:48.750+01:00 n22 kernel: [<c104f211>] worker_thread+0x121/0x350
2013-03-24T11:39:48.750+01:00 n22 kernel: [<c104f0f0>] ? manage_workers+0x270/0x270
2013-03-24T11:39:48.750+01:00 n22 kernel: [<c1053974>] kthread+0x94/0xa0
2013-03-24T11:39:48.750+01:00 n22 kernel: [<c13d0677>] ret_from_kernel_thread+0x1b/0x28
2013-03-24T11:39:48.750+01:00 n22 kernel: [<c10538e0>] ? flush_kthread_work+0xd0/0xd0
2013-03-24T11:39:48.750+01:00 n22 kernel: Code: f0 e8 6c de ff ff 8b 06 85 c0 75 de 8d b6 00 00 00 00 80 05 84 56 62 c1 01 83 c4 70 5b 5e 5f 5d c3 90 89 f0 e8 f9 dd ff ff eb b9 <0f> 0b 90 90 90 90 90 55 89 e5 53 81 ec 8c 00 00 00 66 66 66 66
2013-03-24T11:39:48.750+01:00 n22 kernel: EIP: [<c11600c9>] locks_remove_flock+0xe9/0xf0 SS:ESP 0068:e9a3de44

Only the sys-rq key alt+print+b worked after that

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
