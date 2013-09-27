Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3I0Nev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:34:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab3I0Nes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:34:48 -0400
Message-ID: <5245896A.70705@redhat.com>
Date: Fri, 27 Sep 2013 15:34:34 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: linux.nics@intel.com, e1000-devel@lists.sourceforge.net
Subject: kobject_add_internal failed for msi_irqs with -EEXIST
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

With recent build of 3.12-rc2 I'm getting this warning report from kernel:
(hw Lenovo T61, C2D, 4GB Ram)
(repost since linux-kernel@ rejected my gmail email....)


e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
------------[ cut here ]------------
WARNING: CPU: 1 PID: 301 at fs/sysfs/dir.c:526 sysfs_add_one+0xa5/0xd0()
sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:19.0/msi_irqs'
Modules linked in: bnep btusb bluetooth iTCO_wdt iTCO_vendor_support 
snd_hda_codec_analog hid_generic coretemp kvm_intel kvm arc4 microcode psmouse 
serio_raw i2c_i801 i2c_core iwl3945 iwlegacy sdhci_pci usbhid mac80211 hid 
r852 sm_common nand nand_ecc r592 sdhci lpc_ich nand_ids mfd_core mmc_core mtd 
memstick cfg80211 snd_hda_intel snd_hda_codec snd_seq snd_seq_device wmi 
thinkpad_acpi snd_pcm nvram e1000e snd_page_alloc snd_timer snd evdev ptp 
soundcore pps_core nfsd auth_rpcgss oid_registry exportfs nfs_acl loop lockd 
binfmt_misc sunrpc pcmcia sr_mod cdrom yenta_socket ehci_pci ehci_hcd uhci_hcd 
usbcore usb_common video backlight autofs4
CPU: 0 PID: 301 Comm: NetworkManager Not tainted 3.12.0-rc2-00088-gfcbfc0d #163
Hardware name: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 03/18/2011
  0000000000000009 ffff8800b85fb558 ffffffff81595d57 ffff8800b85fb5a0
  ffff8800b85fb590 ffffffff810491ad 00000000ffffffef ffff8800b79a8c80
  ffff8800b85fb638 ffff8800b87df000 0000000000000000 ffff8800b85fb5f0
Call Trace:
  [<ffffffff81595d57>] dump_stack+0x4e/0x82
  [<ffffffff810491ad>] warn_slowpath_common+0x7d/0xa0
  [<ffffffff8104921c>] warn_slowpath_fmt+0x4c/0x50
  [<ffffffff812258c5>] sysfs_add_one+0xa5/0xd0
  [<ffffffff81225a44>] create_dir+0x74/0xd0
  [<ffffffff81225db9>] sysfs_create_dir+0x89/0xe0
  [<ffffffff8132fba8>] kobject_add_internal+0xc8/0x320
  [<ffffffff8134320d>] ? __raw_spin_lock_init+0x2d/0x50
  [<ffffffff813302d0>] kset_register+0x20/0x50
  [<ffffffff81330371>] kset_create_and_add+0x71/0xb0
  [<ffffffff8136ce0a>] populate_msi_sysfs+0x2a/0x120
  [<ffffffff8136d598>] pci_enable_msi_block+0x1b8/0x2c0
  [<ffffffffa03493c5>] e1000_open+0x225/0x5b0 [e1000e]
  [<ffffffff814db50f>] __dev_open+0xbf/0x140
  [<ffffffff814db7d2>] __dev_change_flags+0x92/0x170
  [<ffffffff814db95d>] dev_change_flags+0x1d/0x60
  [<ffffffff814e9ff2>] do_setlink+0x342/0xa00
  [<ffffffff8100ac94>] ? native_sched_clock+0x24/0x80
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff8134dfb2>] ? nla_parse+0x32/0xe0
  [<ffffffff814eb2df>] rtnl_newlink+0x38f/0x5d0
  [<ffffffff8100ac94>] ? native_sched_clock+0x24/0x80
  [<ffffffff810bf70f>] ? trace_hardirqs_off_caller+0x1f/0xc0
  [<ffffffff814e814c>] rtnetlink_rcv_msg+0x9c/0x260
  [<ffffffff81598447>] ? mutex_lock_nested+0x2f7/0x440
  [<ffffffff814e808b>] ? rtnetlink_rcv+0x1b/0x40
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff814e808b>] ? rtnetlink_rcv+0x1b/0x40
  [<ffffffff814e80b0>] ? rtnetlink_rcv+0x40/0x40
  [<ffffffff81500279>] netlink_rcv_skb+0xa9/0xc0
  [<ffffffff814e809a>] rtnetlink_rcv+0x2a/0x40
  [<ffffffff814ff8bd>] netlink_unicast+0xdd/0x190
  [<ffffffff814ffc99>] netlink_sendmsg+0x329/0x750
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff814bc5d8>] sock_sendmsg+0xa8/0x180
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff81169e90>] ? might_fault+0xa0/0xb0
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff814ca736>] ? verify_iovec+0x56/0xd0
  [<ffffffff814bd05e>] ___sys_sendmsg+0x35e/0x370
  [<ffffffff810c039d>] ? lock_release_holdtime.part.29+0x9d/0x160
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff811c9bc2>] ? fget_light+0xd2/0x4f0
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff815a2141>] ? sub_preempt_count+0x71/0x100
  [<ffffffff810bfefe>] ? put_lock_stats.isra.28+0xe/0x40
  [<ffffffff811c9bdf>] ? fget_light+0xef/0x4f0
  [<ffffffff811c9b2c>] ? fget_light+0x3c/0x4f0
  [<ffffffff814bd762>] __sys_sendmsg+0x42/0x80
  [<ffffffff814bd7b2>] SyS_sendmsg+0x12/0x20
  [<ffffffff815a6556>] system_call_fastpath+0x1a/0x1f
