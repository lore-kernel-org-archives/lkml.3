Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab3BMA1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:27:02 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:46746 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab3BMA1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:27:00 -0500
Message-ID: <1360715210.31472.20.camel@thor.lan>
Subject: [Bisected][-next-20130204+] [x86/kvm] udevd:[97]: segfault at
 ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
From: Peter Hurley <peter@hurleysoftware.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 12 Feb 2013 19:26:50 -0500
Content-Type: multipart/mixed; boundary="=-t2s0D1tEiFObez2tajcV"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t2s0D1tEiFObez2tajcV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

With -next-20130204+ in ubuntu 12.10 VM (so the 80x25 VGA
device/console):

[    0.666410] udevd[97]: starting version 175
[    0.674043] udevd[97]: udevd:[97]: segfault at ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d

and boots to an initramfs prompt.

git bisect (log attached) blames:

commit 7b5c4a65cc27f017c170b025f8d6d75dabb11c6f
Merge: 3596f5b 949db15
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Fri Jan 25 16:31:21 2013 -0800

    Merge tag 'v3.8-rc5' into x86/mm
    
    The __pa() fixup series that follows touches KVM code that is not
    present in the existing branch based on v3.7-rc5, so merge in the
    current upstream from Linus.
    
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>


This only happens with the VGA device/console but that is the default
configuration for Ubuntu/KVM because it blacklists pretty much every fb
driver.

I can confirm this _does not_ happen with same config on mainline
3.8-rc7.
Just confirmed that the same fault occurs with next-20130211.

Regards,
Peter Hurley

--=-t2s0D1tEiFObez2tajcV
Content-Disposition: attachment; filename="segfault_bisect.log"
Content-Type: text/x-log; name="segfault_bisect.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

git bisect start
# good: [6bacaa9ddacb71c691d32c678d37bc59ffc71fac] Merge tag 'sound-3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good 6bacaa9ddacb71c691d32c678d37bc59ffc71fac
# bad: [164708bec016c6ceb76a2bb2e29b086bf0ad4e37] Add linux-next specific files for 20130204
git bisect bad 164708bec016c6ceb76a2bb2e29b086bf0ad4e37
# good: [0231bb5336758426b44ccd798ccd3c5419c95d58] perf: Fix event group context move
git bisect good 0231bb5336758426b44ccd798ccd3c5419c95d58
# good: [0ba3b2ccc72b3df5c305d61f59d93ab0f0e87991] USB: ftdi_sio: add Zolix FTDI PID
git bisect good 0ba3b2ccc72b3df5c305d61f59d93ab0f0e87991
# good: [8b31849a113a8868eb2de692be5c9ecadae93ac9] Merge git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
git bisect good 8b31849a113a8868eb2de692be5c9ecadae93ac9
# good: [972f7c832229781f09f03284cde484ccdb44d3ee] x86, doc: Boot protocol 2.12 is in 3.8
git bisect good 972f7c832229781f09f03284cde484ccdb44d3ee
# good: [da57b936ea7b328d1009b37a0a0ad1f14148e104] xtensa: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
git bisect good da57b936ea7b328d1009b37a0a0ad1f14148e104
# good: [1927661b1748480692f1fa2c390fe031c86d862a] ASoC: fsl: fix snd-soc-imx-pcm module build
git bisect good 1927661b1748480692f1fa2c390fe031c86d862a
# good: [cff3c124a7e82ca0ea1d6864b27ef18c403c0773] sched/debug: Fix format string for 32-bit platforms
git bisect good cff3c124a7e82ca0ea1d6864b27ef18c403c0773
# good: [ce4a3d52888a95473914bd54bcf6c566014fc03e] [media] radio: set vfl_dir correctly to fix modulator regression
git bisect good ce4a3d52888a95473914bd54bcf6c566014fc03e
# good: [d36b7b9643faca8aab8cee8d824f75c800b337ac] Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/urgent
git bisect good d36b7b9643faca8aab8cee8d824f75c800b337ac
# good: [0ce82b7f7b7373b16ecf7b5725e21e2975204500] mtd: nand: onfi don't WARN if we are in 16 bits mode
git bisect good 0ce82b7f7b7373b16ecf7b5725e21e2975204500
# good: [58c49df378cde4ff64172483d593a1a5689c13a8] mtip32xx: fix for crash when the device surprise removed during rebuild
git bisect good 58c49df378cde4ff64172483d593a1a5689c13a8
# good: [11f6d5d6564613befc240ebf9620c80fabe74c1a] Merge remote-tracking branch 'spi-mb/spi-next'
git bisect good 11f6d5d6564613befc240ebf9620c80fabe74c1a
# bad: [df3de4831a52f71e3f5ce3ca67de885f9bcf6fed] Merge remote-tracking branch 'driver-core/driver-core-next'
git bisect bad df3de4831a52f71e3f5ce3ca67de885f9bcf6fed
# good: [ce68648792ba859fe11075f507909970ae5e1ba4] kvm tools: remove unused field from virtio-blk
git bisect good ce68648792ba859fe11075f507909970ae5e1ba4
# bad: [81f3c277544d5359e4bf3fdfd2c4495a288d67ff] Merge remote-tracking branch 'fw-nohz/nohz/next'
git bisect bad 81f3c277544d5359e4bf3fdfd2c4495a288d67ff
# good: [0e04f53a4310c2376a40a3eaf4cd74822534b7c2] Merge branch 'x86/microcode'
git bisect good 0e04f53a4310c2376a40a3eaf4cd74822534b7c2
# bad: [e761e0bbb991c0a0eaf59b5d61feebf3185f58bd] Merge remote-tracking branch 'rcu/rcu/next'
git bisect bad e761e0bbb991c0a0eaf59b5d61feebf3185f58bd
# good: [38dbe0b137bfe6ea92be495017885c0785179a02] tracing: Remove second iterator initializer
git bisect good 38dbe0b137bfe6ea92be495017885c0785179a02
# bad: [152aa0e8ad77111b82ebe655c559b58f5dec0981] Merge remote-tracking branch 'tip/auto-latest'
git bisect bad 152aa0e8ad77111b82ebe655c559b58f5dec0981
# bad: [5dfd486c4750c9278c63fa96e6e85bdd2fb58e9d] x86, kvm: Fix kvm's use of __pa() on percpu areas
git bisect bad 5dfd486c4750c9278c63fa96e6e85bdd2fb58e9d
# good: [6a3956bd242926f8956992f6ed7805b0811be003] x86/lguest: Use __pa_symbol instead of __pa on C visible symbols
git bisect good 6a3956bd242926f8956992f6ed7805b0811be003
# bad: [7b5c4a65cc27f017c170b025f8d6d75dabb11c6f] Merge tag 'v3.8-rc5' into x86/mm
git bisect bad 7b5c4a65cc27f017c170b025f8d6d75dabb11c6f
# good: [5e4bf1a55da976a5ed60901bb8801f1024ef9774] x86/mm: Don't flush the TLB on #WP pmd fixups
git bisect good 5e4bf1a55da976a5ed60901bb8801f1024ef9774
# good: [3596f5bb0a6afd01a784bfe120f420edbbf82861] Merge branch 'x86/mm' of ssh://ra.kernel.org/pub/scm/linux/kernel/git/tip/tip into x86/mm
git bisect good 3596f5bb0a6afd01a784bfe120f420edbbf82861

--=-t2s0D1tEiFObez2tajcV--

