Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaBRXFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:05:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaBRWq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.12 00/32] 3.12.12-stable review
Date: Tue, 18 Feb 2014 14:47:00 -0800
Message-Id: <20140218224500.101465031@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.12 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 20 22:44:47 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.12-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.12.12-rc1

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Take core C0 time into account for core busy calculation

Stanislaw Gruszka <sgruszka@redhat.com>
    pinctrl: protect pinctrl_list add

Tony Prisk <linux@prisktech.co.nz>
    pinctrl: vt8500: Change devicetree data parsing

Nicolas Ferre <nicolas.ferre@atmel.com>
    pinctrl: at91: use locked variant of irq_set_handler

Nitin A Kamble <nitin.a.kamble@intel.com>
    genirq: Generic irq chip requires IRQ_DOMAIN

Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
    x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y

Hans Verkuil <hverkuil@xs4all.nl>
    Revert "[media] videobuf_vm_{open,close} race fixes"

Dave Jones <davej@fedoraproject.org>
    mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

Dave Jones <davej@fedoraproject.org>
    mxl111sf: Fix unintentional garbage stack read

Antti Palosaari <crope@iki.fi>
    af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2

Mel Gorman <mgorman@suse.de>
    x86: mm: change tlb_flushall_shift for IvyBridge

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of spin_lock_irq()

Weijie Yang <weijie.yang@samsung.com>
    mm/swap: fix race on swap_info reuse between swapoff and swapon

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Improve loopback path lookups for AD1983

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add missing mixer widget for AD1983

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix silent output on Toshiba Satellite L40

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

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix memory corruption in nfs4_proc_open_confirm

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4.1: nfs4_destroy_session must call rpc_destroy_waitqueue

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
 drivers/irqchip/irq-armada-370-xp.c           |  2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c         |  2 +
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |  2 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c | 12 ++--
 drivers/media/v4l2-core/videobuf-dma-sg.c     | 10 ++-
 drivers/media/v4l2-core/videobuf-vmalloc.c    | 10 ++-
 drivers/pinctrl/core.c                        |  2 +
 drivers/pinctrl/pinctrl-at91.c                | 10 +--
 drivers/pinctrl/vt8500/pinctrl-wmt.c          | 15 ++++-
 fs/btrfs/inode.c                              |  2 +-
 fs/buffer.c                                   |  6 +-
 fs/nfs/nfs4client.c                           |  2 +-
 fs/nfs/nfs4proc.c                             |  8 +--
 fs/nfs/nfs4session.c                          | 25 +++++--
 fs/nfs/nfs4session.h                          |  2 +-
 include/linux/nfs_xdr.h                       |  2 +
 kernel/irq/Kconfig                            |  1 +
 lib/Makefile                                  |  1 +
 mm/page-writeback.c                           |  5 +-
 mm/swapfile.c                                 | 11 +++-
 security/selinux/ss/services.c                |  4 ++
 sound/pci/hda/patch_analog.c                  | 27 ++++++++
 sound/pci/hda/patch_realtek.c                 |  9 ++-
 sound/usb/Kconfig                             |  1 +
 35 files changed, 270 insertions(+), 111 deletions(-)