---[ end trace 881f4293213af6b4 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 301 at lib/kobject.c:196 kobject_add_internal+0x204/0x320()
kobject_add_internal failed for msi_irqs with -EEXIST, don't try to register 
things with the same name in the same directory.
Modules linked in: bnep btusb bluetooth iTCO_wdt iTCO_vendor_support 
snd_hda_codec_analog hid_generic coretemp kvm_intel kvm arc4 microcode psmouse 
serio_raw i2c_i801 i2c_core iwl3945 iwlegacy sdhci_pci usbhid mac80211 hid 
r852 sm_common nand nand_ecc r592 sdhci lpc_ich nand_ids mfd_core mmc_core mtd 
memstick cfg80211 snd_hda_intel snd_hda_codec snd_seq snd_seq_device wmi 
thinkpad_acpi snd_pcm nvram e1000e snd_page_alloc snd_timer snd evdev ptp 
soundcore pps_core nfsd auth_rpcgss oid_registry exportfs nfs_acl loop lockd 
binfmt_misc sunrpc pcmcia sr_mod cdrom yenta_socket ehci_pci ehci_hcd uhci_hcd 
usbcore usb_common video backlight autofs4
CPU: 0 PID: 301 Comm: NetworkManager Tainted: G        W 
3.12.0-rc2-00088-gfcbfc0d #163
Hardware name: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 03/18/2011
  0000000000000009 ffff8800b85fb608 ffffffff81595d57 ffff8800b85fb650
  ffff8800b85fb640 ffffffff810491ad ffff880036e7c258 00000000ffffffef
  ffff880135b6c0a8 ffff880135b6c0a8 ffff8800ba074000 ffff8800b85fb6a0
Call Trace:
  [<ffffffff81595d57>] dump_stack+0x4e/0x82
  [<ffffffff810491ad>] warn_slowpath_common+0x7d/0xa0
  [<ffffffff8104921c>] warn_slowpath_fmt+0x4c/0x50
  [<ffffffff81225db9>] ? sysfs_create_dir+0x89/0xe0
  [<ffffffff8132fce4>] kobject_add_internal+0x204/0x320
  [<ffffffff8134320d>] ? __raw_spin_lock_init+0x2d/0x50
  [<ffffffff813302d0>] kset_register+0x20/0x50
  [<ffffffff81330371>] kset_create_and_add+0x71/0xb0
  [<ffffffff8136ce0a>] populate_msi_sysfs+0x2a/0x120
  [<ffffffff8136d598>] pci_enable_msi_block+0x1b8/0x2c0
  [<ffffffffa03493c5>] e1000_open+0x225/0x5b0 [e1000e]
  [<ffffffff814db50f>] __dev_open+0xbf/0x140
  [<ffffffff814db7d2>] __dev_change_flags+0x92/0x170
  [<ffffffff814db95d>] dev_change_flags+0x1d/0x60
  [<ffffffff814e9ff2>] do_setlink+0x342/0xa00
  [<ffffffff8100ac94>] ? native_sched_clock+0x24/0x80
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff8134dfb2>] ? nla_parse+0x32/0xe0
  [<ffffffff814eb2df>] rtnl_newlink+0x38f/0x5d0
  [<ffffffff8100ac94>] ? native_sched_clock+0x24/0x80
  [<ffffffff810bf70f>] ? trace_hardirqs_off_caller+0x1f/0xc0
  [<ffffffff814e814c>] rtnetlink_rcv_msg+0x9c/0x260
  [<ffffffff81598447>] ? mutex_lock_nested+0x2f7/0x440
  [<ffffffff814e808b>] ? rtnetlink_rcv+0x1b/0x40
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff814e808b>] ? rtnetlink_rcv+0x1b/0x40
  [<ffffffff814e80b0>] ? rtnetlink_rcv+0x40/0x40
  [<ffffffff81500279>] netlink_rcv_skb+0xa9/0xc0
  [<ffffffff814e809a>] rtnetlink_rcv+0x2a/0x40
  [<ffffffff814ff8bd>] netlink_unicast+0xdd/0x190
  [<ffffffff814ffc99>] netlink_sendmsg+0x329/0x750
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff814bc5d8>] sock_sendmsg+0xa8/0x180
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff81169e90>] ? might_fault+0xa0/0xb0
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff814ca736>] ? verify_iovec+0x56/0xd0
  [<ffffffff814bd05e>] ___sys_sendmsg+0x35e/0x370
  [<ffffffff810c039d>] ? lock_release_holdtime.part.29+0x9d/0x160
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff811c9bc2>] ? fget_light+0xd2/0x4f0
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff815a2141>] ? sub_preempt_count+0x71/0x100
  [<ffffffff810bfefe>] ? put_lock_stats.isra.28+0xe/0x40
  [<ffffffff811c9bdf>] ? fget_light+0xef/0x4f0
  [<ffffffff811c9b2c>] ? fget_light+0x3c/0x4f0
  [<ffffffff814bd762>] __sys_sendmsg+0x42/0x80
  [<ffffffff814bd7b2>] SyS_sendmsg+0x12/0x20
  [<ffffffff815a6556>] system_call_fastpath+0x1a/0x1f
