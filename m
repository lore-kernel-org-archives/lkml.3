Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaFBM4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:56:44 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:45784 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754338AbaFBM4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:56:42 -0400
Message-ID: <538C7488.8070108@hurleysoftware.com>
Date: Mon, 02 Jun 2014 08:56:40 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.14.1 BUG: scheduling while atomic: irq/20-serial/1299/0x00000202
References: <5389FFEE.7030901@xs4all.nl>
In-Reply-To: <5389FFEE.7030901@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2014 12:14 PM, Udo van den Heuvel wrote:
> Hello,
>
> After returning from holiday I found this in dmesg:
>
> [1724773.295579] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [1725207.771256] BUG: scheduling while atomic: irq/20-serial/1299/0x00000202
> [1725207.771260] Modules linked in: btrfs lzo_compress zlib_deflate bnep
> bluetooth 6lowpan_iphc fuse edac_core cpufreq_userspace
> nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_REJECT ipt_REJECT
> nf_conntrack_ipv6 nf_defrag_ipv6 xt_tcpudp iptable_filter ipt_MASQUERADE
> xt_conntrack iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
> nf_nat nf_conntrack ip6table_filter ip6_tables ip_tables x_tables eeprom
> it87 hwmon_vid ext2 ppdev kvm_amd kvm microcode parport_serial
> parport_pc snd_usb_audio snd_usbmidi_lib snd_hwdep k10temp snd_rawmidi
> parport i2c_piix4 evdev pwc videobuf2_vmalloc videobuf2_memops
> v4l2_common videobuf2_core cp210x videodev usbserial
> snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec
> snd_seq snd_seq_device snd_pcm snd_timer snd acpi_cpufreq button nfsd
> auth_rpcgss
> [1725207.771314]  binfmt_misc oid_registry nfs_acl lockd sunrpc autofs4
> hid_generic usbhid ehci_pci ehci_hcd ohci_pci ohci_hcd radeon
> cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit backlight fbcon bitblit
> softcursor font sr_mod cdrom drm_kms_helper ttm xhci_hcd drm fb fbdev
> [1725207.771336] CPU: 2 PID: 1299 Comm: irq/20-serial Not tainted 3.14.1 #2
> [1725207.771338] Hardware name: Gigabyte Technology Co., Ltd. To be
> filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
> [1725207.771340]  0000000000000000 000000003c9f116f ffffffff814dccf6
> ffff88023ed11700
> [1725207.771346]  ffffffff814db539 ffffffff814dec5d 000000000000a000
> ffff880235461010
> [1725207.771350]  ffff88008ec13fd8 ffff880235461010 0000000000000087
> 0000000000000087
> [1725207.771353] Call Trace:
> [1725207.771364]  [<ffffffff814dccf6>] ? dump_stack+0x4a/0x75
> [1725207.771371]  [<ffffffff814db539>] ? __schedule_bug+0x3e/0x4b
> [1725207.771374]  [<ffffffff814dec5d>] ? __schedule+0x68d/0x8b0
> [1725207.771379]  [<ffffffff814df24f>] ? schedule_preempt_disabled+0xf/0x20
> [1725207.771383]  [<ffffffff814e09d4>] ? __mutex_lock_slowpath+0x124/0x200
> [1725207.771387]  [<ffffffff814e0abe>] ? mutex_lock+0xe/0x1d
> [1725207.771392]  [<ffffffff812e6019>] ? flush_to_ldisc+0x59/0x170
> [1725207.771397]  [<ffffffff812fa40c>] ? uart_insert_char+0x14c/0x180
> [1725207.771400]  [<ffffffff812fc24d>] ? serial8250_rx_chars+0xbd/0x1e0
> [1725207.771404]  [<ffffffff812fde57>] ?
> serial8250_handle_irq.part.21+0x37/0x80
> [1725207.771408]  [<ffffffff812fd0da>] ? serial8250_interrupt+0x5a/0xd0
> [1725207.771412]  [<ffffffff810aa0e0>] ? irq_thread_fn+0x50/0x50
> [1725207.771416]  [<ffffffff810aa10c>] ? irq_forced_thread_fn+0x2c/0x70
> [1725207.771419]  [<ffffffff810aa3fb>] ? irq_thread+0x12b/0x160
> [1725207.771422]  [<ffffffff810aa220>] ? wake_threads_waitq+0x30/0x30
> [1725207.771425]  [<ffffffff810aa2d0>] ? irq_thread_dtor+0xb0/0xb0
> [1725207.771429]  [<ffffffff81084941>] ? kthread+0xd1/0xf0
> [1725207.771432]  [<ffffffff81084870>] ? kthread_create_on_node+0x1b0/0x1b0
> [1725207.771435]  [<ffffffff814e2abc>] ? ret_from_fork+0x7c/0xb0
> [1725207.771438]  [<ffffffff81084870>] ? kthread_create_on_node+0x1b0/0x1b0
> [1728364.905013] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
>
>
> IRQ 20 is used by an add-in card with two serial ports:
>
> [    1.242174] 0000:03:06.0: ttyS1 at I/O 0xd050 (irq = 20, base_baud =
> 115200) is a 16550A
> [    1.262605] 0000:03:06.0: ttyS2 at I/O 0xd040 (irq = 20, base_baud =
> 115200) is a 16550A
>
>
> What happened?
> How to fix this?

Latest 3.14-stable is 3.14.5

This was fixed in 3.14.2-stable by commit 4f1f4df2c1aee858da70f91970f6c9cb651a63de,
'tty: Fix low_latency BUG'.

Regards,
Peter Hurley
