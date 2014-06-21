Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbaFUJvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 05:51:08 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:39594 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbaFUJvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 05:51:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswQAFBVpVNXQwKa/2dsb2JhbABYgw2DSKgFAQEBAQEBBQGZJgICAYEIF3WEAwEBBAE6HCMFCwgDRiEYHgYTiC4DCQwBwlcNhksXhWKGcYIjB4RDAQOYS4F4AY1YhgKDRDs
Date: Sat, 21 Jun 2014 11:51:19 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Damien Wyart <damien.wyart@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG when trying to use deadline iosched in 3.16-rc1
Message-Id: <20140621115119.8d303c1ada5685c8eb9a1c27@skynet.be>
In-Reply-To: <CADJQGJeBH8RkR2KZpfJX8zxseuFjgpHhV1CiduaCPprz+ncwSQ@mail.gmail.com>
References: <CADJQGJeBH8RkR2KZpfJX8zxseuFjgpHhV1CiduaCPprz+ncwSQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2014 11:37:47 +0200
Damien Wyart <damien.wyart@gmail.com> wrote:

> Hi,
> 
> While testing 3.16-rc1, I got this error:
> 
> Jun 21 11:19:03 brouette kernel: kernel tried to execute NX-protected
> page - exploit attempt? (uid: 0)
> Jun 21 11:19:03 brouette kernel: BUG: unable to handle kernel paging
> request at ffffffff8171a1f8
> Jun 21 11:19:03 brouette kernel: IP: [<ffffffff8171a1f8>] elv_register+0x0/0x197
> Jun 21 11:19:03 brouette kernel: PGD 163d067 PUD 163e063 PMD 1b887f063
> PTE 800000000171a163
> Jun 21 11:19:03 brouette kernel: Oops: 0011 [#1] PREEMPT SMP
> Jun 21 11:19:03 brouette kernel: Modules linked in: deadline_iosched(+)
> binfmt_misc hid_roccat_konepure hid_roccat hid_roccat_common hid_generic
> snd_usb_audio snd_usbmidi_lib usbhid snd_hwdep snd_hda_codec_realtek
> snd_hda_codec_generic nouveau wmi snd_ca0106 video snd_ac97_codec
> i2c_algo_bit ttm snd_seq_dummy ac97_bus snd_seq_midi drm_kms_helper
> snd_seq_oss drm snd_seq_midi_event i2c_core snd_seq pcspkr sr_mod
> backlight snd_hda_intel snd_rawmidi snd_hda_controller cdrom
> snd_hda_codec snd_seq_device snd_pcm_oss snd_mixer_oss uhci_hcd ehci_pci
> snd_pcm ehci_hcd nvidiafb snd_timer usbcore vgastate usb_common evdev
> acpi_cpufreq loop fuse autofs4
> Jun 21 11:19:03 brouette kernel: CPU: 1 PID: 2410 Comm: modprobe
> Tainted: P           O  3.16.0-rc1 #1
> Jun 21 11:19:03 brouette kernel: Hardware name: System manufacturer
> System Product Name/P6T SE, BIOS 0808    03/08/2010
> Jun 21 11:19:03 brouette kernel: task: ffff8801b7c25b00 ti:
> ffff8801b4224000 task.ti: ffff8801b4224000
> Jun 21 11:19:03 brouette kernel: RIP: 0010:[<ffffffff8171a1f8>]
> [<ffffffff8171a1f8>] elv_register+0x0/0x197
> Jun 21 11:19:03 brouette kernel: RSP: 0018:ffff8801b4227d60  EFLAGS: 00010246
> Jun 21 11:19:03 brouette kernel: RAX: ffff8801b55a2101 RBX:
> ffffffff81641040 RCX: 0000000003be0001
> Jun 21 11:19:03 brouette kernel: RDX: 0000000003bde001 RSI:
> ffffffff815a9f0d RDI: ffffffffa103b880
> Jun 21 11:19:03 brouette kernel: RBP: ffff8801b4227d68 R08:
> 00000000000148e0 R09: 000000000000ffff
> Jun 21 11:19:03 brouette kernel: R10: 0000000000000012 R11:
> 0000000000011c00 R12: ffff8801b55a2980
> Jun 21 11:19:03 brouette kernel: R13: 0000000000000000 R14:
> ffffffffa103d000 R15: ffffffffa103ba40
> Jun 21 11:19:03 brouette kernel: FS:  00007f50c9669700(0000)
> GS:ffff8801bfc20000(0000) knlGS:0000000000000000
> Jun 21 11:19:03 brouette kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 000000008005003b
> Jun 21 11:19:03 brouette kernel: CR2: ffffffff8171a1f8 CR3:
> 00000001b7b1c000 CR4: 00000000000007e0
> Jun 21 11:19:03 brouette kernel: Stack:
> Jun 21 11:19:03 brouette kernel: ffffffffa103d010 ffff8801b4227dd8
> ffffffff810002c4 0000000000000001
> Jun 21 11:19:03 brouette kernel: 0000000000000001 ffffffffa103ba40
> ffff8801b4227db8 ffffffff810ed74a
> Jun 21 11:19:03 brouette kernel: ffff8801b4227ef8 ffffffffa103ba58
> ffffffffa103ba90 ffff8801b4227ef8
> Jun 21 11:19:03 brouette kernel: Call Trace:
> Jun 21 11:19:03 brouette kernel: [<ffffffffa103d010>] ?
> deadline_init+0x10/0x12 [deadline_iosched]
> Jun 21 11:19:03 brouette kernel: [<ffffffff810002c4>] do_one_initcall+0x84/0x1c0
> Jun 21 11:19:03 brouette kernel: [<ffffffff810ed74a>] ? __vunmap+0x9a/0x100
> Jun 21 11:19:03 brouette kernel: [<ffffffff810a23ac>] load_module+0x19bc/0x2160
> Jun 21 11:19:03 brouette kernel: [<ffffffff8109fb90>] ?
> symbol_put_addr+0x40/0x40
> Jun 21 11:19:03 brouette kernel: [<ffffffff810a2c86>] SyS_finit_module+0x76/0x80
> Jun 21 11:19:03 brouette kernel: [<ffffffff814a8692>]
> system_call_fastpath+0x16/0x1b
> Jun 21 11:19:03 brouette kernel: Code: 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> Jun 21 11:19:03 brouette kernel: RIP  [<ffffffff8171a1f8>]
> elv_register+0x0/0x197
> Jun 21 11:19:03 brouette kernel: RSP <ffff8801b4227d60>
> Jun 21 11:19:03 brouette kernel: CR2: ffffffff8171a1f8
> Jun 21 11:19:03 brouette kernel: ---[ end trace 5bbf40f5ac5f66e3 ]---
> Jun 21 11:19:03 brouette kernel: elevator: type deadline not found
> Jun 21 11:19:03 brouette kernel: elevator: switch to deadline
> 
> My startup scripts do this:
> 
>     echo "noop" > /sys/block/sda/queue/scheduler
>     echo "deadline" > /sys/block/sdb/queue/scheduler
>     echo "noop" > /sys/block/sdc/queue/scheduler
>     echo "deadline" > /sys/block/sdd/queue/scheduler
> 
> And the relevant part of my .config:
> 
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=m
> CONFIG_IOSCHED_CFQ=y
> CONFIG_CFQ_GROUP_IOSCHED=y
> CONFIG_DEFAULT_IOSCHED="cfq"
> 
> 
> Maybe related to b5097e956a ?
> 
> No problem with 3.15.

It seems you're right. I didn't know that parameter could be updated dynamically.
In that case, adding __init to elv_register was a bad idea because it's no more
reliable. Could you revert that patch Jens ?
 
Thanks,
Fabian


> 
> Thanks,
> --
> Damien Wyart