---[ end trace 881f4293213af6b5 ]---
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
------------[ cut here ]------------
WARNING: CPU: 1 PID: 301 at fs/sysfs/dir.c:526 sysfs_add_one+0xa5/0xd0()
sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:19.0/msi_irqs'
Modules linked in: bnep btusb bluetooth iTCO_wdt iTCO_vendor_support 
snd_hda_codec_analog hid_generic coretemp kvm_intel kvm arc4 microcode psmouse 
serio_raw i2c_i801 i2c_core iwl3945 iwlegacy sdhci_pci usbhid mac80211 hid 
r852 sm_common nand nand_ecc r592 sdhci lpc_ich nand_ids mfd_core mmc_core mtd 
memstick cfg80211 snd_hda_intel snd_hda_codec snd_seq snd_seq_device wmi 
thinkpad_acpi snd_pcm nvram e1000e snd_page_alloc snd_timer snd evdev ptp 
soundcore pps_core nfsd auth_rpcgss oid_registry exportfs nfs_acl loop lockd 
binfmt_misc sunrpc pcmcia sr_mod cdrom yenta_socket ehci_pci ehci_hcd uhci_hcd 
usbcore usb_common video backlight autofs4
CPU: 0 PID: 301 Comm: NetworkManager Tainted: G        W 
3.12.0-rc2-00088-gfcbfc0d #163
Hardware name: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 03/18/2011
  0000000000000009 ffff8800b85fb540 ffffffff81595d57 ffff8800b85fb588
  ffff8800b85fb578 ffffffff810491ad 00000000ffffffef ffff8800b79a8c80
  ffff8800b85fb620 ffff8800b87dc000 0000000000000000 ffff8800b85fb5d8
