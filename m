Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3HaKOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 06:14:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40113 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3HaKOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 06:14:52 -0400
Date: Sat, 31 Aug 2013 12:14:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.11-rc2: unpriviledged user crashes kernel using bluetooth
Message-ID: <20130831101451.GC7029@amd.pavel.ucw.cz>
References: <20130831100127.GA6711@amd.pavel.ucw.cz>
 <20130831100933.GA7029@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831100933.GA7029@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-08-31 12:09:33, Pavel Machek wrote:
> Hi!
> 
> > . Python sources for client/server are at 
> > 
> > http://tui.cvs.sourceforge.net/viewvc/tui/tui/liveview/
> > 
> > . My kernels like to warn about
> System is debian stable with gnome2.

And no, it is not fixed in 3.11-rc7.

								Pavel

pavel@duo:~$ uname -a
Linux duo 3.11.0-rc7+ #309 SMP Sat Aug 31 11:49:01 CEST 2013 i686
GNU/Linux
pavel@duo:~$ sudo cat /proc/kmsg 
[sudo] password for pavel: 
<4> [<c04f4c6c>] ? tty_buffer_flush+0x1c/0xd0
<4> [<c0463593>] ? debug_check_no_obj_freed+0xe3/0x190
<4> [<c02ee478>] ? final_putname+0x18/0x40
<4> [<c02ee478>] ? final_putname+0x18/0x40
<4> [<c02df45c>] ? do_sys_open+0x19c/0x220
<4> [<c02f0775>] SyS_ioctl+0x45/0x70
<4> [<c0986638>] sysenter_do_call+0x12/0x31
<0>Code: 24 04 fb 0b 00 00 c7 04 24 65 76 b5 c0 e8 57 f3 fa ff 31 c0
eb ad 8d 76 00 8b 44 9e 04 85 c0 89 45 f0 0f 84 b2 fe ff ff 8b 4d f0
<f0> ff 81 04 01 00 00 8b 0d 64 8e d5 c0 8b 9f 3c 04 00 00 85 c9
<4>CR2: 00000000c02e0e52
<4> 00000a67 c0b533ab 0000009f c0238d28 c0238d28 f2ec6e38 f2ec6f6c
f2ec6d10
<4> f549fb5c c0234ecd 00000009 00000000 f549fb64 c0238d28 f549fb70
c09857c5
<4> [<c0234e8a>] warn_slowpath_common+0x7a/0xa0
<4> [<c0238d28>] ? local_bh_enable_ip+0x58/0x80
<4> [<c09857c5>] _raw_write_unlock_bh+0x25/0x30
<4> [<c08c8643>] unix_release_sock+0x73/0x230
<4> [<c02daf4e>] ? kfree_debugcheck+0xe/0x30
<4> [<c08c8814>] unix_release+0x14/0x20
<4> [<c081dd4b>] sock_release+0x1b/0x80
<4> [<c081e0ab>] sock_close+0xb/0x10
<4> [<c02e2688>] __fput+0x88/0x1f0
<4> [<c02e2888>] ____fput+0x8/0x10
<4> [<c024d0d1>] task_work_run+0x81/0xb0
<4> [<c0236e8e>] do_exit+0x22e/0x860
<4> [<c0204c7b>] oops_end+0x8b/0xd0
<4> [<c09863da>] error_code+0x5a/0x60
<4> [<c02e0d4e>] ? do_sync_read+0x6e/0xa0
<4> [<c02e0d4e>] ? do_sync_read+0x6e/0xa0
<4> [<c022d810>] ? __do_page_fault+0x400/0x400
<4> [<c0285bc2>] ? __lock_acquire+0x192/0xcf0
<4> [<c02fbb39>] ? mntput_no_expire+0x19/0xf0
<4> [<c02e0d4e>] ? do_sync_read+0x6e/0xa0
<4> [<c04f4c6c>] ? tty_buffer_flush+0x1c/0xd0
<4> [<c04f4c6c>] tty_buffer_flush+0x1c/0xd0
<4> [<c04ee5cf>] tty_ioctl+0x5bf/0xa80
<4> [<c0285db6>] ? __lock_acquire+0x386/0xcf0
<4> [<c022ea21>] ? kernel_map_pages+0x71/0xf0
<4> [<c04ee010>] ? tty_check_change+0xe0/0xe0
<4> [<c02f0209>] do_vfs_ioctl+0x89/0x5b0
<4> [<c0463593>] ? debug_check_no_obj_freed+0xe3/0x190
<4> [<c02ee478>] ? final_putname+0x18/0x40
<4> [<c02f0775>] SyS_ioctl+0x45/0x70
<4>---[ end trace f66d593cc2b02657 ]---
Message from syslogd@duo at Aug 31 12:13:17 ...
 kernel:CPU: 0 PID: 2663 Comm: modem-manager Tainted: G        W
 3.11.0-rc7+ #309

