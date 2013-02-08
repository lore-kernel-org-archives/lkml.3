Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab3BHA5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:57:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3BHA5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/34] 3.7.7-stable review
Date: Thu,  7 Feb 2013 16:56:56 -0800
Message-Id: <20130208004627.375461662@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.7.7 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Feb 10 00:43:13 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.7.7-rc1

David Moore <david.moore@gmail.com>
    usb: Prevent dead ports when xhci is not enabled

Alan Stern <stern@rowland.harvard.edu>
    USB: XHCI: fix memory leak of URB-private data

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix TD size for isochronous URBs.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix isoc TD encoding.

Nickolai Zeldovich <nickolai@csail.mit.edu>
    drivers: xhci: fix incorrect bit test

fangxiaozhi <huananhu@huawei.com>
    USB: storage: optimize to match the Huawei USB storage devices and support new switch command

fangxiaozhi <huananhu@huawei.com>
    USB: storage: Define a new macro for USB storage match rules

Lan Tianyu <tianyu.lan@intel.com>
    usb: Using correct way to clear usb3.0 device's remote wakeup feature.

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: fix bug in scheduling periodic split transfers

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: fix timer bug affecting port resume

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: unlink one async QH at a time

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: remove ASS/PSS polling timeout

Daniele Palmas <dnlplm@gmail.com>
    USB: qcserial: add Telit Gobi QDL device

Bjørn Mork <bjorn@mork.no>
    USB: option: add Changhong CH690

Daniele Palmas <dnlplm@gmail.com>
    USB: option: add support for Telit LE920

Sven Killig <sven@killig.de>
    USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II

Petr Kubánek <petr@kubanek.net>
    USB: ftdi_sio: add Zolix FTDI PID

Haojian Zhuang <haojian.zhuang@linaro.org>
    drivers/rtc/rtc-pl031.c: fix the missing operation on enable

Jan Luebbe <jlu@pengutronix.de>
    drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq handler

Tony Lu <zlu@tilera.com>
    mm/hugetlb: set PTE as huge in hugetlb_change_protection and remove_migration_pte

Vyacheslav Dubeyko <slava@dubeyko.com>
    nilfs2: fix fix very long mount time issue

Sergei Shtylyov <sshtylyov@ru.mvista.com>
    mtd: davinci_nand: fix modular build with CONFIG_OF=y

Shawn Bohrer <sbohrer@rgmadvisors.com>
    sched/rt: Use root_domain of rt_rq not current processor

Jan Beulich <JBeulich@suse.com>
    x86-64: Replace left over sti/cli in ia32 audit exit code

liu chuansheng <chuansheng.liu@intel.com>
    drm/radeon: Calling object_unrefer() when creating fb failure

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: prevent crash in the ring space allocation

Mikko Tiihonen <mikko.tiihonen@iki.fi>
    drm/radeon: protect against div by 0 in backend setup

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix backend map setup on 1 RB sumo boards

Christopher Staite <chris@yourdreamnet.co.uk>
    drm/radeon: fix MC blackout on evergreen+

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add quirk for RV100 board

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add WAIT_UNTIL to the non-VM safe regs list for cayman/TN

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/evergreen+: wait for the MC to settle after MC blackout

YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    digsig: Fix memory leakage in digsig_verify_rsa()

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc/mm: Fix hash computation function


-------------

Diffstat:

 Makefile                                |   4 +-
 arch/powerpc/mm/hash_low_64.S           |  62 +++---
 arch/x86/ia32/ia32entry.S               |   4 +-
 drivers/gpu/drm/radeon/evergreen.c      |  27 ++-
 drivers/gpu/drm/radeon/r600.c           |   7 +-
 drivers/gpu/drm/radeon/radeon_combios.c |   8 +
 drivers/gpu/drm/radeon/radeon_display.c |   4 +-
 drivers/gpu/drm/radeon/radeon_ring.c    |   3 +
 drivers/gpu/drm/radeon/reg_srcs/cayman  |   1 +
 drivers/mtd/nand/davinci_nand.c         |   2 +-
 drivers/rtc/rtc-isl1208.c               |   3 +
 drivers/rtc/rtc-pl031.c                 |   8 +-
 drivers/usb/core/hub.c                  |  70 +++++--
 drivers/usb/host/ehci-hub.c             |   6 +-
 drivers/usb/host/ehci-q.c               |  50 +++--
 drivers/usb/host/ehci-sched.c           |   2 +-
 drivers/usb/host/ehci-timer.c           |  29 +--
 drivers/usb/host/pci-quirks.c           |   1 +
 drivers/usb/host/xhci-ring.c            |  13 +-
 drivers/usb/serial/ftdi_sio.c           |   2 +
 drivers/usb/serial/ftdi_sio_ids.h       |   9 +-
 drivers/usb/serial/option.c             |  13 ++
 drivers/usb/serial/qcserial.c           |   1 +
 drivers/usb/storage/initializers.c      |  76 +++++++-
 drivers/usb/storage/initializers.h      |   4 +-
 drivers/usb/storage/unusual_devs.h      | 329 +-------------------------------
 drivers/usb/storage/usb.c               |  12 ++
 drivers/usb/storage/usual-tables.c      |  15 ++
 fs/nilfs2/ioctl.c                       |   5 +-
 include/uapi/linux/usb/ch9.h            |   6 +
 kernel/sched/rt.c                       |   2 +-
 lib/digsig.c                            |   2 +
 mm/hugetlb.c                            |   1 +
 mm/migrate.c                            |   4 +-
 34 files changed, 351 insertions(+), 434 deletions(-)