Call Trace:
  [<ffffffff81595d57>] dump_stack+0x4e/0x82
  [<ffffffff810491ad>] warn_slowpath_common+0x7d/0xa0
  [<ffffffff8104921c>] warn_slowpath_fmt+0x4c/0x50
  [<ffffffff812258c5>] sysfs_add_one+0xa5/0xd0
  [<ffffffff81225a44>] create_dir+0x74/0xd0
  [<ffffffff81225db9>] sysfs_create_dir+0x89/0xe0
  [<ffffffff8132fba8>] kobject_add_internal+0xc8/0x320
  [<ffffffff8134320d>] ? __raw_spin_lock_init+0x2d/0x50
  [<ffffffff813302d0>] kset_register+0x20/0x50
  [<ffffffff81330371>] kset_create_and_add+0x71/0xb0
  [<ffffffff8136ce0a>] populate_msi_sysfs+0x2a/0x120
  [<ffffffff8136d598>] pci_enable_msi_block+0x1b8/0x2c0
  [<ffffffffa0343e41>] e1000e_set_interrupt_capability+0x41/0x120 [e1000e]
  [<ffffffffa03493d5>] e1000_open+0x235/0x5b0 [e1000e]
  [<ffffffff814db50f>] __dev_open+0xbf/0x140
  [<ffffffff814db7d2>] __dev_change_flags+0x92/0x170
  [<ffffffff814db95d>] dev_change_flags+0x1d/0x60
  [<ffffffff814e9ff2>] do_setlink+0x342/0xa00
  [<ffffffff8100ac94>] ? native_sched_clock+0x24/0x80
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff8134dfb2>] ? nla_parse+0x32/0xe0
  [<ffffffff814eb2df>] rtnl_newlink+0x38f/0x5d0
  [<ffffffff8100ac94>] ? native_sched_clock+0x24/0x80
  [<ffffffff810bf70f>] ? trace_hardirqs_off_caller+0x1f/0xc0
  [<ffffffff814e814c>] rtnetlink_rcv_msg+0x9c/0x260
  [<ffffffff81598447>] ? mutex_lock_nested+0x2f7/0x440
  [<ffffffff814e808b>] ? rtnetlink_rcv+0x1b/0x40
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff814e808b>] ? rtnetlink_rcv+0x1b/0x40
  [<ffffffff814e80b0>] ? rtnetlink_rcv+0x40/0x40
  [<ffffffff81500279>] netlink_rcv_skb+0xa9/0xc0
  [<ffffffff814e809a>] rtnetlink_rcv+0x2a/0x40
  [<ffffffff814ff8bd>] netlink_unicast+0xdd/0x190
  [<ffffffff814ffc99>] netlink_sendmsg+0x329/0x750
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff814bc5d8>] sock_sendmsg+0xa8/0x180
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff81169e90>] ? might_fault+0xa0/0xb0
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff814ca736>] ? verify_iovec+0x56/0xd0
  [<ffffffff814bd05e>] ___sys_sendmsg+0x35e/0x370
  [<ffffffff810c039d>] ? lock_release_holdtime.part.29+0x9d/0x160
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff811c9bc2>] ? fget_light+0xd2/0x4f0
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff815a2141>] ? sub_preempt_count+0x71/0x100
  [<ffffffff810bfefe>] ? put_lock_stats.isra.28+0xe/0x40
  [<ffffffff811c9bdf>] ? fget_light+0xef/0x4f0
  [<ffffffff811c9b2c>] ? fget_light+0x3c/0x4f0
  [<ffffffff814bd762>] __sys_sendmsg+0x42/0x80
  [<ffffffff814bd7b2>] SyS_sendmsg+0x12/0x20
  [<ffffffff815a6556>] system_call_fastpath+0x1a/0x1f
