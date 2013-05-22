Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab3EVWRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:17:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab3EVWKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/21] 3.9.4-stable review
Date: Wed, 22 May 2013 15:10:18 -0700
Message-Id: <20130522205232.597066680@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.9.4 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri May 24 20:50:18 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.9.4-rc1

Alexander van Heukelum <heukelum@fastmail.fm>
    x86, vm86: fix VM86 syscalls: use SYSCALL_DEFINEx(...)

Jon Mason <jon.mason@intel.com>
    NTB: Multiple NTB client fix

Jon Mason <jon.mason@intel.com>
    ntb_netdev: remove from list on exit

Jon Mason <jon.mason@intel.com>
    NTB: memcpy lockup workaround

Jon Mason <jon.mason@intel.com>
    NTB: Correctly handle receive buffers of the minimal size

Jon Mason <jon.mason@intel.com>
    NTB: reset tx_index on link toggle

Jon Mason <jon.mason@intel.com>
    NTB: Link toggle memory leak

Jon Mason <jon.mason@intel.com>
    NTB: Handle 64bit BAR sizes

Dan Carpenter <dan.carpenter@oracle.com>
    NTB: fix pointer math issues

Dan Carpenter <dan.carpenter@oracle.com>
    ntb: off by one sanity checks

Jon Mason <jon.mason@intel.com>
    NTB: variable dereferenced before check

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: fix uapi header

Niels Ole Salscheider <niels_ole@salscheider-online.de>
    drm/radeon: Fix VRAM size calculation for VRAM >= 4GB

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/bios: fix thinko in ZM_MASK_ADD opcode

Linus Torvalds <torvalds@linux-foundation.org>
    x86: Fix bit corruption at CPU resume time

Mika Westerberg <mika.westerberg@linux.intel.com>
    i2c: designware: always clear interrupts before enabling them

Josef Ahmad <josef.ahmad@linux.intel.com>
    i2c: designware: fix RX FIFO overrun

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    hwmon: fix error return code in abituguru_probe()

Gabriel de Perthuis <g2p.code@gmail.com>
    btrfs: don't stop searching after encountering the wrong item

Sukanto Ghosh <sghosh@apm.com>
    arm64: mm: Fix operands of clz in __flush_dcache_all

Will Deacon <will.deacon@arm.com>
    arm64: debug: clear mdscr_el1 instead of taking the OS lock


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arm64/kernel/debug-monitors.c              |   2 -
 arch/arm64/mm/cache.S                           |   2 +-
 arch/arm64/mm/proc.S                            |   3 +-
 arch/x86/include/asm/syscalls.h                 |   4 +-
 arch/x86/kernel/head64.c                        |   2 +-
 arch/x86/kernel/vm86_32.c                       |  11 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c |   4 +-
 drivers/gpu/drm/radeon/evergreen.c              |   4 +-
 drivers/gpu/drm/radeon/radeon_ttm.c             |   2 +-
 drivers/gpu/drm/radeon/si.c                     |   4 +-
 drivers/hwmon/abituguru.c                       |  16 ++-
 drivers/i2c/busses/i2c-designware-core.c        |  14 +-
 drivers/i2c/busses/i2c-designware-core.h        |   2 +
 drivers/net/ntb_netdev.c                        |   2 +
 drivers/ntb/ntb_hw.c                            |  10 +-
 drivers/ntb/ntb_transport.c                     | 175 +++++++++++++++---------
 fs/btrfs/ioctl.c                                |  10 +-
 include/uapi/linux/virtio_console.h             |   2 +-
 19 files changed, 171 insertions(+), 102 deletions(-)


