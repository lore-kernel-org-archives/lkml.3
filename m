Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3CEWRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:17:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64689 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3CEWQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:16:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tony Lindgren <tony@atomide.com>, Tony Prisk <linux@prisktech.co.nz>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 0/9] fixes for ARM build regressions in 3.9-rc1
Date: Tue,  5 Mar 2013 23:16:40 +0100
Message-Id: <1362521809-22989-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:mFosls0YXgh/py6l9yhEMpSRJthFNu0fpBaMFk7oACD
 YpFhimMEZ4wb8KN+hluzyoVv7Av5bHHM7gaYJIUkOLR6iWHITR
 KGk7JBt5BA3DwtVqtIGKV1xSqczRJHN5VVOtGjXyo5olfzS6FT
 d7yF84H4k4+Hnzw7BDPM4K1uT/zIEM6ltDVf4Xwu+zSf4/4yNF
 joLuTgyxHbzIEGH4P+ZSvfsmaanIVFL9AcJGT+p7ybrxdGoshu
 xSG3lHncbFf3qI9ZfMEjC4dBWoMqHOid6FqhkH4cKcPw6Bh+B4
 lC59LE5EV2tfa6wGsyeuMF2JDl2VRjbNRG84F+SS+rn9rKao9g
 f4pbWkwrm6VRV/bje+vU6UsWDjWVUHtXOs+K3m9j+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the result of my my build tests on 3.9-rc1, mostly bugs
that I had not caught before the merge window, or where the fix
for some reason has not yet made it in.

I hope the subsystem maintainers can take care of applying these,
for the arch/arm/mach-* patches I can either apply them directly
to the arm-soc tree with an Ack or do a round-trip through
the platform maintainer tree. I think Tony already has some of
the OMAP1 fixes, so we should try not to duplicate them.

	Arnd

Arnd Bergmann (9):
  clk: vt8500: Fix "fix device clock divisor calculations"
  Revert parts of "hlist: drop the node parameter from iterators"
  mfd: remove __exit_p annotation for twl4030_madc_remove
  usb: gadget: fix omap_udc build errors
  ARM: omap1: add back missing includes
  [media] ir-rx51: fix clock API related build issues
  [media] s5p-fimc: fix s5pv210 build
  iommu: OMAP: build only on OMAP2+
  ARM: spear3xx: Use correct pl080 header file

 arch/arm/mach-omap1/board-fsample.c  |  1 +
 arch/arm/mach-omap1/board-h2.c       |  1 +
 arch/arm/mach-omap1/board-perseus2.c |  1 +
 arch/arm/mach-omap1/board-sx1.c      |  1 +
 arch/arm/mach-s5pv210/mach-goni.c    |  2 +-
 arch/arm/mach-spear3xx/spear3xx.c    |  2 +-
 arch/arm/plat-omap/dmtimer.c         | 16 ++++++++--------
 drivers/clk/clk-vt8500.c             |  2 +-
 drivers/iommu/Kconfig                |  2 +-
 drivers/media/rc/ir-rx51.c           |  4 ++--
 drivers/mfd/twl4030-madc.c           |  2 +-
 drivers/usb/gadget/omap_udc.c        |  3 ++-
 drivers/video/omap/lcd_ams_delta.c   |  1 +
 drivers/video/omap/lcd_osk.c         |  1 +
 kernel/smpboot.c                     |  2 +-
 net/9p/trans_virtio.c                |  2 +-
 16 files changed, 25 insertions(+), 18 deletions(-)

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Tony Prisk <linux@prisktech.co.nz>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: iommu@lists.linux-foundation.org
Cc: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org


-- 
1.8.1.2

