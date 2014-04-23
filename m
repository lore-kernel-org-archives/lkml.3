Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbaDWQrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:47:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9002 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaDWQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:47:27 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-8a-5357ee9cd114
From: Tomasz Figa <t.figa@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 0/3] Generic Device Tree based power domain look-up
Date: Wed, 23 Apr 2014 18:46:55 +0200
Message-id: <1398271618-28932-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xa7pz3oUHG1xcYGixccZ6VoupD5+w
	Wcw/co7Vov/NQlaL5sXr2SzOvVrJaNG74CqbxdfDKxgtZk3Zy2Sx6fE1VovLu+awWXzuPcJo
	MeP8PiaL25d5Ld78fsFusfbIXXaLpdcvMlncPXWUzWLC9LUsFlvnnWO0OHP6EqtF694j7BY/
	znSzWLw62MZisX7GaxaLVbv+MFocXxvuIO2xZt4aRo+W5h42j8t9vUweO2fdZfdYufwLm8fi
	PS+ZPDat6mTzuHNtD5vH/rlr2D02L6n32HK1ncWjb8sqRo8Vq7+ze3zeJOexcW5oAH8Ul01K
	ak5mWWqRvl0CV8bRGbcZC16KV7w9dZW5gfGZUBcjB4eEgInE2clFXYycQKaYxIV769m6GLk4
	hASWMko8/HOTGSQhJNDHJPHqtAyIzSagJvG54REbiC0iICMx9cp+VpAGZoFf7BIP/r5hAkkI
	C7hJTFq5H6yZRUBV4nDjJ7AGXgEniUcfnjNBbJOT+P9yBdMERu4FjAyrGEVTS5MLipPSc430
	ihNzi0vz0vWS83M3MUIi6esOxqXHrA4xCnAwKvHwKtwKDxZiTSwrrsw9xCjBwawkwrtkEVCI
	NyWxsiq1KD++qDQntfgQIxMHp1QD45wV0pfWWrEundxwOpj5QdRLBtfof9n6B0X2xyw5sUVO
	2PyjYp/RA9uV/VW1d/0jduy6vb2i4bm7a2DGX62K4Bf2gTtqNoUlb2Wb7S8a59I7xVQkxebn
	otdPnlyq/1DaYuxzNfDCHWP+xf1HRV5zZP2y4uVY+In/Wbef3VOh08d3nasQ9NIuU2Ipzkg0
	1GIuKk4EAEEgSUSCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up till now there was no single generic method to bind devices to their
power domains using Device Tree. Each platform has been doing this using
its own way, example of which are Exynos power domain bindings [1] and
look-up code [2].

This series is intended to change this and provide generic DT bindings for
power domain specification and generic code performing look-up of power
domains and binding them to devices.

First two patches are the most important part of this series, as they
introduce $subject. Patch 3 converts mach-exynos to use the new generic
method. Further patches are adding one more user of the new code,
mach-s3c64xx, with first 3 patches (4-6) required to clean-up its power
domain driver a bit and last 3 patches (9-11) adding display support for
Mini6410 board, including a node for display controller (FIMD) which is
a power domain consumer.

The design of DT bindings and provider code is heavily inspired by
implementation of clock providers in Common Clock Framework, while
the code binding devices to power domains by my Exynos power domain
implementation (now removed by this series ;)).

Successfully tested on Exynos4210-based Trats and Exynos4412-based Trats2
boards using MFC, 

[1] Documentation/devicetree/bindings/arm/exynos/power_domain.txt
[2] arch/arm/mach-exynos/pm_domains.c

Changes since v2:
(http://thread.gmane.org/gmane.linux.kernel/1658926)
 - rebased onto current Rafael's linux-pm bleeding-edge branch,
 - dropped patches for s3c64xx for now. I will send them in separate series,
 - do not call pm_genpd_dev_need_restore(true) in genpd_bind_domain(),
 - fixed various stylistic issues reported in review comments.

Changes since v1 (RFC):
[https://lkml.org/lkml/2014/1/11/141]
 - rebased onto current Rafael's linux-pm bleeding-edge branch,
 - reordered the patches a bit (to have the generic ones first),
 - dropped renaming of S3C64xx power domains (as suggested by Mark Brown),
 - added support for deferred probing (as suggested by Stephen Boyd),
 - fixed several minor issues pointed by Stephen Boyd,
 - replaced notifiers with direct hooks in driver core to make power domain
   support independent from specific bus type and allow error handling.

Tomasz Figa (3):
  base: power: Add generic OF-based power domain look-up
  drivercore: Bind/unbind power domain on probe/remove
  ARM: exynos: Move to generic power domain bindings

 .../bindings/arm/exynos/power_domain.txt           |  12 +-
 .../devicetree/bindings/power/power_domain.txt     |  51 ++++
 arch/arm/mach-exynos/pm_domains.c                  |  81 +-----
 drivers/base/dd.c                                  |   9 +-
 drivers/base/power/domain.c                        | 283 +++++++++++++++++++++
 include/linux/pm_domain.h                          |  46 ++++
 kernel/power/Kconfig                               |   4 +
 7 files changed, 398 insertions(+), 88 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/power_domain.txt

-- 
1.9.2

