Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3BZV5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:57:01 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:53868 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3BZV5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:57:00 -0500
MIME-Version: 1.0
In-Reply-To: <512D284B.8070802@lwfinger.net>
References: <512D284B.8070802@lwfinger.net>
Date: Tue, 26 Feb 2013 22:56:58 +0100
Message-ID: <CACTFLAO0y-XOwBYJBnOjGJ6rzE2CZjKRnMx4+FpPScCeJkZnUw@mail.gmail.com>
Subject: Re: WARNING from tty driver in 3.9-rc0
From: Daniel Mack <zonque@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:25 PM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> Hi,
>
> With v3.8-8693-gbf722a0 from the mainline repo, I get the following warning
> because the pointer for tty is NULL:
>
> [   34.956862] WARNING: at drivers/tty/tty_buffer.c:428
> flush_to_ldisc+0x1bb/0x1c0()
> [   34.956865] Hardware name: HP Pavilion dv2700 Notebook PC
> [   34.956867] tty is NULL
> [   34.956869] Modules linked in: arc4 b43 mac80211 cfg80211
> snd_hda_codec_conexant snd_hda_intel rfkill snd_hda_codec ipv6 snd_pcm
> kvm_amd snd_seq kvm bcma rng_core snd_timer snd_seq_device ssb mmc_core snd
> pcmcia sr_mod cdrom sg soundcore forcedeth pcmcia_core snd_page_alloc
> i2c_nforce2 i2c_core k8temp hwmon ehci_pci battery ac serio_raw joydev video
> wmi button autofs4 ext4 mbcache jbd2 crc16 ohci_hcd ehci_hcd usbcore
> usb_common thermal processor scsi_dh_alua scsi_dh_hp_sw scsi_dh_rdac
> scsi_dh_emc scsi_dh ata_generic pata_acpi pata_amd
> [   34.956936] Pid: 270, comm: kworker/1:1 Not tainted 3.8.0+ #92
> [   34.956939] Call Trace:
> [   34.956944]  [<ffffffff812acc00>] ? flush_to_ldisc+0x120/0x1c0
> [   34.956951]  [<ffffffff81040a4a>] warn_slowpath_common+0x7a/0xc0
> [   34.956955]  [<ffffffff81040b31>] warn_slowpath_fmt+0x41/0x50
> [   34.956959]  [<ffffffff812acc9b>] flush_to_ldisc+0x1bb/0x1c0
> [   34.956964]  [<ffffffff810640f1>] process_one_work+0x1f1/0x660
> [   34.956968]  [<ffffffff81064085>] ? process_one_work+0x185/0x660
> [   34.956972]  [<ffffffff81064900>] worker_thread+0x110/0x380
> [   34.956978]  [<ffffffff810a5b7d>] ? trace_hardirqs_on+0xd/0x10
> [   34.956982]  [<ffffffff810647f0>] ? rescuer_thread+0x250/0x250
> [   34.956987]  [<ffffffff81069e96>] kthread+0xd6/0xe0
> [   34.956992]  [<ffffffff81424c9b>] ? _raw_spin_unlock_irq+0x2b/0x50
> [   34.956997]  [<ffffffff81069dc0>] ? __init_kthread_worker+0x70/0x70
> [   34.957002]  [<ffffffff81425a7c>] ret_from_fork+0x7c/0xb0
> [   34.957006]  [<ffffffff81069dc0>] ? __init_kthread_worker+0x70/0x70
> [   34.957009] ---[ end trace f467d4f2302660c1 ]---
> [   35.585060] forcedeth 0000:00:0a.0: irq 42 for MSI/MSI-X
> [   35.585182] forcedeth 0000:00:0a.0 eth0: MSI enabled
> [   36.140711] ------------[ cut here ]------------
>
>
> I have not yet bisected this problem yet; however, I can if requested. Being
> lazy, I hope that someone already has a patch, or can see the problem by
> inspection. :)

FWIW, I see the same on an ARM embedded board ...


Daniel
