Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3ATKd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 05:33:26 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:45736 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3ATKdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 05:33:23 -0500
Message-ID: <50FBC7EF.6040207@xs4all.nl>
Date: Sun, 20 Jan 2013 11:33:19 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.6.11  AMD-Vi: Completion-Wait loop timed out
X-Enigmail-Version: 1.5.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

See below for a part of the logging on this F2A85X-UP4 with AMD
a10-5800k. Box was raid checking I guess.


Jan 20 03:42:08 s3 rsyslogd: [origin software="rsyslogd"
swVersion="5.8.10" x-pid="3031" x-info="http://www.rsyslog.com"]
rsyslogd was HUPed
Jan 20 04:11:17 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:17 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:17 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:17 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:17 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:17 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:17 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:17 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:17 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:17 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:18 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:18 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:18 s3 kernel: ------------[ cut here ]------------
Jan 20 04:11:18 s3 kernel: WARNING: at drivers/iommu/amd_iommu.c:1104
__domain_flush_pages+0x1ad/0x1b0()
Jan 20 04:11:18 s3 kernel: Hardware name: To be filled by O.E.M.
Jan 20 04:11:18 s3 kernel: Modules linked in: vfat fat usb_storage pwc
udf crc_itu_t nfsv3 nfs bnep bluetooth fuse cpufreq_userspace
nf_conntrack_netbios_ns eeprom nf_conntrack_broadcast ipt_REJECT
ip6t_REJECT it87 iptable_filter hwmon_vid xt_tcpudp ipt_MASQUERADE
nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat nf_conntrack_ipv4
xt_state nf_defrag_ipv4 nf_conntrack ip6table_filter ip_tables
ip6_tables x_tables dm_mirror dm_region_hash dm_log ext2 snd_usb_audio
snd_usbmidi_lib snd_hwdep snd_rawmidi snd_hda_codec_realtek
videobuf2_vmalloc videobuf2_memops videobuf2_core cdc_ether hid_generic
videodev binfmt_misc radeon cfbfillrect snd_hda_intel cfbimgblt
snd_hda_codec fbcon bitblit cfbcopyarea snd_seq softcursor i2c_algo_bit
snd_seq_device font backlight powernow_k8 mperf drm_kms_helper kvm_amd
ttm snd_pcm kvm drm fb snd_page_alloc snd_timer snd fbdev k10temp
microcode evdev i2c_piix4 xhci_hcd button nfsd exportfs auth_rpcgss
nfs_acl lockd sunrpc autofs4 usbhid ehci_hcd ohci_hcd sr_mod cdrom [last
unloaded
Jan 20 04:11:18 s3 kernel: : pwc]
Jan 20 04:11:18 s3 kernel: Pid: 506, comm: irq/43-ahci Not tainted
3.6.11 #19
Jan 20 04:11:18 s3 kernel: Call Trace:
Jan 20 04:11:18 s3 kernel: [<ffffffff8103c679>] ?
warn_slowpath_common+0x79/0xc0
Jan 20 04:11:18 s3 kernel: [<ffffffff8134598d>] ?
__domain_flush_pages+0x1ad/0x1b0
Jan 20 04:11:18 s3 kernel: [<ffffffff81345c2b>] ?
__unmap_single.isra.24+0xdb/0x110
Jan 20 04:11:18 s3 kernel: [<ffffffff81346615>] ? unmap_sg+0x55/0xb0
Jan 20 04:11:18 s3 kernel: [<ffffffff812a9a61>] ? ata_sg_clean+0x61/0xd0
Jan 20 04:11:18 s3 kernel: [<ffffffff812b039d>] ?
ata_scsi_qc_complete+0x5d/0x420
Jan 20 04:11:18 s3 kernel: [<ffffffff812a9cc0>] ?
__ata_qc_complete+0x40/0x130
Jan 20 04:11:18 s3 kernel: [<ffffffff812aa05a>] ?
ata_qc_complete_multiple+0x7a/0xc0
Jan 20 04:11:30 s3 kernel: [<ffffffff812c1d2f>] ? ahci_interrupt+0xaf/0x710
Jan 20 04:11:30 s3 kernel: [<ffffffff8109c8e0>] ? irq_thread_fn+0x40/0x40
Jan 20 04:11:30 s3 kernel: [<ffffffff8109c903>] ?
irq_forced_thread_fn+0x23/0x50
Jan 20 04:11:30 s3 kernel: [<ffffffff8109c67b>] ? irq_thread+0x11b/0x180
Jan 20 04:11:30 s3 kernel: [<ffffffff81060d8c>] ? __wake_up_common+0x4c/0x80
Jan 20 04:11:30 s3 kernel: [<ffffffff8109c7e0>] ?
irq_finalize_oneshot+0x100/0x100
Jan 20 04:11:30 s3 kernel: [<ffffffff8109c560>] ?
wake_threads_waitq+0x50/0x50
Jan 20 04:11:30 s3 kernel: [<ffffffff81058d75>] ? kthread+0x85/0x90
Jan 20 04:11:30 s3 kernel: [<ffffffff8141ec34>] ?
kernel_thread_helper+0x4/0x10
Jan 20 04:11:30 s3 kernel: [<ffffffff81058cf0>] ?
kthread_freezable_should_stop+0x50/0x50
Jan 20 04:11:30 s3 kernel: [<ffffffff8141ec30>] ? gs_change+0xb/0xb
Jan 20 04:11:30 s3 kernel: ---[ end trace 73ac82546fadadb1 ]---
Jan 20 04:11:30 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:30 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:30 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:30 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:30 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:30 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:30 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:30 s3 kernel: AMD-Vi: Completion-Wait loop timed out
Jan 20 04:11:30 s3 kernel: ------------[ cut here ]------------

And many more of the WARNINGs.

What went wrong? How to fix?


Kind regards,
Udo
