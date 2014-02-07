Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaBGQth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:49:37 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54868 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752711AbaBGQtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:49:35 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: linux-kernel@vger.kernel.org
Cc: sudeep.holla@arm.com
Subject: [PATCH RFC/RFT v2 0/8] drivers: cacheinfo support
Date: Fri,  7 Feb 2014 16:49:15 +0000
Message-Id: <1391791763-28518-1-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

Hi,

This series adds a generic cacheinfo support similar to topology. The
implementation is based on x86 cacheinfo support. Currently x86, powerpc,
ia64 and s390 have their own implementations. While adding similar support
to ARM and ARM64, here is the attempt to make it generic quite similar to
topology info support. It also adds the missing ABI documentation for
the cacheinfo sysfs which is already being used.

It moves all the existing different implementations on x86, ia64, powerpc
and s390 to use the generic cacheinfo infrastructure introduced here.
These changes on non-ARM platforms are only compile tested and hence
the request for testing too.

This series also adds support for ARM and ARM64 architectures based on
the generic support.

Changes v1->v2:
	- Extended the generic cacheinfo support to accomodate all
	  the existing implementations
	- Moved all the existing implementations to use this new
	  generic infrastructure
	- Added missing ABI documentation as suggested by Greg KH
	- Added support for unimplemented CTR on pre-ARMv6 implementations
	  as suggested by Russell. However the ctr_info_list is not yet
	  populated
	- not yet changed to device_attr as suggested by Greg KH,
	  registering cache as device won't eliminate the need of kobject
	  unless each index of cache is registered as a device which don't
	  seem to be good idea, but now it's unified it can be done easily
	  in one place if needed

Sudeep Holla (8):
  drivers: base: support cpu cache information interface to userspace
    via sysfs
  ia64: move cacheinfo sysfs to generic cacheinfo infrastructure
  s390: move cacheinfo sysfs to generic cacheinfo infrastructure
  x86: move cacheinfo sysfs to generic cacheinfo infrastructure
  powerpc: move cacheinfo sysfs to generic cacheinfo infrastructure
  ARM64: kernel: add support for cpu cache information
  ARM: kernel: add support for cpu cache information
  ARM: kernel: add outer cache support for cacheinfo implementation

 Documentation/ABI/testing/sysfs-devices-system-cpu |  40 +
 arch/arm/include/asm/outercache.h                  |  13 +
 arch/arm/kernel/Makefile                           |   1 +
 arch/arm/kernel/cacheinfo.c                        | 248 ++++++
 arch/arm/mm/Kconfig                                |  13 +
 arch/arm/mm/cache-l2x0.c                           |  14 +
 arch/arm/mm/cache-tauros2.c                        |  35 +
 arch/arm/mm/cache-xsc3l2.c                         |  15 +
 arch/arm64/kernel/Makefile                         |   2 +-
 arch/arm64/kernel/cacheinfo.c                      | 134 ++++
 arch/ia64/kernel/topology.c                        | 399 ++--------
 arch/powerpc/kernel/cacheinfo.c                    | 828 +++------------------
 arch/powerpc/kernel/cacheinfo.h                    |   8 -
 arch/powerpc/kernel/sysfs.c                        |   4 -
 arch/s390/include/asm/processor.h                  |   6 -
 arch/s390/kernel/cache.c                           | 380 ++--------
 arch/s390/kernel/processor.c                       |   1 -
 arch/x86/kernel/cpu/intel_cacheinfo.c              | 628 ++++------------
 drivers/base/Makefile                              |   2 +-
 drivers/base/cacheinfo.c                           | 520 +++++++++++++
 include/linux/cacheinfo.h                          |  60 ++
 21 files changed, 1495 insertions(+), 1856 deletions(-)
 create mode 100644 arch/arm/kernel/cacheinfo.c
 create mode 100644 arch/arm64/kernel/cacheinfo.c
 delete mode 100644 arch/powerpc/kernel/cacheinfo.h
 create mode 100644 drivers/base/cacheinfo.c
 create mode 100644 include/linux/cacheinfo.h

-- 
1.8.3.2

