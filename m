Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314AbaEQSNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 14:13:15 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60107 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030264AbaEQSNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 14:13:13 -0400
MIME-Version: 1.0
In-Reply-To: <CADJQGJe=CmRn0PmofRUFwZEF-Ah=NAnZVpL1uKYTDLd3Oz_OEQ@mail.gmail.com>
References: <CADJQGJe=CmRn0PmofRUFwZEF-Ah=NAnZVpL1uKYTDLd3Oz_OEQ@mail.gmail.com>
Date: Sat, 17 May 2014 20:13:12 +0200
Message-ID: <CADJQGJf=G=_w-=1Mj-WfBHf3M2TKaanGcxav3c+cpK3Oq2ELVQ@mail.gmail.com>
Subject: Re: Machine freeze on latest Linus kernel, seems related to nouveau
From: Damien Wyart <damien.wyart@gmail.com>
To: nouveau@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

After further tests, I can reproduce the problem on 3.14.4 also,
mainly by visiting the following URL with Firefox (29.0.1) :
http://lavieestmaloptimisee.blogspot.fr/

Firefox becomes unresponsive and I get some messages in the kernel log :

May 17 20:01:36 brouette kernel: BUG: unable to handle kernel paging
request at ffffc90015300000
May 17 20:01:36 brouette kernel: IP: [<ffffffff8127ff38>] iowrite32+0x38/0x40
May 17 20:01:36 brouette kernel: PGD 1b880f067 PUD 1b8850067 PMD 1b6cfd067 PTE 0
May 17 20:01:36 brouette kernel: Oops: 0002 [#1] PREEMPT SMP
May 17 20:01:36 brouette kernel: Modules linked in: usb_storage
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4
xt_dscp xt_mark cls_flow cls_fw sch_sfq sch_htb xt_helper xt_length
nf_conntrack_ftp nf_conntrack ip6table_mangle ip6_tables
iptable_mangle ip_tables x_tables cpufreq_powersave cpufreq_userspace
cpufreq_conservative deadline_iosched binfmt_misc hid_roccat_konepure
hid_roccat hid_roccat_common hid_generic snd_usb_audio snd_usbmidi_lib
usbhid snd_hwdep nouveau snd_hda_codec_realtek snd_hda_codec_generic
wmi snd_ca0106 video i2c_algo_bit snd_ac97_codec ac97_bus
snd_seq_dummy snd_seq_midi snd_seq_oss ttm snd_seq_midi_event
drm_kms_helper snd_seq drm i2c_core backlight snd_rawmidi
snd_hda_intel snd_hda_codec snd_seq_device sr_mod snd_pcm_oss pcspkr
cdrom nvidiafb snd_mixer_oss vgastate snd_pcm snd_timer ehci_pci
uhci_hcd ehci_hcd usbcore evdev usb_common acpi_cpufreq loop fuse
autofs4
May 17 20:01:36 brouette kernel: CPU: 1 PID: 12671 Comm:
plugin-containe Tainted: P           O 3.14.4 #1
May 17 20:01:36 brouette kernel: Hardware name: System manufacturer
System Product Name/P6T SE, BIOS 0808    03/08/2010
May 17 20:01:36 brouette kernel: task: ffff8800ba42a160 ti:
ffff8801ac584000 task.ti: ffff8801ac584000
May 17 20:01:36 brouette kernel: RIP: 0010:[<ffffffff8127ff38>]
[<ffffffff8127ff38>] iowrite32+0x38/0x40
May 17 20:01:36 brouette kernel: RSP: 0018:ffff8801ac585b90  EFLAGS: 00010292
May 17 20:01:36 brouette kernel: RAX: ffff8800813e65a0 RBX:
ffff8801b5aed600 RCX: 0000000000000000
May 17 20:01:36 brouette kernel: RDX: ffffc90015300000 RSI:
ffffc90015300000 RDI: 0000000000000000
May 17 20:01:36 brouette kernel: RBP: ffff8801ac585b98 R08:
ffffffffa0423100 R09: 0000000000000000
May 17 20:01:36 brouette kernel: R10: 0000000000000000 R11:
000000000000000f R12: 0000000000060004
May 17 20:01:36 brouette kernel: R13: 0000000000000000 R14:
ffff8801ac585bd8 R15: 0000000000000000
May 17 20:01:36 brouette kernel: FS:  00007f1767d15a40(0000)
GS:ffff8801bfc20000(0000) knlGS:0000000000000000
May 17 20:01:36 brouette kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
May 17 20:01:36 brouette kernel: CR2: ffffc90015300000 CR3:
000000019d752000 CR4: 00000000000007e0
May 17 20:01:36 brouette kernel: Stack:
May 17 20:01:36 brouette kernel: ffffffffa036be6f ffff8801ac585ba8
ffffffffa0368f25 ffff8801ac585c08
May 17 20:01:36 brouette kernel: ffffffffa03691c6 0100000077359400
ffffffffa0443ff0 000000001de8d000
May 17 20:01:36 brouette kernel: ffff8800813e65a0 0000000000000000
ffff8801b5aed700 ffff880165e83740
May 17 20:01:36 brouette kernel: Call Trace:
May 17 20:01:36 brouette kernel: [<ffffffffa036be6f>] ?
nouveau_barobj_wr32+0xf/0x20 [nouveau]
May 17 20:01:36 brouette kernel: [<ffffffffa0368f25>]
_nouveau_gpuobj_wr32+0x25/0x30 [nouveau]
May 17 20:01:36 brouette kernel: [<ffffffffa03691c6>]
nouveau_gpuobj_create_+0x1c6/0x2c0 [nouveau]
May 17 20:01:36 brouette kernel: [<ffffffffa036848f>]
nouveau_engctx_create_+0x24f/0x2a0 [nouveau]
May 17 20:01:36 brouette kernel: [<ffffffffa03daddc>]
nv50_graph_context_ctor+0x3c/0x80 [nouveau]
May 17 20:01:36 brouette kernel: [<ffffffffa036a8ad>]
nouveau_object_ctor+0x2d/0xc0 [nouveau]
May 17 20:01:36 brouette kernel: [<ffffffffa036b09b>]
nouveau_object_new+0xeb/0x200 [nouveau]
May 17 20:01:36 brouette kernel: [<ffffffffa03edc1b>]
nouveau_abi16_ioctl_grobj_alloc+0x6b/0xe0 [nouveau]
May 17 20:01:36 brouette kernel: [<ffffffffa0253a62>]
drm_ioctl+0x4c2/0x5f0 [drm]
May 17 20:01:36 brouette kernel: [<ffffffff810dbcb2>] ?
do_mmap_pgoff+0x2c2/0x380
May 17 20:01:36 brouette kernel: [<ffffffffa03e3799>]
nouveau_drm_ioctl+0x9/0x10 [nouveau]
May 17 20:01:36 brouette kernel: [<ffffffff81109850>] do_vfs_ioctl+0x2e0/0x4c0
May 17 20:01:36 brouette kernel: [<ffffffff81113239>] ? __fget+0x69/0xb0
May 17 20:01:36 brouette kernel: [<ffffffff81109ab1>] SyS_ioctl+0x81/0xa0
May 17 20:01:36 brouette kernel: [<ffffffff81482f62>]
system_call_fastpath+0x16/0x1b
May 17 20:01:36 brouette kernel: Code: 81 fe 00 00 01 00 76 0b 0f b7
d6 89 f8 ef c3 0f 1f 40 00 55 48 c7 c6 e1 9e 58 81 48 89 d7 48 89 e5
e8 1d fe ff ff 5d c3 0f 1f 00 <89> 3e c3 0f 1f 44 00 00 48 81 ff ff ff
03 00 77 37 48 81 ff 00
May 17 20:01:36 brouette kernel: RIP  [<ffffffff8127ff38>] iowrite32+0x38/0x40
May 17 20:01:36 brouette kernel: RSP <ffff8801ac585b90>
May 17 20:01:36 brouette kernel: CR2: ffffc90015300000
May 17 20:01:36 brouette kernel: ---[ end trace e4c3bdfb0b08f505 ]---

Thanks in advance for any help.

Best

Damien Wyart

On Fri, May 16, 2014 at 10:05 AM, Damien Wyart <damien.wyart@gmail.com> wrote:
> Hi,
>
> I am running the latest kernel from Linus. Once yesterday and once
> today, I got a freeze of my machine. The first time, I could reboot
> with sysrq, but not the second one (completely unresponsive). The
> first time,, there was nothng in the logs, but today, I got some
> traces which I attach to this email.
>
> I can provide more details if needed ; the card is GeForce 9600 GT and
> the OS Debian Sid.
>
> Thanks in advance for any feedback.
>
> Damien Wyart
