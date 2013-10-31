Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3JaLJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:09:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65255 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3JaLJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:09:33 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, dri-devel@lists.freedesktop.org,
        iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-mips@linux-mips.org,
        linux-watchdog@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, John Crispin <blogic@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>, Rob Landley <rob@landley.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 0/5] Remove remaining instances of devm_request_and_ioremap
Date: Thu, 31 Oct 2013 16:38:02 +0530
Message-Id: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_request_and_ioremap is now obsolete and is replaced by
devm_ioremap_resource. Update the remaining places where
devm_request_and_ioremap is still used and remove its definition.

The patches are based on next-20131030.

Tushar Behera (5):
  MIPS: ralink: Use devm_ioremap_resource
  DRM: Armada: Use devm_ioremap_resource
  iommu/arm-smmu: Use devm_ioremap_resource
  watchdog: ralink: Use devm_ioremap_resource
  lib: devres: Remove deprecated devm_request_and_ioremap

 Documentation/driver-model/devres.txt |    1 -
 arch/mips/ralink/timer.c              |    2 +-
 drivers/gpu/drm/armada/armada_crtc.c  |    8 +++-----
 drivers/iommu/arm-smmu.c              |    6 +++---
 drivers/watchdog/rt2880_wdt.c         |    2 +-
 include/linux/device.h                |    2 --
 lib/devres.c                          |   28 ----------------------------
 7 files changed, 8 insertions(+), 41 deletions(-)

CC: dri-devel@lists.freedesktop.org
CC: iommu@lists.linux-foundation.org
CC: linux-arm-kernel@lists.infradead.org
CC: linux-doc@vger.kernel.org
CC: linux-mips@linux-mips.org
CC: linux-watchdog@vger.kernel.org
CC: David Airlie <airlied@linux.ie>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Joerg Roedel <joro@8bytes.org>
CC: John Crispin <blogic@openwrt.org>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Rob Landley <rob@landley.net>
CC: Russell King <rmk+kernel@arm.linux.org.uk>
CC: Will Deacon <will.deacon@arm.com>
CC: Wim Van Sebroeck <wim@iguana.be>

-- 
1.7.9.5

