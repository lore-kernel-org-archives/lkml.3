Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab3HNGrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 02:47:22 -0400
Received: from mail.topmatch.bg ([94.155.49.84]:54089 "EHLO
	client-94-155-49-84.ip.daticum.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672Ab3HNGrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 02:47:20 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Aug 2013 02:47:19 EDT
X-AuthUser: martin@rpasearch.com
Message-ID: <520B260E.5060307@odesys.com>
Date: Tue, 13 Aug 2013 23:39:10 -0700
From: Martin Stoilov <mstoilov@odesys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Watchdog detected hard LOCKUP on cpu
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encountered this while building custom embedded distribution with the yocto project build system.
This has never happened before for me, but google search showed quite a few similar reports.

Aug 13 15:42:12 quadpc kernel: [263676.682558] ------------[ cut here ]------------
Aug 13 15:42:12 quadpc kernel: [263676.682565] WARNING: at /build/buildd/linux-3.5.0/kernel/watchdog.c:242 watchdog_overflow_callback+0x9a/0xc0()
Aug 13 15:42:12 quadpc kernel: [263676.682566] Hardware name: System Product Name
Aug 13 15:42:12 quadpc kernel: [263676.682567] Watchdog detected hard LOCKUP on cpu 2
Aug 13 15:42:12 quadpc kernel: [263676.682568] Modules linked in: vmnet(O) parport_pc vsock(O) vmci(O) vmmon(O) rfcomm bnep bluetooth ppdev nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc snd_hda_codec_hdmi nvidia(PO) coretemp kvm_intel kvm snd_hda_codec_realtek ghash_clmulni_intel aesni_intel cryptd aes_x86_64 snd_hda_intel snd_hda_codec snd_usb_audio eeepc_wmi asus_wmi snd_usbmidi_lib sparse_keymap snd_seq_midi snd_seq_midi_event snd_rawmidi snd_hwdep snd_pcm snd_seq pl2303 usbserial snd_timer microcode snd_seq_device psmouse snd serio_raw joydev soundcore video mac_hid snd_page_alloc wmi lpc_ich mei lp parport hid_generic usbhid hid 3w_sas firewire_ohci firewire_core crc_itu_t e1000e usb_storage [last unloaded: parport_pc]
Aug 13 15:42:12 quadpc kernel: [263676.682602] Pid: 10516, comm: flush-8:32 Tainted: P           O 3.5.0-37-generic #58-Ubuntu
Aug 13 15:42:12 quadpc kernel: [263676.682603] Call Trace:
Aug 13 15:42:12 quadpc kernel: [263676.682604]  <NMI>  [<ffffffff81051bdf>] warn_slowpath_common+0x7f/0xc0
Aug 13 15:42:12 quadpc kernel: [263676.682611]  [<ffffffff81051cd6>] warn_slowpath_fmt+0x46/0x50
Aug 13 15:42:12 quadpc kernel: [263676.682613]  [<ffffffff810de930>] ? touch_nmi_watchdog+0x80/0x80
Aug 13 15:42:12 quadpc kernel: [263676.682615]  [<ffffffff810de9ca>] watchdog_overflow_callback+0x9a/0xc0
Aug 13 15:42:12 quadpc kernel: [263676.682619]  [<ffffffff8111af9d>] __perf_event_overflow+0x9d/0x230
Aug 13 15:42:12 quadpc kernel: [263676.682623]  [<ffffffff81024067>] ? x86_perf_event_set_period+0xd7/0x160
Aug 13 15:42:12 quadpc kernel: [263676.682625]  [<ffffffff8111bab4>] perf_event_overflow+0x14/0x20
Aug 13 15:42:12 quadpc kernel: [263676.682627]  [<ffffffff81029473>] intel_pmu_handle_irq+0x193/0x310
Aug 13 15:42:12 quadpc kernel: [263676.682630]  [<ffffffff81684add>] perf_event_nmi_handler+0x1d/0x20
Aug 13 15:42:12 quadpc kernel: [263676.682632]  [<ffffffff81684289>] nmi_handle.isra.0+0x59/0x80
Aug 13 15:42:12 quadpc kernel: [263676.682634]  [<ffffffff81684439>] do_nmi+0x189/0x360
Aug 13 15:42:12 quadpc kernel: [263676.682635]  [<ffffffff816838bc>] end_repeat_nmi+0x1a/0x1e
Aug 13 15:42:12 quadpc kernel: [263676.682638]  [<ffffffff8103f995>] ? __ticket_spin_lock+0x25/0x30
Aug 13 15:42:12 quadpc kernel: [263676.682639]  [<ffffffff8103f995>] ? __ticket_spin_lock+0x25/0x30
Aug 13 15:42:12 quadpc kernel: [263676.682641]  [<ffffffff8103f995>] ? __ticket_spin_lock+0x25/0x30
Aug 13 15:42:12 quadpc kernel: [263676.682642]  <<EOE>>  [<ffffffff8103fa29>] default_spin_lock_flags+0x9/0x10
Aug 13 15:42:12 quadpc kernel: [263676.682646]  [<ffffffff8168311e>] _raw_spin_lock_irqsave+0x2e/0x40
Aug 13 15:42:12 quadpc kernel: [263676.682648]  [<ffffffff8112d24c>] test_set_page_writeback+0x8c/0x180
Aug 13 15:42:12 quadpc kernel: [263676.682652]  [<ffffffff81224189>] ext4_bio_write_page+0x99/0x460
Aug 13 15:42:12 quadpc kernel: [263676.682655]  [<ffffffff81126144>] ? find_get_pages+0xc4/0x150
Aug 13 15:42:12 quadpc kernel: [263676.682657]  [<ffffffff8121fcec>] mpage_da_submit_io+0x4ec/0x5d0
Aug 13 15:42:12 quadpc kernel: [263676.682660]  [<ffffffff812221e1>] ? mpage_da_map_and_submit+0x2c1/0x4b0
Aug 13 15:42:12 quadpc kernel: [263676.682662]  [<ffffffff81220edf>] ? ext4_mark_inode_dirty+0x7f/0x1f0
Aug 13 15:42:12 quadpc kernel: [263676.682664]  [<ffffffff8122203a>] mpage_da_map_and_submit+0x11a/0x4b0
Aug 13 15:42:12 quadpc kernel: [263676.682667]  [<ffffffff81268e63>] ? jbd2_journal_start+0x13/0x20
Aug 13 15:42:12 quadpc kernel: [263676.682669]  [<ffffffff81222c73>] ext4_da_writepages+0x363/0x5d0
Aug 13 15:42:12 quadpc kernel: [263676.682672]  [<ffffffff8112ea1e>] do_writepages+0x1e/0x40
Aug 13 15:42:12 quadpc kernel: [263676.682674]  [<ffffffff811ab0eb>] __writeback_single_inode.isra.32+0x3b/0x160
Aug 13 15:42:12 quadpc kernel: [263676.682677]  [<ffffffff8107692e>] ? wake_up_bit+0x2e/0x40
Aug 13 15:42:12 quadpc kernel: [263676.682679]  [<ffffffff811abf00>] writeback_sb_inodes+0x1a0/0x390
Aug 13 15:42:12 quadpc kernel: [263676.682681]  [<ffffffff811ac18f>] __writeback_inodes_wb+0x9f/0xd0
Aug 13 15:42:12 quadpc kernel: [263676.682683]  [<ffffffff811ac403>] wb_writeback+0x243/0x2c0
Aug 13 15:42:12 quadpc kernel: [263676.682686]  [<ffffffff8119c891>] ? get_nr_inodes+0x51/0x70
Aug 13 15:42:12 quadpc kernel: [263676.682688]  [<ffffffff811ad88f>] wb_do_writeback+0x1ff/0x210
Aug 13 15:42:12 quadpc kernel: [263676.682690]  [<ffffffff811ad92b>] bdi_writeback_thread+0x8b/0x210
Aug 13 15:42:12 quadpc kernel: [263676.682691]  [<ffffffff811ad8a0>] ? wb_do_writeback+0x210/0x210
Aug 13 15:42:12 quadpc kernel: [263676.682693]  [<ffffffff81076023>] kthread+0x93/0xa0
Aug 13 15:42:12 quadpc kernel: [263676.682696]  [<ffffffff8168c3a4>] kernel_thread_helper+0x4/0x10
Aug 13 15:42:12 quadpc kernel: [263676.682698]  [<ffffffff81075f90>] ? kthread_freezable_should_stop+0x70/0x70
Aug 13 15:42:12 quadpc kernel: [263676.682699]  [<ffffffff8168c3a0>] ? gs_change+0x13/0x13
Aug 13 15:42:12 quadpc kernel: [263676.682701] ---[ end trace b1822651d1a393e4 ]---
