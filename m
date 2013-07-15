Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3GOCjE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 22:39:04 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:52654 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3GOCjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 22:39:02 -0400
Message-ID: <51E360C1.10204@openvz.org>
Date: Mon, 15 Jul 2013 06:38:57 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [3.10.1 MEI_ME] strange kernel crash
References: <51E2FE1C.207@openvz.org>
In-Reply-To: <51E2FE1C.207@openvz.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has happened again. This time without warnings and without suspend-resume.
Seems like 'mei_me' corrupts kernel memory.

My setup is simple: it's thinkpad x220 which receives flow of wake-on-lan packets via the ethernet.

[ 6596.895370] mei_me 0000:00:16.0: version message writet failed
[ 6596.895373] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[ 6596.895376] mei_me 0000:00:16.0: version message writet failed
[ 6596.895378] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[ 6596.895381] mei_me 0000:00:16.0: version message writet failed
[ 6596.895383] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[ 6596.895386] mei_me 0000:00:16.0: version message writet failed
[ 6596.895388] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[ 6596.895391] mei_me 0000:00:16.0: version message writet failed
[ 6596.895394] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[ 6596.895397] mei_me 0000:00:16.0: version message writet failed
[ 6596.895399] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[ 6596.895402] general protection fault: 0000 [#1] SMP
[ 6596.895423] Modules linked in: iwldvm iwlwifi nfsd auth_rpcgss oid_registry nfs_acl nfs lockd sunrpc bridge stp llc 
tun fuse snd_hda_codec_hdmi snd_hda_codec_conexant iTCO_wdt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc 
intel_powerclamp coretemp snd_seq_midi snd_seq_midi_event kvm_intel kvm snd_rawmidi cdc_ncm usbnet mii uvcvideo cdc_acm 
cdc_wdm snd_seq videobuf2_vmalloc snd_seq_device snd_timer videobuf2_memops videobuf2_core videodev lpc_ich mfd_core 
thinkpad_acpi snd wmi i915 soundcore drm_kms_helper hid_logitech_dj sdhci_pci sdhci e1000e ptp
[ 6596.895425] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.10.1-zurg-00001-gaa457b5 #107
[ 6596.895426] Hardware name: LENOVO 4291QY6/4291QY6, BIOS 8DET51WW (1.21 ) 08/02/2011
[ 6596.895427] task: ffff88040c0bc560 ti: ffff88040c12e000 task.ti: ffff88040c12e000
[ 6596.895433] RIP: 0010:[<ffffffff8107a471>]  [<ffffffff8107a471>] load_cr3+0x21/0x30
[ 6596.895434] RSP: 0018:ffff88040c12fe78  EFLAGS: 00010002
[ 6596.895435] RAX: 000077ff80000000 RBX: ffff88040abf1380 RCX: 0000000000000002
[ 6596.895436] RDX: 0000000080000000 RSI: ffff88040595be70 RDI: 0000780000000001
[ 6596.895436] RBP: ffff88040c12fe78 R08: 0000000000000000 R09: 0000000000000001
[ 6596.895437] R10: 0000000000000001 R11: 7fffffffffffffff R12: ffff88041e292dc0
[ 6596.895438] R13: ffff88040abf1380 R14: 0000000000000000 R15: ffff88040595be70
[ 6596.895440] FS:  0000000000000000(0000) GS:ffff88041e280000(0000) knlGS:0000000000000000
[ 6596.895440] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6596.895441] CR2: 00007f3ec00571e8 CR3: 0000000408848000 CR4: 00000000000407e0
[ 6596.895442] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6596.895443] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6596.895443] Stack:
[ 6596.895445]  ffff88040c12fed8 ffffffff81626aa4 ffff88040c12ffd8 0000000000012dc0
[ 6596.895446]  ffff88040c12ffd8 0000000000012dc0 ffff88040c0bc560 ffff88040c12ffd8
[ 6596.895447]  ffff88040c12ffd8 ffff88040c12ffd8 ffff88040c12ffd8 ffff88040c12ffd8
[ 6596.895448] Call Trace:
[ 6596.895454]  [<ffffffff81626aa4>] __schedule+0x784/0x7c0
[ 6596.895456]  [<ffffffff816278d9>] schedule_preempt_disabled+0x29/0x70
[ 6596.895459]  [<ffffffff8108ec45>] cpu_startup_entry+0x1f5/0x230
[ 6596.895461]  [<ffffffff81096588>] ? clockevents_config_and_register+0x28/0x30
[ 6596.895464]  [<ffffffff81617ce0>] start_secondary+0x209/0x20b
[ 6596.895479] Code: e8 05 b1 5a 00 5b 41 5c 5d c3 ba 00 00 00 80 48 b8 00 00 00 80 ff 77 00 00 55 48 01 d7 48 0f 42 05 
a5 6b b9 00 48 89 e5 48 01 c7 <0f> 22 df 66 66 66 90 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 48
[ 6596.895481] RIP  [<ffffffff8107a471>] load_cr3+0x21/0x30
[ 6596.895481]  RSP <ffff88040c12fe78>