---[ end trace 881f4293213af6b6 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 301 at lib/kobject.c:196 kobject_add_internal+0x204/0x320()
kobject_add_internal failed for msi_irqs with -EEXIST, don't try to register 
things with the same name in the same directory.
Modules linked in: bnep btusb bluetooth iTCO_wdt iTCO_vendor_support 
snd_hda_codec_analog hid_generic coretemp kvm_intel kvm arc4 microcode psmouse 
serio_raw i2c_i801 i2c_core iwl3945 iwlegacy sdhci_pci usbhid mac80211 hid 
r852 sm_common nand nand_ecc r592 sdhci lpc_ich nand_ids mfd_core mmc_core mtd 
memstick cfg80211 snd_hda_intel snd_hda_codec snd_seq snd_seq_device wmi 
thinkpad_acpi snd_pcm nvram e1000e snd_page_alloc snd_timer snd evdev ptp 
soundcore pps_core nfsd auth_rpcgss oid_registry exportfs nfs_acl loop lockd 
binfmt_misc sunrpc pcmcia sr_mod cdrom yenta_socket ehci_pci ehci_hcd uhci_hcd 
usbcore usb_common video backlight autofs4
CPU: 1 PID: 301 Comm: NetworkManager Tainted: G        W 
3.12.0-rc2-00088-gfcbfc0d #163
Hardware name: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 03/18/2011
  0000000000000009 ffff8800b85fb5f0 ffffffff81595d57 ffff8800b85fb638
  ffff8800b85fb628 ffffffff810491ad ffff880036e7c258 00000000ffffffef
  ffff880135b6c0a8 ffff880135b6c0a8 ffff8800ba074000 ffff8800b85fb688
Call Trace:
  [<ffffffff81595d57>] dump_stack+0x4e/0x82
  [<ffffffff810491ad>] warn_slowpath_common+0x7d/0xa0
  [<ffffffff8104921c>] warn_slowpath_fmt+0x4c/0x50
  [<ffffffff81225db9>] ? sysfs_create_dir+0x89/0xe0
  [<ffffffff8132fce4>] kobject_add_internal+0x204/0x320
  [<ffffffff8134320d>] ? __raw_spin_lock_init+0x2d/0x50
  [<ffffffff813302d0>] kset_register+0x20/0x50
  [<ffffffff81330371>] kset_create_and_add+0x71/0xb0
  [<ffffffff8136ce0a>] populate_msi_sysfs+0x2a/0x120
  [<ffffffff8136d598>] pci_enable_msi_block+0x1b8/0x2c0
  [<ffffffffa0343e41>] e1000e_set_interrupt_capability+0x41/0x120 [e1000e]
  [<ffffffffa03493d5>] e1000_open+0x235/0x5b0 [e1000e]
  [<ffffffff814db50f>] __dev_open+0xbf/0x140
  [<ffffffff814db7d2>] __dev_change_flags+0x92/0x170
  [<ffffffff814db95d>] dev_change_flags+0x1d/0x60
  [<ffffffff814e9ff2>] do_setlink+0x342/0xa00
  [<ffffffff8100ac94>] ? native_sched_clock+0x24/0x80
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff8134dfb2>] ? nla_parse+0x32/0xe0
  [<ffffffff814eb2df>] rtnl_newlink+0x38f/0x5d0
  [<ffffffff8100ac94>] ? native_sched_clock+0x24/0x80
  [<ffffffff810bf70f>] ? trace_hardirqs_off_caller+0x1f/0xc0
  [<ffffffff814e814c>] rtnetlink_rcv_msg+0x9c/0x260
  [<ffffffff81598447>] ? mutex_lock_nested+0x2f7/0x440
  [<ffffffff814e808b>] ? rtnetlink_rcv+0x1b/0x40
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff814e808b>] ? rtnetlink_rcv+0x1b/0x40
  [<ffffffff814e80b0>] ? rtnetlink_rcv+0x40/0x40
  [<ffffffff81500279>] netlink_rcv_skb+0xa9/0xc0
  [<ffffffff814e809a>] rtnetlink_rcv+0x2a/0x40
  [<ffffffff814ff8bd>] netlink_unicast+0xdd/0x190
  [<ffffffff814ffc99>] netlink_sendmsg+0x329/0x750
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff814bc5d8>] sock_sendmsg+0xa8/0x180
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff81169e90>] ? might_fault+0xa0/0xb0
  [<ffffffff81169e47>] ? might_fault+0x57/0xb0
  [<ffffffff814ca736>] ? verify_iovec+0x56/0xd0
  [<ffffffff814bd05e>] ___sys_sendmsg+0x35e/0x370
  [<ffffffff810c039d>] ? lock_release_holdtime.part.29+0x9d/0x160
  [<ffffffff8108c01f>] ? local_clock+0x3f/0x50
  [<ffffffff811c9bc2>] ? fget_light+0xd2/0x4f0
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff8108624d>] ? get_parent_ip+0xd/0x50
  [<ffffffff815a2141>] ? sub_preempt_count+0x71/0x100
  [<ffffffff810bfefe>] ? put_lock_stats.isra.28+0xe/0x40
  [<ffffffff811c9bdf>] ? fget_light+0xef/0x4f0
  [<ffffffff811c9b2c>] ? fget_light+0x3c/0x4f0
  [<ffffffff814bd762>] __sys_sendmsg+0x42/0x80
  [<ffffffff814bd7b2>] SyS_sendmsg+0x12/0x20
  [<ffffffff815a6556>] system_call_fastpath+0x1a/0x1f
