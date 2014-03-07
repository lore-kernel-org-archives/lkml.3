Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaCGF7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:59:32 -0500
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:34239 "EHLO
	homiemail-a11.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751624AbaCGF73 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:59:29 -0500
Message-ID: <ae44b9207a254e15b8d5a2d6cad1842b.squirrel@webmail.novalis.org>
In-Reply-To: <d31202acbd0097307fb52d8239466308.squirrel@webmail.novalis.org>
References: <daed65ee080e4cc417c87f34af8447f2.squirrel@webmail.novalis.org>
    <d31202acbd0097307fb52d8239466308.squirrel@webmail.novalis.org>
Date: Fri, 7 Mar 2014 00:59:29 -0500
Subject: Re: PROBLEM: Inotify leaks file descriptors.
From: "David Turner" <novalis@novalis.org>
To: "David Turner" <novalis@novalis.org>
Cc: "David Turner" <novalis@novalis.org>,
        "John McCutchan" <john@johnmccutchan.com>,
        "Robert Love" <rlove@rlove.org>, "Eric Paris" <eparis@parisplace.org>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was running code related to the python script -- multiple threads doing
inotify things in parallel, using watchman, and I got the following Oops:

[152513.914195] watchman[4963]: segfault at 7ff04ddb09d0 ip
00007ff05b831f60 sp 00007ff04c5acce8 error 4 in
libpthread-2.15.so[7ff05b825000+18000]
[152516.577861] watchman[6138]: segfault at 7f1962e099d0 ip
00007f1970489f60 sp 00007f1962406ce8 error 4 in
libpthread-2.15.so[7f197047d000+18000]
[153010.703990] BUG: unable to handle kernel NULL pointer dereference at  
        (null)
[153010.704036] IP: [<          (null)>]           (null)
[153010.704060] PGD 1b1b4e067 PUD 1cc1f1067 PMD 0
[153010.704084] Oops: 0010 [#1] SMP
[153010.704103] Modules linked in: btrfs raid6_pq zlib_deflate xor ufs
qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs usb_storage cdc_acm
joydev pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) bnep
rfcomm bluetooth parport_pc ppdev uvcvideo videobuf2_core binfmt_misc
videodev snd_hda_codec_hdmi snd_hda_codec_conexant videobuf2_vmalloc
videobuf2_memops snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_seq_midi arc4 snd_rawmidi iwldvm mac80211 snd_seq_midi_event snd_seq
psmouse thinkpad_acpi snd_timer snd_seq_device iwlwifi nvram serio_raw snd
tpm_tis cfg80211 soundcore snd_page_alloc mac_hid mei_me mei lpc_ich lp
ext2 parport dm_crypt i915 drm_kms_helper e1000e wmi drm ptp pps_core ahci
libahci sdhci_pci sdhci i2c_algo_bit video
[153010.704453] CPU: 1 PID: 3586 Comm: watchman Tainted: GF       W  O
3.11.0-17-generic #31~precise1-Ubuntu
[153010.704493] Hardware name: LENOVO 4177Q5U/4177Q5U, BIOS 83ET76WW (1.46
) 07/05/2013
[153010.704529] task: ffff8801b6ae0000 ti: ffff88009ed30000 task.ti:
ffff88009ed30000
[153010.704564] RIP: 0010:[<0000000000000000>]  [<          (null)>]      
    (null)
[153010.704600] RSP: 0018:ffff88009ed31dc0  EFLAGS: 00010246
[153010.704624] RAX: 00000000b98ab901 RBX: ffff88015a9b5228 RCX:
00000000000188d0
[153010.704655] RDX: 000000000000b98a RSI: ffff880100b95c00 RDI:
ffff88015a9b5228
[153010.704686] RBP: ffff88009ed31dd8 R08: 0000000000000001 R09:
ffffea0000d85640
[153010.704718] R10: ffffffff811f9628 R11: 0000000000000000 R12:
ffff88015a9b5228
[153010.704750] R13: ffff880100b95ca0 R14: 00000000ffffffff R15:
ffff880100b95c00
[153010.704783] FS:  00007f5b19087700(0000) GS:ffff88021e240000(0000)
knlGS:0000000000000000
[153010.704819] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[153010.704846] CR2: 0000000000000000 CR3: 00000001dd9d1000 CR4:
00000000000427e0
[153010.704877] Stack:
[153010.704888]  ffffffff811f7120 ffff88015a9b5228 ffff8801e460c7f0
ffff88009ed31e28
[153010.704926]  ffffffff811f7847 ffff88009ed31e18 ffff880100b95c70
ffff88009ed31f50
[153010.704965]  ffff880100b95c00 0000000000000010 ffff8802120433c0
ffff8802120433c0
[153010.705005] Call Trace:
[153010.705024]  [<ffffffff811f7120>] ? fsnotify_put_mark+0x30/0x40
[153010.705054]  [<ffffffff811f7847>]
fsnotify_clear_marks_by_group_flags+0x87/0xb0
[153010.705088]  [<ffffffff811f7883>] fsnotify_clear_marks_by_group+0x13/0x20
[153010.705119]  [<ffffffff811f68d6>] fsnotify_destroy_group+0x16/0x40
[153010.705150]  [<ffffffff811f8be6>] inotify_release+0x26/0x50
[153010.705177]  [<ffffffff811b640a>] __fput+0xba/0x240
[153010.705201]  [<ffffffff811b65de>] ____fput+0xe/0x10
[153010.705226]  [<ffffffff810859d8>] task_work_run+0xc8/0xf0
[153010.706464]  [<ffffffff81013dfc>] do_notify_resume+0xac/0xc0
[153010.707730]  [<ffffffff8175159a>] int_signal+0x12/0x17
[153010.708933] Code:  Bad RIP value.
[153010.710089] RIP  [<          (null)>]           (null)
[153010.711251]  RSP <ffff88009ed31dc0>
[153010.712319] CR2: 0000000000000000
[153010.718669] ---[ end trace 17ed2927fe522cd1 ]---


