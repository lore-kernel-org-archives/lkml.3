Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3BLVi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:38:26 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46114 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3BLViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:38:23 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 12 Feb 2013 22:38:21 +0100
Message-ID: <CA+icZUUcCMVutJ6N5xi-YWA2xGcmaf8X6Mv1wHWOQpxkrco8cg@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 12 [ WARNING: at drivers/tty/tty_buffer.c:427
 flush_to_ldisc | tty is NULL ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 6:09 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130211:
>
> The acpi tree lost its build failure.
>
> The net-next tree gained a conflict against the net tree.
>
> The arm-soc tree gained conflicts against the usb and metag trees.
>
> ----------------------------------------------------------------------------
>

[ CCing linux-serial and linux-pm folks ]

When starting suspend (seen once, 2nd suspend was OK)...

[  706.950122] PM: Syncing filesystems ... done.
[  706.953773] PM: Preparing system for mem sleep
[  726.174449] ------------[ cut here ]------------
[  726.174469] WARNING: at drivers/tty/tty_buffer.c:427
flush_to_ldisc+0x1ac/0x1c0()
[  726.174473] Hardware name: 530U3BI/530U4BI/530U4BH
[  726.174476] tty is NULL
[  707.034695] Freezing user space processes ...
[  726.174479] Modules linked in: btrfs zlib_deflate xfs libcrc32c
bnep rfcomm parport_pc ppdev snd_hda_codec_hdmi snd_hda_codec_realtek
coretemp kvm_intel arc4 kvm iwldvm mac80211 snd_hda_intel
ghash_clmulni_intel aesni_intel snd_hda_codec xts uvcvideo aes_x86_64
snd_hwdep snd_pcm lrw gf128mul videobuf2_vmalloc ablk_helper
snd_page_alloc joydev videobuf2_memops i915 cryptd snd_seq_midi
videobuf2_core snd_seq_midi_event videodev iwlwifi snd_rawmidi snd_seq
snd_timer snd_seq_device i2c_algo_bit drm_kms_helper cfg80211 btusb
snd psmouse drm soundcore microcode bluetooth samsung_laptop serio_raw
wmi lpc_ich mei mac_hid video lp parport hid_generic usbhid hid r8169
[  726.174529] Pid: 2507, comm: kworker/0:0 Not tainted
3.8.0-rc7-next20130212-3-iniza-small #1
[  726.174530] Call Trace:
[  726.174535]  [<ffffffff8105a5ef>] warn_slowpath_common+0x7f/0xc0
[  726.174538]  [<ffffffff8105a6e6>] warn_slowpath_fmt+0x46/0x50
[  726.174541]  [<ffffffff8142415c>] flush_to_ldisc+0x1ac/0x1c0
[  726.174544]  [<ffffffff8107993b>] process_one_work+0x16b/0x400
[  726.174547]  [<ffffffff8107a5b8>] worker_thread+0x118/0x360
[  726.174549]  [<ffffffff8107a4a0>] ? manage_workers+0x350/0x350
[  726.174552]  [<ffffffff8107fab0>] kthread+0xc0/0xd0
[  726.174554]  [<ffffffff8107f9f0>] ? flush_kthread_worker+0xb0/0xb0
[  726.174557]  [<ffffffff816cabac>] ret_from_fork+0x7c/0xb0
[  726.174559]  [<ffffffff8107f9f0>] ? flush_kthread_worker+0xb0/0xb0
[  726.174560] ---[ end trace bf493695d326ce7b ]---
[  726.379024] ------------[ cut here ]------------

 - Sedat -
