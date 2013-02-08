Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945972Ab3BHBDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:03:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422687Ab3BHA6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/16] 3.0.63-stable review
Date: Thu,  7 Feb 2013 16:57:59 -0800
Message-Id: <20130208004627.112511141@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.63 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Feb 10 00:43:19 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.63-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.63-rc1

Alan Stern <stern@rowland.harvard.edu>
    USB: XHCI: fix memory leak of URB-private data

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix isoc TD encoding.

fangxiaozhi <huananhu@huawei.com>
    USB: storage: optimize to match the Huawei USB storage devices and support new switch command

fangxiaozhi <huananhu@huawei.com>
    USB: storage: Define a new macro for USB storage match rules

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: fix bug in scheduling periodic split transfers

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

Jan Luebbe <jlu@pengutronix.de>
    drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq handler

Vyacheslav Dubeyko <slava@dubeyko.com>
    nilfs2: fix fix very long mount time issue

Jan Beulich <JBeulich@suse.com>
    x86-64: Replace left over sti/cli in ia32 audit exit code

liu chuansheng <chuansheng.liu@intel.com>
    drm/radeon: Calling object_unrefer() when creating fb failure

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add quirk for RV100 board

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/evergreen+: wait for the MC to settle after MC blackout


-------------

Diffstat:

 Makefile                                |   4 +-
 arch/x86/ia32/ia32entry.S               |   4 +-
 drivers/gpu/drm/radeon/evergreen.c      |   2 +
 drivers/gpu/drm/radeon/radeon_combios.c |   8 +
 drivers/gpu/drm/radeon/radeon_display.c |   4 +-
 drivers/rtc/rtc-isl1208.c               |   3 +
 drivers/usb/host/ehci-sched.c           |   2 +-
 drivers/usb/host/xhci-ring.c            |   6 +-
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
 18 files changed, 159 insertions(+), 340 deletions(-)


