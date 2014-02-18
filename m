Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaBRXOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:14:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaBRWqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/26] 3.10.31-stable review
Date: Tue, 18 Feb 2014 14:46:56 -0800
Message-Id: <20140218224530.398913499@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.31 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 20 22:45:20 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.31-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.31-rc1

Xishi Qiu <qiuxishi@huawei.com>
    mm: fix process accidentally killed by mce because of huge page migration

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Take core C0 time into account for core busy calculation

Jan Kara <jack@suse.cz>
    IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm/memory-failure.c: fix memory leak in successful soft offlining

Stanislaw Gruszka <sgruszka@redhat.com>
    pinctrl: protect pinctrl_list add

Tony Prisk <linux@prisktech.co.nz>
    pinctrl: vt8500: Change devicetree data parsing

Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
    x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y

Dave Jones <davej@fedoraproject.org>
    mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

Antti Palosaari <crope@iki.fi>
    af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2

Mel Gorman <mgorman@suse.de>
    x86: mm: change tlb_flushall_shift for IvyBridge

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of spin_lock_irq()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add missing mixer widget for AD1983

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix missing VREF setup for Mac Pro 1,1

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add missing kconfig dependecy

Vinayak Kale <vkale@apm.com>
    arm64: add DSB after icache flush in __flush_icache_all()

Nathan Lynch <nathan_lynch@mentor.com>
    arm64: vdso: fix coarse clock handling

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Invalidate the TLB when replacing pmd entries during boot

Will Deacon <will.deacon@arm.com>
    arm64: vdso: prevent ld from aligning PT_LOAD segments to 64k

Nathan Lynch <nathan_lynch@mentor.com>
    arm64: vdso: update wtm fields for CLOCK_MONOTONIC_COARSE

Lior Amsalem <alior@marvell.com>
    irqchip: armada-370-xp: fix IPI race condition

Harald Freudenberger <freude@linux.vnet.ibm.com>
    crypto: s390 - fix des and des3_ede ctr concurrency issue

Harald Freudenberger <freude@linux.vnet.ibm.com>
    crypto: s390 - fix des and des3_ede cbc concurrency issue

Harald Freudenberger <freude@linux.vnet.ibm.com>
    crypto: s390 - fix concurrency issue in aes-ctr mode

Josef Bacik <jbacik@fb.com>
    Btrfs: disable snapshot aware defrag for now

Stephen Smalley <sds@tycho.nsa.gov>
    SELinux: Fix kernel BUG on empty security contexts.


-------------

Diffstat:

 Makefile                                      |  4 +-
 arch/arm64/include/asm/cacheflush.h           |  1 +
 arch/arm64/kernel/vdso.c                      |  4 +-
 arch/arm64/kernel/vdso/Makefile               |  2 +-
 arch/arm64/kernel/vdso/gettimeofday.S         |  7 +-
 arch/arm64/mm/mmu.c                           | 12 +++-
 arch/s390/crypto/aes_s390.c                   | 65 ++++++++++++------
 arch/s390/crypto/des_s390.c                   | 95 +++++++++++++++++----------
 arch/x86/kernel/cpu/intel.c                   |  2 +-
 drivers/cpufreq/intel_pstate.c                | 16 +++--
 drivers/infiniband/hw/qib/qib_user_sdma.c     |  6 +-
 drivers/irqchip/irq-armada-370-xp.c           |  2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c         |  2 +
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h |  2 +-
 drivers/pinctrl/core.c                        |  2 +
 drivers/pinctrl/vt8500/pinctrl-wmt.c          | 15 ++++-
 fs/btrfs/inode.c                              |  2 +-
 fs/buffer.c                                   |  6 +-
 lib/Makefile                                  |  1 +
 mm/hugetlb.c                                  | 11 +++-
 mm/memory-failure.c                           | 22 +++++--
 mm/page-writeback.c                           |  5 +-
 security/selinux/ss/services.c                |  4 ++
 sound/pci/hda/patch_analog.c                  |  1 +
 sound/pci/hda/patch_realtek.c                 |  9 ++-
 sound/usb/Kconfig                             |  1 +
 26 files changed, 214 insertions(+), 85 deletions(-)