---[ end trace 881f4293213af6b7 ]---
e1000e 0000:00:19.0 eth0: Failed to initialize MSI interrupts.  Falling back 
to legacy interrupts.
iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
systemd[1]: Started /etc/rc.d/rc.local Compatibility.




# lspci
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory 
Controller Hub (rev 0c)
00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 
Integrated Graphics Controller (primary) (rev 0c)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated 
Graphics Controller (secondary) (rev 0c)
00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network 
Connection (rev 03)
00:1a.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #4 (rev 03)
00:1a.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #5 (rev 03)
00:1a.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 
(rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 
(rev 03)
00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 
(rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 
(rev 03)
00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 
(rev 03)
00:1d.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #1 (rev 03)
00:1d.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #2 (rev 03)
00:1d.2 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #3 (rev 03)
00:1d.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M-E) LPC Interface 
Controller (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) IDE 
Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) SATA 
Controller [AHCI mode] (rev 03)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] 
Network Connection (rev 02)
15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host 
Adapter (rev 21)
15:00.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter 
(rev 11)
15:00.5 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 11)

# lspci -v
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory 
Controller Hub (rev 0c)
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, fast devsel, latency 0
     Capabilities: [e0] Vendor Specific Information: Len=0a <?>
     Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 
Integrated Graphics Controller (primary) (rev 0c) (prog-if 00 [VGA controller])
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, fast devsel, latency 0, IRQ 49
     Memory at f8100000 (64-bit, non-prefetchable) [size=1M]
     Memory at e0000000 (64-bit, prefetchable) [size=256M]
     I/O ports at 1800 [size=8]
     Expansion ROM at <unassigned> [disabled]
     Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
     Capabilities: [d0] Power Management version 3
     Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated 
Graphics Controller (secondary) (rev 0c)
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, fast devsel, latency 0
     Memory at f8200000 (64-bit, non-prefetchable) [size=1M]
     Capabilities: [d0] Power Management version 3

00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network 
Connection (rev 03)
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, fast devsel, latency 0, IRQ 46
     Memory at fe000000 (32-bit, non-prefetchable) [size=128K]
     Memory at fe025000 (32-bit, non-prefetchable) [size=4K]
     I/O ports at 1840 [size=32]
     Capabilities: [c8] Power Management version 2
     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
     Kernel driver in use: e1000e

00:1a.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #4 (rev 03) (prog-if 00 [UHCI])
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, medium devsel, latency 0, IRQ 20
     I/O ports at 1860 [size=32]
     Kernel driver in use: uhci_hcd