Konstantin Khlebnikov wrote:
> first and only warning had happened here:
>
> Jul 14 22:49:33 zurg kernel: [ 6169.400920] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
> Jul 14 22:50:03 zurg kernel: [ 6199.422111] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
> Jul 14 22:50:33 zurg kernel: [ 6229.443292] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
> Jul 14 22:51:03 zurg kernel: [ 6259.464476] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
> Jul 14 22:51:33 zurg kernel: [ 6289.485675] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
> Jul 14 22:52:03 zurg kernel: [ 6319.506868] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
>
> soon after that kernel had crashed
>
> [ 6349.664704] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
> [ 6349.664709] mei_me 0000:00:16.0: version message writet failed
> [ 6349.664711] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
> [ 6349.664714] mei_me 0000:00:16.0: version message writet failed
> [ 6349.664716] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
> [ 6349.664719] mei_me 0000:00:16.0: version message writet failed
> [ 6349.988121] kernel tried to execute NX-protected page - exploit attempt? (uid: 1000)
> [ 6349.988162] BUG: unable to handle kernel paging request at ffff88040b242000
> [ 6349.988199] IP: [<ffff88040b242000>] 0xffff88040b241fff
> [ 6349.988227] PGD 1ed4067 PUD 1ed7067 PMD 800000040b2001e3
> [ 6349.988257] Oops: 0011 [#1] SMP
> [ 6349.988276] Modules linked in: iwldvm iwlwifi nfsd auth_rpcgss oid_registry nfs_acl nfs lockd sunrpc bridge stp llc
> tun fuse snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc
> thinkpad_acpi snd_seq_midi snd_seq_midi_event iTCO_wdt snd_rawmidi intel_powerclamp coretemp hid_logitech_dj cdc_ncm
> uvcvideo kvm_intel kvm usbnet videobuf2_vmalloc videobuf2_memops mii videobuf2_core videodev cdc_wdm cdc_acm snd_seq
> snd_seq_device snd_timer i915 snd soundcore lpc_ich mfd_core wmi drm_kms_helper sdhci_pci sdhci e1000e ptp
> [ 6349.988581] CPU: 3 PID: 5297 Comm: xfce4-panel Tainted: G W 3.10.1-zurg-00001-gaa457b5 #107
> [ 6349.988622] Hardware name: LENOVO 4291QY6/4291QY6, BIOS 8DET51WW (1.21 ) 08/02/2011
> [ 6349.988658] task: ffff88040a623e70 ti: ffff880409aec000 task.ti: ffff880409aec000
> [ 6349.988691] RIP: 0010:[<ffff88040b242000>] [<ffff88040b242000>] 0xffff88040b241fff
> [ 6349.988728] RSP: 0018:ffff880409aedb98 EFLAGS: 00010006
> [ 6349.988752] RAX: ffff8803f554b120 RBX: 00000000f554b138 RCX: 00000000000000c3
> [ 6349.988785] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8803f554b120
> [ 6349.988816] RBP: ffff880409aedbd8 R08: 00000000000000c3 R09: 001300360002051e
> [ 6349.988849] R10: 010043e70007033e R11: 0100003201000004 R12: ffff88040a84c8c8
> [ 6349.988880] R13: ffff8803f554b148 R14: 0000000000000001 R15: 0000000000000001
> [ 6349.988913] FS: 00007f3779c239c0(0000) GS:ffff88041e2c0000(0000) knlGS:0000000000000000
> [ 6349.988949] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 6349.988975] CR2: ffff88040b242000 CR3: 000000040a390000 CR4: 00000000000407e0
> [ 6349.989008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 6349.989040] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 6349.989071] Stack:
> [ 6349.989082] ffffffff8107a7a8 0000000100000000 00000000000000c3 ffff88040a84c8c0
> [ 6349.989121] 0000000000000001 0000000000000001 00000000000000c3 0000000000000286
> [ 6349.989159] ffff880409aedc10 ffffffff8107b994 ffff880405458340 00000000000000e4
> [ 6349.989198] Call Trace:
> [ 6349.989215] [<ffffffff8107a7a8>] ? __wake_up_common+0x58/0x90
> [ 6349.989244] [<ffffffff8107b994>] __wake_up_sync_key+0x44/0x60
> [ 6349.989272] [<ffffffff8147b0da>] sock_def_readable+0x3a/0x70
> [ 6349.989300] [<ffffffff8153c6a8>] unix_stream_sendmsg+0x1f8/0x3f0
> [ 6349.989330] [<ffffffff81477a53>] sock_aio_write+0xe3/0x100
> [ 6349.989357] [<ffffffff811300dc>] do_sync_readv_writev+0x6c/0xa0
> [ 6349.989386] [<ffffffff8113138b>] do_readv_writev+0xbb/0x240
> [ 6349.989414] [<ffffffff8147865d>] ? SYSC_recvfrom+0x10d/0x140
> [ 6349.989441] [<ffffffff8113574f>] ? SYSC_newstat+0x2f/0x40
> [ 6349.989468] [<ffffffff811315a5>] vfs_writev+0x35/0x60
> [ 6349.989493] [<ffffffff811316b9>] SyS_writev+0x49/0xa0
> [ 6349.989518] [<ffffffff811439e5>] ? SyS_poll+0x65/0x100
> [ 6349.989545] [<ffffffff81630919>] system_call_fastpath+0x16/0x1b
> [ 6349.989572] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00 <00> 40 97 0b 04 88 ff ff 08 20 24 0b 04 88 ff ff 08 20 24 0b 04
> [ 6349.989748] RIP [<ffff88040b242000>] 0xffff88040b241fff
> [ 6349.989775] RSP <ffff880409aedb98>
> [ 6349.989792] CR2: ffff88040b242000
>
> There was only one mine patch for intel gpu (https://bugs.freedesktop.org/show_bug.cgi?id=54089)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/