Message from syslogd@duo at Aug 31 12:13:17 ...
 kernel:Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )
 03/31/2011

Message from syslogd@duo at Aug 31 12:13:17 ...
 kernel:task: f5f16670 ti: f549e000 task.ti: f549e000

Message from syslogd@duo at Aug 31 12:13:17 ...
 kernel:Stack:

Message from syslogd@duo at Aug 31 12:13:17 ...
 kernel:Call Trace:

Message from syslogd@duo at Aug 31 12:13:17 ...
 kernel:EIP: [<c0285bc2>] __lock_acquire+0x192/0xcf0 SS:ESP
 0068:f549fdb8
<1>BUG: unable to handle kernel paging request at eb823c24
<1>IP: [<c0462691>] do_raw_spin_lock+0x11/0x140
<4>*pde = 3733f067 *pte = 2b823060 
<4>Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
<4>Modules linked in:
<0>CPU: 1 PID: 3804 Comm: modem-manager Tainted: G      D W
 3.11.0-rc7+ #309
<0>Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )
 03/31/2011
<0>task: eae37670 ti: eba0a000 task.ti: eba0a000
<4>EIP: 0060:[<c0462691>] EFLAGS: 00010086 CPU: 1
<4>EIP is at do_raw_spin_lock+0x11/0x140
<4>EAX: eb823c20 EBX: eb823c20 ECX: 00000000 EDX: 00000000
<4>ESI: 00000286 EDI: eb823c20 EBP: eba0be1c ESP: eba0be0c
<4> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
<4>CR0: 80050033 CR2: eb823c24 CR3: 2acb4000 CR4: 00000710
<0>Stack:
<4> 00000000 eb823c20 00000286 eb823c20 eba0be3c c09856c2 00000000
 00000001
<4> 00000000 c04f4c6c eba09f00 eb823c00 eba0be6c c04f4c6c 0000023b
 ebf1ac00
<4> 00000f44 00000c4b 00000000 000001c5 0003463b eba09f00 ebf1ac00
 00000017
<0>Call Trace:
<4> [<c09856c2>] _raw_spin_lock_irqsave+0x42/0x50
<4> [<c04f4c6c>] ? tty_buffer_flush+0x1c/0xd0
<4> [<c04f4c6c>] tty_buffer_flush+0x1c/0xd0
<4> [<c04ee5cf>] tty_ioctl+0x5bf/0xa80
<4> [<c022ea21>] ? kernel_map_pages+0x71/0xf0
<4> [<c04ee010>] ? tty_check_change+0xe0/0xe0
<4> [<c02f0209>] do_vfs_ioctl+0x89/0x5b0
<4> [<c0463593>] ? debug_check_no_obj_freed+0xe3/0x190
<4> [<c02f90a0>] ? __fd_install+0x20/0x50
<4> [<c02ee478>] ? final_putname+0x18/0x40
<4> [<c02ee478>] ? final_putname+0x18/0x40
<4> [<c02df45c>] ? do_sys_open+0x19c/0x220
<4> [<c02f0775>] SyS_ioctl+0x45/0x70
<4> [<c0986638>] sysenter_do_call+0x12/0x31
<0>Code: 66 ff ff ff eb b9 ba 39 b7 b7 c0 89 d8 e8 58 ff ff ff eb a0
 8d b6 00 00 00 00 55 89 e5 83 ec 10 89 5d f4 89 c3 89 75 f8 89 7d fc
 <81> 78 04 ad 4e ad de 0f 85 11 01 00 00 64 a1 4c 87 d3 c0 39 43
<0>EIP: [<c0462691>] do_raw_spin_lock+0x11/0x140 SS:ESP 0068:eba0be0c
<4>CR2: 00000000eb823c24
<4>---[ end trace f66d593cc2b02658 ]---



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