00:1a.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #5 (rev 03) (prog-if 00 [UHCI])
     Subsystem: Lenovo Thinkpad T61/R61
     Flags: bus master, medium devsel, latency 0, IRQ 21
     I/O ports at 1880 [size=32]
     Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #2 (rev 03) (prog-if 20 [EHCI])
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, medium devsel, latency 0, IRQ 22
     Memory at fe226c00 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
     Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 03)
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, fast devsel, latency 0, IRQ 47
     Memory at fe020000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 2
     Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
     Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
     Capabilities: [100] Virtual Channel
     Capabilities: [130] Root Complex Link
     Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 
(rev 03) (prog-if 00 [Normal decode])
     Flags: bus master, fast devsel, latency 0
     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
     I/O behind bridge: 00002000-00002fff
     Memory behind bridge: fc000000-fdffffff
     Prefetchable memory behind bridge: 00000000f8000000-00000000f80fffff
     Capabilities: [40] Express Root Port (Slot+), MSI 00
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
     Capabilities: [90] Subsystem: Lenovo ThinkPad T61/R61
     Capabilities: [a0] Power Management version 2
     Capabilities: [100] Virtual Channel
     Capabilities: [180] Root Complex Link
     Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 
(rev 03) (prog-if 00 [Normal decode])
     Flags: bus master, fast devsel, latency 0
     Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
     I/O behind bridge: 00003000-00003fff
     Memory behind bridge: dc000000-df3fffff
     Prefetchable memory behind bridge: 00000000dfe00000-00000000dfefffff
     Capabilities: [40] Express Root Port (Slot+), MSI 00
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
     Capabilities: [90] Subsystem: Lenovo ThinkPad T61/R61
     Capabilities: [a0] Power Management version 2
     Capabilities: [100] Virtual Channel
     Capabilities: [180] Root Complex Link
     Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 
(rev 03) (prog-if 00 [Normal decode])
     Flags: bus master, fast devsel, latency 0
     Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
     I/O behind bridge: 00004000-00004fff
     Memory behind bridge: d8000000-d9ffffff
     Prefetchable memory behind bridge: 00000000dfb00000-00000000dfbfffff
     Capabilities: [40] Express Root Port (Slot+), MSI 00
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
     Capabilities: [90] Subsystem: Lenovo ThinkPad T61/R61
     Capabilities: [a0] Power Management version 2
     Capabilities: [100] Virtual Channel
     Capabilities: [180] Root Complex Link
     Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 
(rev 03) (prog-if 00 [Normal decode])
     Flags: bus master, fast devsel, latency 0
     Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
     I/O behind bridge: 00005000-00005fff
     Memory behind bridge: d4000000-d5ffffff
     Prefetchable memory behind bridge: 00000000df800000-00000000df8fffff
     Capabilities: [40] Express Root Port (Slot+), MSI 00
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
     Capabilities: [90] Subsystem: Lenovo ThinkPad T61/R61
     Capabilities: [a0] Power Management version 2
     Capabilities: [100] Virtual Channel
     Capabilities: [180] Root Complex Link
     Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 
(rev 03) (prog-if 00 [Normal decode])
     Flags: bus master, fast devsel, latency 0
     Bus: primary=00, secondary=0d, subordinate=14, sec-latency=0
     I/O behind bridge: 00006000-00006fff
     Memory behind bridge: d0000000-d1ffffff
     Prefetchable memory behind bridge: 00000000df500000-00000000df5fffff
     Capabilities: [40] Express Root Port (Slot+), MSI 00
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
     Capabilities: [90] Subsystem: Lenovo ThinkPad T61/R61
     Capabilities: [a0] Power Management version 2
     Capabilities: [100] Virtual Channel
     Capabilities: [180] Root Complex Link
     Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #1 (rev 03) (prog-if 00 [UHCI])
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, medium devsel, latency 0, IRQ 16
     I/O ports at 18a0 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #2 (rev 03) (prog-if 00 [UHCI])
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, medium devsel, latency 0, IRQ 17
     I/O ports at 18c0 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #3 (rev 03) (prog-if 00 [UHCI])
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, medium devsel, latency 0, IRQ 18
     I/O ports at 18e0 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #1 (rev 03) (prog-if 20 [EHCI])
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, medium devsel, latency 0, IRQ 19
     Memory at fe227000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Kernel driver in use: ehci-pci

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) 
(prog-if 01 [Subtractive decode])
     Flags: bus master, fast devsel, latency 0
     Bus: primary=00, secondary=15, subordinate=18, sec-latency=32
     I/O behind bridge: 00007000-0000afff
     Memory behind bridge: f8300000-fbffffff
     Prefetchable memory behind bridge: 00000000f4000000-00000000f7ffffff
     Capabilities: [50] Subsystem: Lenovo ThinkPad T61/R61

