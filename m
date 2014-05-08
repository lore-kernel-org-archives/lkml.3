Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaEHMt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:49:29 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23463 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaEHMtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:49:24 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-97-536b7d51838b
From: Tomasz Figa <t.figa@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v4 0/3] Generic Device Tree based power domain look-up
Date: Thu, 08 May 2014 14:49:12 +0200
Message-id: <1399553355-6615-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xy7qBtdnBBhO/81psnLGe1WL+kXOs
	Fv1vFrJaNC9ez2bRu+Aqm8XXwysYLWZN2ctksenxNVaLy7vmsFl87j3CaDHj/D4mi9uXeS3e
	/H7BbrH2yF12i6XXLzJZ3D11lM1iwvS1LBZb551jtHi84i27ReveI+wWP850s1i8OtjGYrF+
	xmsWi1W7/jBaHF8b7iDpsWbeGkaPluYeNo/Lfb1MHjtn3WX3WLznJZPHplWdbB53ru1h89g/
	dw27x+Yl9R59W1YxeqxY/Z3d4/MmOY+Nc0MDeKO4bFJSczLLUov07RK4Ms41PGEsWCRVcfn/
	DOYGxs8iXYycHBICJhLd7euYIGwxiQv31rN1MXJxCAksZZSYdmkqE4TTxyRxuvMtK0gVm4Ca
	xOeGR2wgtoiAjMTUK/tZQYqYBfaxS3z7fA3I4eAQFnCT6L5ZAlLDIqAqcfjVQXYQm1fAUeL0
	lPusENvkJP6/XME0gZF7ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQGPmyg3HxMatD
	jAIcjEo8vC+iM4KFWBPLiitzDzFKcDArifBeqcwOFuJNSaysSi3Kjy8qzUktPsTIxMEp1cAY
	Pzs/unPXo9XPJB4LuedOOvgq1axbVWF/k/jmPdMflPLF2Cn328x5GKY59e+q8xnsHOKRt1ok
	rs/yY41YFK7xuP2ivbT+5hRWK1sr0yXFRt+nSDy5a525qNHF8KP6wr+eLVaJl3X/rn+76vSm
	6SqnN1WxlJ+avIHju+zUaZJ/L+gohcScDtZUYinOSDTUYi4qTgQAVmpTvm8CAAA=
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

Changes since v3:
(http://thread.gmane.org/gmane.linux.power-management.general/44571)
 - rebased onto current Rafael's linux-pm bleeding-edge branch (0a112bf),
 - renamed "power-domain" property to "power-domains" to facilitate further
   extension to support multiple power domains per device in future.

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

