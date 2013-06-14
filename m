Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3FNRVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:21:07 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34143 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3FNRUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:20:51 -0400
Message-ID: <51BB50B1.7060308@ahsoftware.de>
Date: Fri, 14 Jun 2013 19:19:45 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, Jingoo Han <jg1.han@samsung.com>
Subject: BUG: rtc: rtc_unregister_device() broken in 3.10-rcN
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just tested some things with 3.10-rc5+ and discovered that 
rtc_device_unregister is broken. This is most likely because of the 
switch to devm*. As 3.10 is already at -rc5, I'm posting this without 
having had a deeper look at the problem and writing a patch. Maybe 
someone is faster than I and can fix it before I found the time for a 
solution or before 3.10 becomes final.

Therefor here are just the message my kernel 3.10-rc5 died with, when 
removing an USB-RTC. I assume removing a RTC wasn't tested because 
almost no one does such. ;)

Regards,

Alexander Holler

-----snip-----
[   38.123288] usb 1-1.2: USB disconnect, device number 3
[   38.123813] ------------[ cut here ]------------
[   38.123822] WARNING: at include/linux/kref.h:47 kobject_get+0x3f/0x50()
[   38.123824] Modules linked in: msr nfs lockd sunrpc rfcomm bnep 
xt_LOG xt_limit nf_conntrack_ipv6 xt_recent nf_defrag_ipv6 xt_conntrack 
iptable_filter iptable_nat ip6table_filter nf_conntrack_ipv4 ip6_tables 
nf_defrag_ipv4 nf_nat_ipv4 ipv6 nf_nat nf_conntrack uvcvideo 
videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb 
bluetooth intel_powerclamp coretemp kvm_intel kvm arc4 crc32_pclmul 
crc32c_intel iwldvm ghash_clmulni_intel mac80211 snd_hda_codec_hdmi 
snd_hda_codec_realtek aesni_intel iwlwifi aes_x86_64 lrw gf128mul 
glue_helper ablk_helper cdc_acm cryptd cfg80211 snd_hda_intel microcode 
samsung_laptop joydev rfkill snd_hda_codec xhci_hcd snd_hwdep snd_pcm 
snd_page_alloc snd_timer snd lpc_ich soundcore
[   38.123873] CPU: 1 PID: 342 Comm: khubd Not tainted 
3.10.0-rc5-00229-gb7f7c9a-dirty #299
[   38.123876] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 
900X3C/900X3D/900X4C/900X4D/SAMSUNG_NP1234567890, BIOS P06AAC 02/08/2013
[   38.123878]  ffffffff81479890 0000000000000000 ffffffff810330ca 
ffff88021636e000
[   38.123881]  ffff880215858010 0000000000000002 ffff880216330a40 
ffff880215187400
[   38.123885]  ffffffff811df89f ffff8802161243c0 ffff88021636e010 
00000000fffffffc
[   38.123889] Call Trace:
[   38.123895]  [<ffffffff81479890>] ? dump_stack+0xd/0x17
[   38.123902]  [<ffffffff810330ca>] ? warn_slowpath_common+0x6a/0xa0
[   38.123905]  [<ffffffff811df89f>] ? kobject_get+0x3f/0x50
[   38.123910]  [<ffffffff81307af2>] ? get_device+0x12/0x30
[   38.123915]  [<ffffffff8137ee86>] ? rtc_device_unregister+0x16/0x90
[   38.123920]  [<ffffffff8130eb53>] ? release_nodes+0x143/0x1d0
[   38.123923]  [<ffffffff8130b86e>] ? __device_release_driver+0x7e/0xf0
[   38.123927]  [<ffffffff81309f60>] ? bus_get_device_klist+0x10/0x10
[   38.123929]  [<ffffffff8130bac5>] ? device_release_driver+0x25/0x40
[   38.123932]  [<ffffffff8130b37d>] ? bus_remove_device+0xcd/0x100
[   38.123936]  [<ffffffff81308b97>] ? device_del+0x107/0x190
[   38.123942]  [<ffffffff81319010>] ? mfd_cell_disable+0x60/0x60
[   38.123945]  [<ffffffff8130d587>] ? platform_device_del+0x17/0xb0
[   38.123948]  [<ffffffff8130d9c9>] ? platform_device_unregister+0x9/0x20
[   38.123952]  [<ffffffff8131904b>] ? mfd_remove_devices_fn+0x3b/0x50
[   38.123956]  [<ffffffff81307dee>] ? device_for_each_child+0x2e/0x60
[   38.123960]  [<ffffffff81318f9e>] ? mfd_remove_devices+0x1e/0x30
[   38.123965]  [<ffffffff8139fb86>] ? sensor_hub_remove+0x66/0xf0
[   38.123969]  [<ffffffff81315d0d>] ? rpm_idle+0x1d/0x1d0
[   38.123973]  [<ffffffff81397fb3>] ? hid_device_remove+0x73/0xf0
[   38.123976]  [<ffffffff8130b866>] ? __device_release_driver+0x76/0xf0
[   38.123980]  [<ffffffff81309f60>] ? bus_get_device_klist+0x10/0x10
[   38.123983]  [<ffffffff8130bac5>] ? device_release_driver+0x25/0x40
[   38.123986]  [<ffffffff8130b37d>] ? bus_remove_device+0xcd/0x100
[   38.123991]  [<ffffffff81308b97>] ? device_del+0x107/0x190
[   38.123995]  [<ffffffff81397b89>] ? hid_destroy_device+0x29/0x60
[   38.123999]  [<ffffffff813a158e>] ? usbhid_disconnect+0x1e/0x40
[   38.124004]  [<ffffffff81353b8a>] ? usb_unbind_interface+0x6a/0x1c0
[   38.124007]  [<ffffffff8130b866>] ? __device_release_driver+0x76/0xf0
[   38.124011]  [<ffffffff81309f60>] ? bus_get_device_klist+0x10/0x10
[   38.124014]  [<ffffffff8130bac5>] ? device_release_driver+0x25/0x40
[   38.124016]  [<ffffffff8130b37d>] ? bus_remove_device+0xcd/0x100
[   38.124020]  [<ffffffff81308b97>] ? device_del+0x107/0x190
[   38.124023]  [<ffffffff81351834>] ? usb_disable_device+0x94/0x1d0
[   38.124028]  [<ffffffff81349586>] ? usb_disconnect+0x96/0x190
[   38.124032]  [<ffffffff8134aba9>] ? hub_thread+0x319/0x12d0
[   38.124038]  [<ffffffff8147c5db>] ? __schedule+0x28b/0x690
[   38.124042]  [<ffffffff810536c0>] ? finish_wait+0x90/0x90
[   38.124046]  [<ffffffff8134a890>] ? hub_port_debounce+0xe0/0xe0
[   38.124049]  [<ffffffff81053123>] ? kthread+0xb3/0xc0
[   38.124053]  [<ffffffff81053070>] ? kthread_create_on_node+0x110/0x110
[   38.124057]  [<ffffffff8147eaec>] ? ret_from_fork+0x7c/0xb0
[   38.124060]  [<ffffffff81053070>] ? kthread_create_on_node+0x110/0x110
[   38.124063] ---[ end trace f896f8f65422d83d ]---
[   38.124075] BUG: unable to handle kernel NULL pointer dereference at 
00000000000000a4
[   38.126012] IP: [<ffffffff81381e95>] rtc_sysfs_del_device+0x15/0x60
[   38.127757] PGD 0
[   38.129536] Oops: 0000 [#1] SMP
[   38.131261] Modules linked in: msr nfs lockd sunrpc rfcomm bnep 
xt_LOG xt_limit nf_conntrack_ipv6 xt_recent nf_defrag_ipv6 xt_conntrack 
iptable_filter iptable_nat ip6table_filter nf_conntrack_ipv4 ip6_tables 
nf_defrag_ipv4 nf_nat_ipv4 ipv6 nf_nat nf_conntrack uvcvideo 
videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb 
bluetooth intel_powerclamp coretemp kvm_intel kvm arc4 crc32_pclmul 
crc32c_intel iwldvm ghash_clmulni_intel mac80211 snd_hda_codec_hdmi 
snd_hda_codec_realtek aesni_intel iwlwifi aes_x86_64 lrw gf128mul 
glue_helper ablk_helper cdc_acm cryptd cfg80211 snd_hda_intel microcode 
samsung_laptop joydev rfkill snd_hda_codec xhci_hcd snd_hwdep snd_pcm 
snd_page_alloc snd_timer snd lpc_ich soundcore
[   38.139094] CPU: 1 PID: 342 Comm: khubd Tainted: G        W 
3.10.0-rc5-00229-gb7f7c9a-dirty #299
[   38.141075] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 
900X3C/900X3D/900X4C/900X4D/SAMSUNG_NP1234567890, BIOS P06AAC 02/08/2013
[   38.143095] task: ffff880216102ed0 ti: ffff880216388000 task.ti: 
ffff880216388000
[   38.145114] RIP: 0010:[<ffffffff81381e95>]  [<ffffffff81381e95>] 
rtc_sysfs_del_device+0x15/0x60
[   38.147160] RSP: 0018:ffff8802163899f8  EFLAGS: 00010296
[   38.149191] RAX: 0000000000000000 RBX: ffff88021636e000 RCX: 
0000000000000006
[   38.151229] RDX: 0000000000000007 RSI: 0000000000000046 RDI: 
ffff88021f28ce50
[   38.153264] RBP: ffff88021636e2a8 R08: 000000000000000a R09: 
0000000000000339
[   38.155288] R10: 0000000000000000 R11: 0000000000000338 R12: 
0000000000000002
[   38.157304] R13: ffff880216330a40 R14: ffff880215187400 R15: 
0000000000000000
[   38.159316] FS:  0000000000000000(0000) GS:ffff88021f280000(0000) 
knlGS:0000000000000000
[   38.161336] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.163347] CR2: 00000000000000a4 CR3: 000000000180b000 CR4: 
00000000001407e0
[   38.165366] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   38.167380] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   38.169381] Stack:
[   38.171355]  ffff88021636e000 ffffffff8137eea2 00000000fffffffc 
ffff880216389a28
[   38.173376]  ffff880215858010 ffffffff8130eb53 ffff880215187400 
ffff880216330a40
[   38.175388]  ffff880215858010 ffffffff8184ea08 ffffffff81848b80 
00000000fffffffc
[   38.177393] Call Trace:
[   38.179368]  [<ffffffff8137eea2>] ? rtc_device_unregister+0x32/0x90
[   38.181361]  [<ffffffff8130eb53>] ? release_nodes+0x143/0x1d0
[   38.183343]  [<ffffffff8130b86e>] ? __device_release_driver+0x7e/0xf0
[   38.185316]  [<ffffffff81309f60>] ? bus_get_device_klist+0x10/0x10
[   38.187280]  [<ffffffff8130bac5>] ? device_release_driver+0x25/0x40
[   38.189233]  [<ffffffff8130b37d>] ? bus_remove_device+0xcd/0x100
[   38.191175]  [<ffffffff81308b97>] ? device_del+0x107/0x190
[   38.193101]  [<ffffffff81319010>] ? mfd_cell_disable+0x60/0x60
[   38.195013]  [<ffffffff8130d587>] ? platform_device_del+0x17/0xb0
[   38.196919]  [<ffffffff8130d9c9>] ? platform_device_unregister+0x9/0x20
[   38.198811]  [<ffffffff8131904b>] ? mfd_remove_devices_fn+0x3b/0x50
[   38.200695]  [<ffffffff81307dee>] ? device_for_each_child+0x2e/0x60
[   38.202568]  [<ffffffff81318f9e>] ? mfd_remove_devices+0x1e/0x30
[   38.204431]  [<ffffffff8139fb86>] ? sensor_hub_remove+0x66/0xf0
[   38.206281]  [<ffffffff81315d0d>] ? rpm_idle+0x1d/0x1d0
[   38.208138]  [<ffffffff81397fb3>] ? hid_device_remove+0x73/0xf0
[   38.210019]  [<ffffffff8130b866>] ? __device_release_driver+0x76/0xf0
[   38.211915]  [<ffffffff81309f60>] ? bus_get_device_klist+0x10/0x10
[   38.213830]  [<ffffffff8130bac5>] ? device_release_driver+0x25/0x40
[   38.215737]  [<ffffffff8130b37d>] ? bus_remove_device+0xcd/0x100
[   38.217636]  [<ffffffff81308b97>] ? device_del+0x107/0x190
[   38.219522]  [<ffffffff81397b89>] ? hid_destroy_device+0x29/0x60
[   38.221420]  [<ffffffff813a158e>] ? usbhid_disconnect+0x1e/0x40
[   38.223331]  [<ffffffff81353b8a>] ? usb_unbind_interface+0x6a/0x1c0
[   38.225255]  [<ffffffff8130b866>] ? __device_release_driver+0x76/0xf0
[   38.227178]  [<ffffffff81309f60>] ? bus_get_device_klist+0x10/0x10
[   38.229078]  [<ffffffff8130bac5>] ? device_release_driver+0x25/0x40
[   38.230967]  [<ffffffff8130b37d>] ? bus_remove_device+0xcd/0x100
[   38.232828]  [<ffffffff81308b97>] ? device_del+0x107/0x190
[   38.234653]  [<ffffffff81351834>] ? usb_disable_device+0x94/0x1d0
[   38.236473]  [<ffffffff81349586>] ? usb_disconnect+0x96/0x190
[   38.238291]  [<ffffffff8134aba9>] ? hub_thread+0x319/0x12d0
[   38.240045]  [<ffffffff8147c5db>] ? __schedule+0x28b/0x690
[   38.241719]  [<ffffffff810536c0>] ? finish_wait+0x90/0x90
[   38.243320]  [<ffffffff8134a890>] ? hub_port_debounce+0xe0/0xe0
[   38.244849]  [<ffffffff81053123>] ? kthread+0xb3/0xc0
[   38.246338]  [<ffffffff81053070>] ? kthread_create_on_node+0x110/0x110
[   38.247794]  [<ffffffff8147eaec>] ? ret_from_fork+0x7c/0xb0
[   38.249212]  [<ffffffff81053070>] ? kthread_create_on_node+0x110/0x110
[   38.250613] Code: 73 81 5b 31 c0 e9 0c 68 f8 ff 66 66 66 2e 0f 1f 84 
00 00 00 00 00 53 31 c0 48 89 fb 48 c7 c7 fd 18 72 81 e8 e1 51 0f 00 48 
8b 03 <f6> 80 a4 00 00 00 01 74 0e 48 8b 83 a0 02 00 00 48 83 78 30 00
[   38.253900] RIP  [<ffffffff81381e95>] rtc_sysfs_del_device+0x15/0x60
[   38.255476]  RSP <ffff8802163899f8>
[   38.257038] CR2: 00000000000000a4
[   38.258610] ---[ end trace f896f8f65422d83e ]---