00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M-E) LPC Interface 
Controller (rev 03)
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, medium devsel, latency 0
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>
     Kernel driver in use: lpc_ich

00:1f.1 IDE interface: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) IDE 
Controller (rev 03) (prog-if 8a [Master SecP PriP])
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, medium devsel, latency 0, IRQ 16
     I/O ports at 01f0 [size=8]
     I/O ports at 03f4
     I/O ports at 0170 [size=8]
     I/O ports at 0374
     I/O ports at 1c00 [size=16]
     Kernel driver in use: ata_piix

00:1f.2 SATA controller: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) SATA 
Controller [AHCI mode] (rev 03) (prog-if 01 [AHCI 1.0])
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 45
     I/O ports at 1c50 [size=8]
     I/O ports at 1c44 [size=4]
     I/O ports at 1c48 [size=8]
     I/O ports at 1c40 [size=4]
     I/O ports at 1c20 [size=32]
     Memory at fe226000 (32-bit, non-prefetchable) [size=2K]
     Capabilities: [80] MSI: Enable+ Count=1/4 Maskable- 64bit-
     Capabilities: [70] Power Management version 3
     Capabilities: [a8] SATA HBA v1.0
     Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
     Subsystem: Lenovo ThinkPad T61/R61
     Flags: medium devsel, IRQ 23
     Memory at fe227400 (32-bit, non-prefetchable) [size=256]
     I/O ports at 1c60 [size=32]
     Kernel driver in use: i801_smbus

03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] 
Network Connection (rev 02)
     Subsystem: Intel Corporation ThinkPad R60e/X60s
     Flags: bus master, fast devsel, latency 0, IRQ 48
     Memory at df3ff000 (32-bit, non-prefetchable) [size=4K]
     Capabilities: [c8] Power Management version 2
     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
     Capabilities: [e0] Express Legacy Endpoint, MSI 00
     Capabilities: [100] Advanced Error Reporting
     Capabilities: [140] Device Serial Number 00-1c-bf-ff-ff-03-02-87
     Kernel driver in use: iwl3945

15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
     Subsystem: Lenovo ThinkPad R61
     Physical Slot: 1
     Flags: bus master, medium devsel, latency 168, IRQ 16
     Memory at f8300000 (32-bit, non-prefetchable) [size=4K]
     Bus: primary=15, secondary=16, subordinate=17, sec-latency=176
     Memory window 0: f4000000-f7ffffff (prefetchable)
     Memory window 1: c0000000-c3ffffff
     I/O window 0: 00007000-000070ff
     I/O window 1: 00007400-000074ff
     16-bit legacy interface ports at 0001
     Kernel driver in use: yenta_cardbus

15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host 
Adapter (rev 21)
     Subsystem: Lenovo ThinkPad W500
     Physical Slot: 1
     Flags: bus master, medium devsel, latency 64, IRQ 18
     Memory at f8301000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [80] Power Management version 2
     Kernel driver in use: sdhci-pci

15:00.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter 
(rev 11)
     Subsystem: Lenovo ThinkPad T61
     Physical Slot: 1
     Flags: bus master, medium devsel, latency 64, IRQ 18
     Memory at f8301800 (32-bit, non-prefetchable) [size=256]
     Capabilities: [80] Power Management version 2
     Kernel driver in use: r592

15:00.5 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 11)
     Subsystem: Lenovo Device 20cb
     Physical Slot: 1
     Flags: bus master, medium devsel, latency 64, IRQ 18
     Memory at f8301c00 (32-bit, non-prefetchable) [size=256]
     Capabilities: [80] Power Management version 2
     Kernel driver in use: r852


Zdenek
