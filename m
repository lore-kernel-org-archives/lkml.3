Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3HZQxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:53:24 -0400
Received: from mout.gmx.net ([212.227.15.18]:53604 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab3HZQxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:53:23 -0400
Message-ID: <521B8800.8050706@gmx.de>
Date: Mon, 26 Aug 2013 18:53:20 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130807 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.11.0-rc6+ pppd doesn't stop
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:ZG/6SJmTmrm5awnslJVgTSyTNTrZ5Tl/QOFInW94TbdaxIlsCkG
 IlaGUBB/xbqp/XPUrlQE5mejy1H2hkD2aU7I+BOYk3mkTinZexR403WYCVYqm8kSq5VeZ8S
 11zT6OgP8aATsKJCZlOm8sRB6IJZNcozBejYW1e2NjzV8b3O3zqvBeE9m1EEamkB7wVHzIr
 W6+hhByC2s/iksF2opm8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A scheduled "sudo halt" yesterday night doesn't work at my stable 32 bit Gentoo Linux w/ v3.11-rc6-148-g8495e9c:

Aug 25 23:42:20 n22 /etc/init.d/net.ppp0[26127]: status: stopping
Aug 25 23:42:45 n22 kernel: thinkpad_acpi: fan watchdog: enabling fan
Aug 25 23:42:51 n22 /etc/init.d/net.ppp0[26116]: start-stop-daemon: 1 process refused to stop
Aug 25 23:45:49 n22 kernel: INFO: task pppd:5223 blocked for more than 120 seconds.
Aug 25 23:45:49 n22 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 25 23:45:49 n22 kernel: pppd            D ed8fbc2c     0  5223      1 0x00000004
Aug 25 23:45:49 n22 kernel: ed8fbc9c 00000086 5a5a5a5a ed8fbc2c c1092180 5a5a5a5a ed8fbc34 c1096f4d
Aug 25 23:45:49 n22 kernel: c15f4480 c1057a67 c15f4480 f37ba480 ee256030 c152a8e0 ed8fbffc ed8fa000
Aug 25 23:45:49 n22 kernel: ed8fa000 ffffe000 ed8fa000 ed8fbc8c 00000000 ed8fa000 00000000 00002c37
Aug 25 23:45:49 n22 kernel: Call Trace:
Aug 25 23:45:49 n22 kernel: [<c1092180>] ? __module_text_address+0x10/0x60
Aug 25 23:45:49 n22 kernel: [<c1096f4d>] ? is_module_text_address+0xd/0x20
Aug 25 23:45:49 n22 kernel: [<c1057a67>] ? __kernel_text_address+0x57/0x80
Aug 25 23:45:49 n22 kernel: [<c106b83f>] ? __enqueue_entity+0x6f/0x80
Aug 25 23:45:49 n22 kernel: [<c13e5493>] schedule+0x23/0x60
Aug 25 23:45:49 n22 kernel: [<c13e309d>] schedule_timeout+0x18d/0x1f0
Aug 25 23:45:49 n22 kernel: [<c117d854>] ? find_entry.isra.7+0x64/0xb0
Aug 25 23:45:49 n22 kernel: [<c117d8bd>] ? find_subdir+0x1d/0x40
Aug 25 23:45:49 n22 kernel: [<c117d9ec>] ? xlate_dir.isra.8+0x3c/0x50
Aug 25 23:45:49 n22 kernel: [<c13e4f4a>] wait_for_completion+0x7a/0xc0
Aug 25 23:45:49 n22 kernel: [<c1068370>] ? try_to_wake_up+0x200/0x200
Aug 25 23:45:49 n22 kernel: [<c117e1b8>] drop_sysctl_table+0xb8/0xd0
Aug 25 23:45:49 n22 kernel: [<c117e16c>] drop_sysctl_table+0x6c/0xd0
Aug 25 23:45:49 n22 kernel: [<c117e20d>] unregister_sysctl_table+0x3d/0x80
Aug 25 23:45:49 n22 kernel: [<c13d8e5d>] unregister_net_sysctl_table+0xd/0x10
Aug 25 23:45:49 n22 kernel: [<f8a1dc0c>] __addrconf_sysctl_unregister.isra.35+0x1c/0x30 [ipv6]
Aug 25 23:45:49 n22 kernel: [<f8a21d20>] addrconf_ifdown+0x1c0/0x2a0 [ipv6]
Aug 25 23:45:49 n22 kernel: [<c104184f>] ? __do_softirq+0x1af/0x220
Aug 25 23:45:49 n22 kernel: [<f8a228ae>] addrconf_notify+0x8e/0x920 [ipv6]
Aug 25 23:45:49 n22 kernel: [<c1047efb>] ? lock_timer_base.isra.36+0x2b/0x50
Aug 25 23:45:49 n22 kernel: [<c1357ade>] ? skb_dequeue+0x4e/0x70
Aug 25 23:45:49 n22 kernel: [<c136c548>] ? pneigh_queue_purge+0x28/0x40
Aug 25 23:45:49 n22 kernel: [<c136f6bf>] ? neigh_ifdown+0x8f/0xd0
Aug 25 23:45:49 n22 kernel: [<c13b2e74>] ? arp_ifdown+0x14/0x20
Aug 25 23:45:49 n22 kernel: [<c105fa69>] notifier_call_chain+0x49/0x70
Aug 25 23:45:49 n22 kernel: [<c105fbcf>] raw_notifier_call_chain+0x1f/0x30
Aug 25 23:45:49 n22 kernel: [<c1361f03>] call_netdevice_notifiers_info+0x33/0x70
Aug 25 23:45:49 n22 kernel: [<c137ba37>] ? qdisc_destroy+0x87/0xa0
Aug 25 23:45:49 n22 kernel: [<c1361f53>] call_netdevice_notifiers+0x13/0x20
Aug 25 23:45:49 n22 kernel: [<c1363783>] rollback_registered_many+0xf3/0x1e0
Aug 25 23:45:49 n22 kernel: [<c13638f4>] rollback_registered+0x24/0x40
Aug 25 23:45:49 n22 kernel: [<c1363967>] unregister_netdevice_queue+0x57/0xb0
Aug 25 23:45:49 n22 kernel: [<c13e34d8>] ? mutex_lock+0x18/0x37
Aug 25 23:45:49 n22 kernel: [<c1363a99>] unregister_netdev+0x19/0x30
Aug 25 23:45:49 n22 kernel: [<f897cee3>] ppp_shutdown_interface+0xe3/0x100 [ppp_generic]
Aug 25 23:45:49 n22 kernel: [<f897cf4c>] ppp_release+0x4c/0x70 [ppp_generic]
Aug 25 23:45:49 n22 kernel: [<c112c173>] __fput+0x93/0x1f0
Aug 25 23:45:49 n22 kernel: [<c112c30d>] ____fput+0xd/0x10
Aug 25 23:45:49 n22 kernel: [<c1057691>] task_work_run+0x81/0xb0
Aug 25 23:45:49 n22 kernel: [<c10021e2>] do_notify_resume+0x72/0x80
Aug 25 23:45:49 n22 kernel: [<c13e673b>] work_notifysig+0x24/0x29

...
Aug 26 05:28:28 n22 kernel:
Aug 26 05:28:28 n22 kernel: Restarting tasks ... done.
Aug 26 05:28:28 n22 kernel: PM: Basic memory bitmaps freed
Aug 26 05:28:28 n22 kernel: video LNXVIDEO:00: Restoring backlight state
Aug 26 05:28:28 n22 kernel: PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
Aug 26 05:28:28 n22 kernel: PM: Marking nosave pages: [mem 0x20000000-0x201fffff]
Aug 26 05:28:28 n22 kernel: PM: Basic memory bitmaps created
Aug 26 05:28:48 n22 kernel: PM: Syncing filesystems ... done.
Aug 26 05:28:48 n22 kernel: Freezing user space processes ...
Aug 26 05:28:48 n22 kernel: Freezing of tasks failed after 20.007 seconds (2 tasks refusing to freeze, wq_busy=0):
Aug 26 05:28:48 n22 kernel: pppd            D ed8fbc2c     0  5223      1 0x00000004
Aug 26 05:28:48 n22 kernel: ed8fbc9c 00000086 5a5a5a5a ed8fbc2c c1092180 5a5a5a5a ed8fbc34 c1096f4d
Aug 26 05:28:48 n22 kernel: c15f4480 c1057a67 c15f4480 f37ba480 ee256030 c152a8e0 ed8fbffc ed8fa000
Aug 26 05:28:48 n22 kernel: ed8fa000 ffffe000 ed8fa000 ed8fbc8c 00000000 ed8fa000 00000000 00002c37
Aug 26 05:28:48 n22 kernel: Call Trace:
Aug 26 05:28:48 n22 kernel: [<c1092180>] ? __module_text_address+0x10/0x60
Aug 26 05:28:48 n22 kernel: [<c1096f4d>] ? is_module_text_address+0xd/0x20
...

Aug 26 05:28:48 n22 kernel:
Aug 26 05:28:48 n22 kernel: Restarting tasks ... done.
Aug 26 05:28:48 n22 kernel: PM: Basic memory bitmaps freed
Aug 26 05:28:48 n22 kernel: video LNXVIDEO:00: Restoring backlight state


and finally the syslog entries stopped abruptly due to an empty battery of my ThinkPad  T420.

Now I'm wondering who to contact wrt to that issue ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
