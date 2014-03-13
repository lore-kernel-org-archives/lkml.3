Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaCMISG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:18:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24177 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaCMIR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:17:56 -0400
X-AuditID: cbfee68f-b7f156d00000276c-0e-5321699bdf27
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/8] devfreq: exynos4: Support dt and use common ppmu driver
Date: Thu, 13 Mar 2014 17:17:21 +0900
Message-id: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWyRsSkSHd2pmKwwc+XrBYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MqY+syyoI2v4uSaDvYGxjncXYycHBICJhK3F15mh7DFJC7c
	W88GYgsJLGWUeDY3CaZmx8ITjF2MXEDx6YwS73/2MEE4jUwSO6d/YgapYhPQktj/4gZYt4iA
	ucSupT/ZQIqYBZ4xSdzq72MCSQgL+Em0vp8NVsQioCrR8QxkLCcHr4CrxKyeu6wQ6+QkPux5
	xA7SLCFwiV3i3uezTBANAhLfJh9i6WLkAErISmw6wAxRLylxcMUNlgmMggsYGVYxiqYWJBcU
	J6UXGesVJ+YWl+al6yXn525iBMbI6X/P+ncw3j1gfYgxGWjcRGYp0eR8YIzllcQbGpsZWZia
	mBobmVuakSasJM57/2FSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGqo9r7rT9yww81X5p
	yn9u8RemR39uenFe2upjz/W994+wPAgpcexqW9y0//GkgKKTzf+2qtbbhEwVEZKSchXIK12p
	Gb7ao8yio/Ppo/MdEubppko/9/5dlPzKjTXDyKKCb5vCPa5D8tXbrHaeqX4Trd09Q9t7WXHY
	zXbWxKwawRMXdrD7yVxSYinOSDTUYi4qTgQAu/XUgKcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jQd1ZmYrBBg3LrCw6en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY+ozy4I2voqTazrY
	GxjncHcxcnJICJhI7Fh4ghHCFpO4cG89WxcjF4eQwHRGifc/e5ggnEYmiZ3TPzGDVLEJaEns
	f3GDDcQWETCX2LX0J1gHs8AzJolb/X1MIAlhAT+J1vezwYpYBFQlOp5BrOAVcJWY1XOXFWKd
	nMSHPY/YJzByL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHIPPpHcwrmqwOMQowMGo
	xMO7YrlCsBBrYllxZe4hRgkOZiURXk8fxWAh3pTEyqrUovz4otKc1OJDjMlA2ycyS4km5wPT
	Q15JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MCarFwnN8+NK
	fHCQ/fSFx1Fxu0ytn31kMVpQF3LgQEfFhy/ycXvrbRZ9br35WHOp/JX9Nyx3SZftLv85d8eR
	pqczbFb9Ez5/qa1pXmCDd5a3z+4tp3uYvr+uOrIkYO3JAg7xhkXCXGd3n4g/XdYffmUh4+lr
	2U8LMuY1bXR+LfTV2O/Q3pDp/+SUWIozEg21mIuKEwEUG9kEBQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support devicetree and use common ppmu driver instead of
individual code of exynos4_bus.c to remove duplicate code. Also this patchset
get the resources for busfreq from dt data by using DT helper function.
- PPMU register address
- PPMU clock
- Regulator for INT/MIF block

This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
To remove power-leakage in suspend state, before entering suspend state,
disable ppmu clocks.

Changes from v1:
- Add exynos4_bus.txt documentation for devicetree guide
- Fix probe failure if CONFIG_PM_OPP is disabled
- Fix typo and resource leak(regulator/clock/memory) when happening probe failure
- Add additionally comment for PPMU usage instead of previous PPC
- Split separate patch to remove ambiguous of patch

Chanwoo Choi (8):
  devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
  devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
  devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
  devfreq: exynos4: Fix bug of resource leak and code clean on probe()
  devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
  devfreq: exynos4: Fix power-leakage of clock on suspend state
  devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
  devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12

 .../devicetree/bindings/devfreq/exynos4_bus.txt    |  49 +++
 drivers/devfreq/Kconfig                            |   1 +
 drivers/devfreq/exynos/Makefile                    |   2 +-
 drivers/devfreq/exynos/exynos4_bus.c               | 415 ++++++++++++++-------
 4 files changed, 341 insertions(+), 126 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt

-- 
1.8.0

