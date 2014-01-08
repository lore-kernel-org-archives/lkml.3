Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbaAHT1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:27:33 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54431 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750839AbaAHT13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:27:29 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: x86@kernel.org, linuxppc-dev@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: sudeep.holla@arm.com, Ashok Raj <ashok.raj@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH RFC 0/3] drivers: cacheinfo support
Date: Wed,  8 Jan 2014 19:26:05 +0000
Message-Id: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

Hi,

This series adds a generic cacheinfo support similar to topology. The
implementation is based on x86 cacheinfo support. Currently x86 and
powerpc have their own implementations. While adding similar support
to ARM, here is the attempt to make it generic quite similar to topology
info support.

This series also adds support for ARM architecture based on the generic
support. ARM uses device tree for cache hierarcy as there is no 
architectural way of getting it. On non-DT platforms, first level caches
are per-cpu while higher level caches are assumed system-wide.

I can move the x86 and powerpc implementations to use this generic one
based on the feedback. However I have few open questions:

1. Do we need to populate cache data on hotplug path or just once
   during the boot on all cpus will suffice ? Hotplug path seems more
   appropriate for me but based on my understanding(I may be wrong here)
   of x86 code, I placed it in boot patch for now. I can change it.

2. I see some custom/arch specific sysfs entries(e.g. AMD L3 cache
   partitioning feature). How do we deal with that ?

I had posted previous version[1] without generic implementation(ARM 
specific)

Regards,
Sudeep

[1] https://lkml.org/lkml/2013/9/18/340

Sudeep Holla (3):
  drivers: base: support cpu cache information interface to userspace
    via sysfs
  ARM: kernel: add support for cpu cache information
  ARM: kernel: add outer cache support for cacheinfo implementation

 arch/arm/include/asm/cacheinfo.h  |   7 +
 arch/arm/include/asm/outercache.h |  13 ++
 arch/arm/kernel/Makefile          |   1 +
 arch/arm/kernel/cacheinfo.c       | 438 ++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c           |   2 +
 arch/arm/mm/Kconfig               |  13 ++
 arch/arm/mm/cache-l2x0.c          |  14 ++
 arch/arm/mm/cache-tauros2.c       |  35 +++
 arch/arm/mm/cache-xsc3l2.c        |  15 ++
 drivers/base/Makefile             |   2 +-
 drivers/base/cacheinfo.c          | 296 ++++++++++++++++++++++++++
 include/linux/cacheinfo.h         |  43 ++++
 12 files changed, 878 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/asm/cacheinfo.h
 create mode 100644 arch/arm/kernel/cacheinfo.c
 create mode 100644 drivers/base/cacheinfo.c
 create mode 100644 include/linux/cacheinfo.h

-- 
1.8.3.2

