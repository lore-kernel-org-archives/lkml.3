Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3LLT1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:27:54 -0500
Received: from fep25.mx.upcmail.net ([62.179.121.45]:41199 "EHLO
	fep25.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3LLT1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:27:51 -0500
X-Greylist: delayed 1008 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Dec 2013 14:27:50 EST
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <52AA0A42.1060008@odi.ch>
Date: Thu, 12 Dec 2013 20:10:58 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 3.12.3: Oops while hitting keyboard
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My little son triggered the following Oops by hitting the Bluetooth keyboard 
like a little monkey:

Linux gandalf 3.12.3 #2 SMP PREEMPT Wed Dec 4 23:04:27 CET 2013 x86_64 Intel(R) 
Core(TM) i3 CPU 540 @ 3.07GHz GenuineIntel GNU/Linux


Dec 12 18:04:11 gandalf kernel: input: gandalf kbd as 
/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.
1/1-1.1.1/1-1.1.1:1.0/bluetooth/hci0/hci0:12/input45
Dec 12 18:04:11 gandalf kernel: apple 0005:05AC:023A.0025: input,hidraw2: 
BLUETOOTH HID v0.50 Keyboa
rd [gandalf kbd] on 7c:6d:62:9f:db:2d
Dec 12 18:04:28 gandalf kernel: BUG: unable to handle kernel paging request at 
ffffffff82450968
Dec 12 18:04:28 gandalf kernel: IP: [<ffffffff813450c7>] kbd_event+0x1d7/0x740
Dec 12 18:04:28 gandalf kernel: PGD 1c0c067 PUD 1c0d063 PMD 0
Dec 12 18:04:28 gandalf kernel: PGD 1c0c067 PUD 1c0d063 PMD 0
Dec 12 18:04:28 gandalf kernel: Oops: 0000 [#1] PREEMPT SMP
Dec 12 18:04:28 gandalf kernel: Modules linked in: fbcon radeon cfbfillrect 
cfbimgblt bitblit cfbcop
yarea softcursor font i2c_algo_bit drm_kms_helper ttm drm fb fbdev
Dec 12 18:04:28 gandalf kernel: CPU: 2 PID: 9153 Comm: khidpd_05ac023a Not 
tainted 3.12.3 #2
Dec 12 18:04:28 gandalf kernel: Hardware name: Apple Inc. iMac11,2/Mac-F2238AC8, 
BIOS    IM112.88Z.0057.B00.1005031455 05/03/10
Dec 12 18:04:28 gandalf kernel: task: ffff8800327e8000 ti: ffff880030858000 
task.ti: ffff880030858000
Dec 12 18:04:28 gandalf kernel: RIP: 0010:[<ffffffff813450c7>] 
[<ffffffff813450c7>] kbd_event+0x1d7/0x740
Dec 12 18:04:28 gandalf kernel: RSP: 0018:ffff880030859ba8  EFLAGS: 00010046
Dec 12 18:04:28 gandalf kernel: RAX: 000000000010000d RBX: 0000000000000038 RCX: 
ffffffff81e6cbde
Dec 12 18:04:28 gandalf kernel: RDX: ffff880030859bc0 RSI: 0000000000000001 RDI: 
ffffffff81e6cba0
Dec 12 18:04:28 gandalf kernel: RBP: 0000000000000000 R08: 0000000000000001 R09: 
0000000000000000
Dec 12 18:04:28 gandalf kernel: R10: 0000000000000000 R11: 0000000000000001 R12: 
ffff8800ba829800
Dec 12 18:04:28 gandalf kernel: R13: 000000000010000d R14: ffff880030b10500 R15: 
0000000000000038
Dec 12 18:04:28 gandalf kernel: FS:  0000000000000000(0000) 
GS:ffff88013bc80000(0000) knlGS:0000000000000000
Dec 12 18:04:28 gandalf kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 12 18:04:28 gandalf kernel: CR2: ffffffff82450968 CR3: 0000000001c0b000 CR4: 
00000000000007e0
Dec 12 18:04:28 gandalf kernel: CR2: ffffffff82450968 CR3: 0000000001c0b000 CR4: 
00000000000007e0
Dec 12 18:04:28 gandalf kernel: Stack:
Dec 12 18:04:28 gandalf kernel: ffffffff819db59b ffffffff8106e1b3 
0000000000000081 ffff8800ba829800
Dec 12 18:04:28 gandalf kernel: 0010000d00000000 0000003800000000 
0000000000000096 0000000000000003
Dec 12 18:04:28 gandalf kernel: ffff880030b103d8 ffffffff81c4e5e0 
ffff880030b103d8 ffff880030b105a0
Dec 12 18:04:28 gandalf kernel: Call Trace:
Dec 12 18:04:28 gandalf kernel: [<ffffffff8106e1b3>] ? __wake_up+0x43/0x70
Dec 12 18:04:28 gandalf kernel: [<ffffffff8145f3e3>] ? input_to_handler+0xd3/0xf0
Dec 12 18:04:28 gandalf kernel: [<ffffffff81461e72>] ? 
input_pass_values.part.8+0x162/0x170
Dec 12 18:04:28 gandalf kernel: [<ffffffff814625ad>] ? 
input_handle_event+0x12d/0x550
Dec 12 18:04:28 gandalf kernel: [<ffffffff81462afe>] ? input_event+0x5e/0xa0
Dec 12 18:04:28 gandalf kernel: [<ffffffff814e4d07>] ? 
hidinput_report_event+0x37/0x50
Dec 12 18:04:28 gandalf kernel: [<ffffffff814e3275>] ? 
hid_report_raw_event+0x285/0x460
Dec 12 18:04:28 gandalf kernel: [<ffffffff814e356d>] ? hid_input_report+0x11d/0x1b0
Dec 12 18:04:28 gandalf kernel: [<ffffffff816d589b>] ? 
hidp_session_thread+0x5eb/0x640
Dec 12 18:04:28 gandalf kernel: [<ffffffff810732d0>] ? try_to_wake_up+0x2a0/0x2a0
Dec 12 18:04:28 gandalf kernel: [<ffffffff810732d0>] ? try_to_wake_up+0x2a0/0x2a0
Dec 12 18:04:28 gandalf kernel: [<ffffffff816d52b0>] ? 
hidp_input_report.isra.9+0x2e0/0x2e0
Dec 12 18:04:28 gandalf kernel: [<ffffffff810653b3>] ? kthread+0xb3/0xc0
Dec 12 18:04:28 gandalf kernel: [<ffffffff81070000>] ? get_group+0x20/0x80
Dec 12 18:04:28 gandalf kernel: [<ffffffff81065300>] ? 
kthread_freezable_should_stop+0x60/0x60
Dec 12 18:04:28 gandalf kernel: [<ffffffff81065300>] ? 
kthread_freezable_should_stop+0x60/0x60
Dec 12 18:04:28 gandalf kernel: [<ffffffff81065300>] ? 
kthread_freezable_should_stop+0x60/0x60
Dec 12 18:04:28 gandalf kernel: [<ffffffff81773cfc>] ? ret_from_fork+0x7c/0xb0
Dec 12 18:04:28 gandalf kernel: [<ffffffff81773cfc>] ? ret_from_fork+0x7c/0xb0
Dec 12 18:04:28 gandalf kernel: [<ffffffff81065300>] ? 
kthread_freezable_should_stop+0x60/0x60
Dec 12 18:04:28 gandalf kernel: Code: e6 81 44 0f b6 68 01 44 0b 2d b6 7c b2 00 
41 31 d5 44 89 6c 24 24 48 8d 54 24 18 0f b6 40 02 d0 e8 83 e0 0f 89 44 24 28 49 
63 c5 <48> 8b 0c c5 00 09 c5 81 48 89 4c 24 08 e8 c7 59 d2 ff 48 8b 4c
Dec 12 18:04:28 gandalf kernel: RIP  [<ffffffff813450c7>] kbd_event+0x1d7/0x740
Dec 12 18:04:28 gandalf kernel: RSP <ffff880030859ba8>
Dec 12 18:04:28 gandalf kernel: CR2: ffffffff82450968
Dec 12 18:04:28 gandalf kernel: ---[ end trace edcf19cf8c005260 ]---

Thanks,

Ortwin
