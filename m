Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbaJCXMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:12:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46008 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390AbaJCXLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:11:14 -0400
Date: Sat, 4 Oct 2014 01:11:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: dtor@mail.ru, linux-input@vger.kernel.org
Subject: 3.17-rc5: kernel oops when exiting X under heavy load
Message-ID: <20141003231109.GA4530@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>From the backtrace, it looks evdev related...?


Oct  4 00:59:47 duo wpa_supplicant[3824]: wlan0: SME: Trying to authenticate with 00:11:95:05:30:d7 (SSID='pavel' freq=2412 MHz)
Oct  4 00:59:47 duo wpa_supplicant[3824]: wlan0: Trying to associate with 00:11:95:05:30:d7 (SSID='pavel' freq=2412 MHz)
Oct  4 00:59:47 duo NetworkManager[3465]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Oct  4 00:59:47 duo wpa_supplicant[3824]: wlan0: Associated with 00:11:95:05:30:d7
Oct  4 00:59:47 duo wpa_supplicant[3824]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:11:95:05:30:d7 completed (reauth) [id=0 id_str=]
Oct  4 00:59:47 duo NetworkManager[3465]: <info> (wlan0): supplicant interface state: authenticating -> associating
Oct  4 00:59:47 duo NetworkManager[3465]: <info> (wlan0): supplicant interface state: associating -> completed
Oct  4 00:59:55 duo kernel: BUG: unable to handle kernel paging request at f47b5000
Oct  4 00:59:55 duo kernel: IP: [<c42765ff>] memcpy+0xf/0x20
Oct  4 00:59:55 duo kernel: *pde = 373f3067 *pte = 347b5060 
Oct  4 00:59:55 duo kernel: Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Oct  4 00:59:55 duo kernel: Modules linked in:
Oct  4 00:59:55 duo kernel: CPU: 0 PID: 22293 Comm: Xorg Not tainted 3.17.0-rc5+ #399
Oct  4 00:59:55 duo kernel: Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 ) 03/31/2011
Oct  4 00:59:55 duo kernel: task: eb4b1580 ti: ec6a2000 task.ti: ec6a2000
Oct  4 00:59:55 duo kernel: EIP: 0060:[<c42765ff>] EFLAGS: 00213006 CPU: 0
Oct  4 00:59:55 duo kernel: EIP is at memcpy+0xf/0x20
Oct  4 00:59:55 duo kernel: EAX: f5c42000 EBX: 00000bfc ECX: 00000146 EDX: f47b491c
Oct  4 00:59:55 duo kernel: ESI: f47b5000 EDI: f5c426e4 EBP: ec6a3e80 ESP: ec6a3e74
Oct  4 00:59:55 duo kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Oct  4 00:59:55 duo kernel: CR0: 80050033 CR2: f47b5000 CR3: 2c77d000 CR4: 00000710
Oct  4 00:59:55 duo kernel: Stack:
Oct  4 00:59:55 duo kernel: ec409800 f47b499c 00000bfc ec6a3ec4 c451f154 ec40980c f5c42000 c47ee121
Oct  4 00:59:55 duo kernel: 00000001 00000001 00000000 00203246 c47ef168 c451f367 f47cdcb4 eb4b1580
Oct  4 00:59:55 duo kernel: 00203246 eab3eec0 ec409800 ec409800 ec6a3f2c c451f468 f47b491c 000002ff
Oct  4 00:59:55 duo kernel: Call Trace:
Oct  4 00:59:55 duo kernel: [<c451f154>] evdev_handle_get_val.isra.7+0x54/0x240
Oct  4 00:59:55 duo kernel: [<c47ee121>] ? mutex_lock_interruptible_nested+0x31/0x330
Oct  4 00:59:55 duo kernel: [<c47ef168>] ? mutex_unlock+0x8/0x10
Oct  4 00:59:55 duo kernel: [<c451f367>] ? evdev_ioctl+0x27/0x7f0
Oct  4 00:59:55 duo kernel: [<c451f468>] evdev_ioctl+0x128/0x7f0
Oct  4 00:59:55 duo kernel: [<c40e9c5c>] ? cache_free_debugcheck+0x2ac/0x340
Oct  4 00:59:55 duo kernel: [<c451f340>] ? evdev_handle_get_val.isra.7+0x240/0x240
Oct  4 00:59:55 duo kernel: [<c40fead2>] do_vfs_ioctl+0x2f2/0x520
Oct  4 00:59:55 duo kernel: [<c40f8178>] ? final_putname+0x18/0x40
Oct  4 00:59:55 duo kernel: [<c40f8178>] ? final_putname+0x18/0x40
Oct  4 00:59:55 duo kernel: [<c40ee12a>] ? do_sys_open+0x17a/0x200
Oct  4 00:59:55 duo kernel: [<c40fed36>] SyS_ioctl+0x36/0x70
Oct  4 00:59:55 duo kernel: [<c47f105e>] syscall_call+0x7/0x7
Oct  4 00:59:55 duo kernel: [<c47f0000>] ? hrtimer_nanosleep_restart+0x60/0xa0
Oct  4 00:59:55 duo kernel: Code: fb ff ff 8b 43 54 2b 43 50 88 43 4e 5b 5d f3 c3 90 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 57 89 c7 56 89 d6 53 89 cb c1 e9 02 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 5b 5e 5f 5d c3 90 55 89 e5 57
Oct  4 00:59:55 duo kernel: EIP: [<c42765ff>] memcpy+0xf/0x20 SS:ESP 0068:ec6a3e74
Oct  4 00:59:55 duo kernel: CR2: 00000000f47b5000
Oct  4 00:59:55 duo kernel: ---[ end trace fee349319591dc44 ]---
Oct  4 01:04:08 duo rsyslogd: [origin software="rsyslogd" swVersion="8.4.0" x-pid="3490" x-info="http://www.rsyslog.com"] start

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
