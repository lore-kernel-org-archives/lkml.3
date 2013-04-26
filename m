Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab3DZRkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:40:24 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61478 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3DZRkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:40:22 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXeDT8x60iUtjJV2GO5KkDnm8CJsz8mntz5hREoOD+YJw@mail.gmail.com>
References: <CA+icZUVCmFeh3Xna37VJDDzvZ34sYJ_Dser7i5rRzGLhMTi5-Q@mail.gmail.com>
	<CA+icZUXeDT8x60iUtjJV2GO5KkDnm8CJsz8mntz5hREoOD+YJw@mail.gmail.com>
Date: Fri, 26 Apr 2013 19:40:20 +0200
Message-ID: <CA+icZUWkyP9TE0eeqstyvVNP++MtN8rYfGcPBT6NuMOHEHm7dw@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 26 [ bluetooth on suspend/resume ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 7:32 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Apr 26, 2013 at 7:30 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Fri, Apr 26, 2013 at 10:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> Changes since 20130424:
>>>
>>> Removed tree: ppc-temp (remerged into powerpc)
>>>
>>> The net-next tree gained conflicts against the net and pci trees and a
>>> build failure for which I applied a merge fix patch.
>>>
>>> The omap_dss2 tree gained a build failure so I used the version from
>>> next-20130424.
>>>
>>> The trivial tree gained a conflict against the arm tree.
>>>
>>> The staging tree still had its build failure for which I applied a
>>> supplied patch.
>>>
>>> The arm-soc tree gained a conflict against the spi-mb tree.
>>>
>>> The renesas tree gained a conflict against the input tree.
>>>
>>
>> [ CC linux-bluetooth + linux-pm folks ]
>>
>> I see the following:
>>
>> [  176.667799] PM: Syncing filesystems ... done.
>> [  176.670014] PM: Preparing system for mem sleep
>> [  176.670422] Freezing user space processes ...
>> [  196.656719] Freezing of tasks failed after 20.00 seconds (1 tasks
>> refusing to freeze, wq_busy=0):
>> [  196.656728] bluetoothd      D ffffffff8180d8c0     0  1012    863 0x00000004
>> [  196.656731]  ffff88008fdb3cc8 0000000000000046 ffff8800926530d0
>> 0000020000000000
>> [  196.656735]  ffff88008feca200 ffff88008fdb3fd8 ffff88008fdb3fd8
>> ffff88008fdb3fd8
>> [  196.656738]  ffff880119f78300 ffff88008feca200 ffff88008fdb3cf8
>> ffff880095281950
>> [  196.656741] Call Trace:
>> [  196.656749]  [<ffffffff816cfc99>] schedule+0x29/0x70
>> [  196.656752]  [<ffffffff816cff9e>] schedule_preempt_disabled+0xe/0x10
>> [  196.656754]  [<ffffffff816ce075>] __mutex_lock_slowpath+0x125/0x2f0
>> [  196.656757]  [<ffffffff816ce25e>] mutex_lock+0x1e/0x40
>> [  196.656773]  [<ffffffffa016f8b1>] hci_dev_open+0x51/0x2e0 [bluetooth]
>> [  196.656780]  [<ffffffffa0182752>] hci_sock_ioctl+0x1f2/0x3f0 [bluetooth]
>> [  196.656783]  [<ffffffff815c6050>] sock_do_ioctl+0x30/0x70
>> [  196.656786]  [<ffffffff815c75f9>] sock_ioctl+0x79/0x2f0
>> [  196.656790]  [<ffffffff811a8046>] do_vfs_ioctl+0x96/0x560
>> [  196.656794]  [<ffffffff811a85a1>] SyS_ioctl+0x91/0xb0
>> [  196.656797]  [<ffffffff816d989d>] system_call_fastpath+0x1a/0x1f
>> [  196.656811]
>> [  196.656812] Restarting tasks ... done.
>
> Forgot to attach dmesg + config, sorry.
>

Oops, NULL-pointer-deref [ __queue_work() ]

[   25.968262] Bluetooth: BNEP socket layer initialized
[   25.974875] usb 2-1.5: link qh1-0e01/ffff880091bc90c0 start 0 [1/2 us]
[   25.974932] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000100
[   25.974944] IP: [<ffffffff81077502>] __queue_work+0x32/0x3d0
[   25.974955] PGD 0
[   25.974960] Oops: 0000 [#1] SMP
[   25.974966] Modules linked in: bnep btusb(+) videobuf2_memops
snd_timer drm_kms_helper videobuf2_core snd_seq_device drm parport_pc
bluetooth microcode videodev ppdev psmouse snd cfg80211 soundcore
samsung_laptop wmi lp serio_raw video parport mac_hid lpc_ich
hid_generic usbhid hid r8169
[   25.975014] CPU: 3 PID: 1007 Comm: bluetoothd Not tainted
3.9.0-rc8-next20130426-3-iniza-small #1
[   25.975022] Hardware name: SAMSUNG ELECTRONICS CO., LTD.
530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
[   25.975030] task: ffff88008feda300 ti: ffff88008fed4000 task.ti:
ffff88008fed4000
[   25.975037] RIP: 0010:[<ffffffff81077502>]  [<ffffffff81077502>]
__queue_work+0x32/0x3d0
[   25.975047] RSP: 0018:ffff88008fed5c48  EFLAGS: 00010046
[   25.975052] RAX: 0000000000000096 RBX: 0000000000000292 RCX: 0000000000000000
[   25.975058] RDX: ffff880095281850 RSI: 0000000000000000 RDI: 0000000000000100
[   25.975063] RBP: ffff88008fed5c88 R08: 0000000000000000 R09: 0000000000000300
[   25.975069] R10: ffff880094981a00 R11: 0000000000000000 R12: ffff880095281850
[   25.975074] R13: 0000000000000000 R14: 0000000000000100 R15: 00000000000009c4
[   25.975081] FS:  00007f2f61707740(0000) GS:ffff88011fac0000(0000)
knlGS:0000000000000000
[   25.975088] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.975093] CR2: 0000000000000100 CR3: 000000009101f000 CR4: 00000000000407e0
[   25.975099] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   25.975104] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   25.975109] Stack:
[   25.975113]  ffff88008fed5c88 ffffffff00000100 ffff880095281000
0000000000000292
[   25.975124]  ffff880095281000 ffff880095281908 ffff88008fed5cf0
00000000000009c4
[   25.975133]  ffff88008fed5ca8 ffffffff81077be5 ffff880095281000
ffff88008fed5ce8
[   25.975143] Call Trace:
[   25.975151]  [<ffffffff81077be5>] queue_work_on+0x45/0x50
[   25.975165]  [<ffffffffa016e8ff>] hci_req_run+0xbf/0xf0 [bluetooth]
[   25.975177]  [<ffffffffa01709b0>] ? hci_init2_req+0x720/0x720 [bluetooth]
[   25.975188]  [<ffffffffa016ea06>] __hci_req_sync+0xd6/0x1c0 [bluetooth]
[   25.975197]  [<ffffffff8108ee10>] ? try_to_wake_up+0x2b0/0x2b0
[   25.975205]  [<ffffffff8150e3f0>] ? usb_autopm_put_interface+0x30/0x40
[   25.975217]  [<ffffffffa016fad5>] hci_dev_open+0x275/0x2e0 [bluetooth]
[   25.975230]  [<ffffffffa0182752>] hci_sock_ioctl+0x1f2/0x3f0 [bluetooth]
[   25.975238]  [<ffffffff815c6050>] sock_do_ioctl+0x30/0x70
[   25.975245]  [<ffffffff815c75f9>] sock_ioctl+0x79/0x2f0
[   25.975254]  [<ffffffff811a8046>] do_vfs_ioctl+0x96/0x560
[   25.975262]  [<ffffffff811a85a1>] SyS_ioctl+0x91/0xb0
[   25.975271]  [<ffffffff816d989d>] system_call_fastpath+0x1a/0x1f
[   25.975276] Code: 89 e5 41 57 41 56 41 89 fe 41 55 49 89 f5 41 54
49 89 d4 53 48 83 ec 18 89 7d c8 9c 58 66 66 90 66 90 f6 c4 02 0f 85
56 02 00 00 <41> 8b 85 00 01 00 00 a9 00 00 01 00 0f 85 b0 02 00 00 48
c7 c2
[   25.975344] RIP  [<ffffffff81077502>] __queue_work+0x32/0x3d0
[   25.975352]  RSP <ffff88008fed5c48>
[   25.975355] CR2: 0000000000000100
[   25.975361] ---[ end trace bb65f3a8c853eb97 ]---
[   25.976305] usbcore: registered new interface driver btusb

- Sedat -

> - Sedat -
