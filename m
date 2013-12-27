Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3L0T7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 14:59:39 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:38659 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3L0T7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 14:59:38 -0500
MIME-Version: 1.0
In-Reply-To: <CA+O4pC+bHC1Bo4ERSfos8fL+FdnwXTTu_EE=rfd9eFkY7432Jg@mail.gmail.com>
References: <CA+O4pCJAL_Dqrt0mF5rbErBXbLTALx8Rrs1+vB3JmT=+rT0jCg@mail.gmail.com>
	<CA+O4pC+bHC1Bo4ERSfos8fL+FdnwXTTu_EE=rfd9eFkY7432Jg@mail.gmail.com>
Date: Fri, 27 Dec 2013 20:59:37 +0100
Message-ID: <CA+O4pCJ5xUQwRem3rvZbvv7K8BEnMW983Qq_vR0tVzwAwmVS6A@mail.gmail.com>
Subject: Re: [BUGREPORT] Linux USB 3.0
From: Markus Rechberger <mrechberger@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like DH87RL was working with 3.2.0-55-generic-pae unfortunately
we don't have such a board for testing and customer patience is
limited to bisect the kernel.

Does anyone have a clue what modification could have killed USB 3.0
support within those releases?
It does not seem to be SG support.

On Fri, Dec 27, 2013 at 6:18 PM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> I just got another USB 3.0 bugreport, the entire system crashed. That
> particular customer already filed a bugreport in November 2013 that
> his system is in a bad state when using some USB 2.0 media devices
> which even have opensource drivers built into the kernel.
>
> USB 3.0 support with Linux seems to be a disaster with Linux 3.6.12.
> The affected board is an Intel DH87RL board.
>
> On Wed, Dec 25, 2013 at 8:18 AM, Markus Rechberger
> <mrechberger@gmail.com> wrote:
>> A customer using a device with USBDEVFS is reporting following
>> backtrace (it seems to be a rather generic issue related to linux usb
>> 3.0 in general):
>> According to him this problem is reproducible as soon as he starts the
>> data transfer, is there anything known about that?
>>
>> He is using 3.12.0-031200-generic
>>
>>
>> Dec 24 14:22:39 homenas kernel: [ 1469.818460] xhci_hcd 0000:0f:00.0:
>> ERROR Transfer event TRB DMA ptr not part of current TD
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] xhci_hcd 0000:0f:00.0:
>> ERROR Transfer event TRB DMA ptr not part of current TD
>>
>> Dec 24 14:30:39 homenas kernel: last message repeated 16 times
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] xhci_hcd 0000:0f:00.0:
>> WARN Successful completion on short TX
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] xhci_hcd 0000:0f:00.0:
>> WARN Successful completion on short TX
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] xhci_hcd 0000:0f:00.0:
>> URB transfer length is wrong, xHC issue? req. len = 46080, act. len =
>> 1382400
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] BUG: unable to handle
>> kernel NULL pointer dereference at 0000000000000004
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] IP: [] finish_td+0x13f/0x250
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] PGD 0
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] Oops: 0000 [#1] SMP
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] Modules linked in:
>> videodev pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF)
>> vboxdrv(OF) dm_crypt snd_hda_codec_ca0132 snd_hda_intel snd_hda_codec
>> snd_hwdep snd_pcm snd_seq_midi dm_multipath psmouse scsi_dh
>> snd_rawmidi serio_raw sb_edac snd_seq_midi_event edac_core snd_seq
>> snd_timer snd_seq_device lpc_ich snd bnep rfcomm soundcore
>> snd_page_alloc bluetooth mei_me mei mac_hid ppdev nfsd w83627ehf
>> hwmon_vid nfs_acl auth_rpcgss coretemp nfs fscache lockd lp parport
>> sunrpc raid10 raid456 async_pq async_xor async_memcpy
>> async_raid6_recov async_tx raid0 multipath linear btrfs raid6_pq xor
>> libcrc32c osst st raid1 tg3 mptsas firewire_ohci ptp mxm_wmi
>> firewire_core ahci mptscsih pps_core crc_itu_t libahci mpt2sas mptbase
>> wmi scsi_transport_sas raid_class [last unloaded: vmnet]
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] CPU: 0 PID: 0 Comm:
>> swapper/0 Tainted: GF                 O 3.12.0-031200-generic
>> #201311031935
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] Hardware name: To Be
>> Filled By O.E.M. To Be Filled By O.E.M./X79 Extreme9, BIOS P3.30
>> 01/28/2013
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] task: ffffffff81c144a0
>> ti: ffffffff81c00000 task.ti: ffffffff81c00000
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] RIP: 0010:[]  []
>> finish_td+0x13f/0x250
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] RSP:
>> 0018:ffff88102fc03ca8  EFLAGS: 00010046
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] RAX: ffff880f865d2b10
>> RBX: ffff880f865d2b00 RCX: 0000000000000006
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] RDX: ffff880f865d2b10
>> RSI: 0000000000000007 RDI: 0000000000000046
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] RBP: ffff88102fc03d08
>> R08: 000000000000000a R09: 0000000000000000
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] R10: 00000000000006fd
>> R11: 00000000000006fc R12: ffff880fd2de0000
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] R13: ffff880fd32b1780
>> R14: 0000000000000000 R15: ffff880fd5c5f000
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] FS:
>> 0000000000000000(0000) GS:ffff88102fc00000(0000)
>> knlGS:0000000000000000
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] CS:  0010 DS: 0000 ES:
>> 0000 CR0: 0000000080050033
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] CR2: 0000000000000004
>> CR3: 0000000001c0d000 CR4: 00000000000407f0
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] Stack:
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  ffff88102fc03ce8
>> ffff880fd0bc8000 ffff88102fc03d00 ffff880fd268d1a0
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  ffff88102fc03df4
>> 0000000100000002 ffff880fd32b1780 ffff880f865d2b00
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  ffff880fd268d1a0
>> ffff880fd5c5f000 ffff880fd2de0000 ffff880fd2c497b0
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] Call Trace:
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  []
>> process_bulk_intr_td+0x116/0x2d0
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] handle_tx_event+0x656/0xb50
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] ? __queue_work+0x3b0/0x3c0
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] ? call_timer_fn+0x46/0x160
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] xhci_handle_event+0x1db/0x2a0
>>
>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] ?
>> run_timer_softirq+0x1b2/0x300
>>
>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] xhci_irq+0x120/0x1f0
>>
>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] xhci_msi_irq+0x11/0x20
>>
>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  []
>> handle_irq_event_percpu+0x5d/0x210
>>
>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] handle_irq_event+0x48/0x70
>>
>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] ?
>> native_apic_msr_eoi_write+0x14/0x20
>>
>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] handle_edge_irq+0x77/0x110
