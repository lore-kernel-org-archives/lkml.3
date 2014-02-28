Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaB1NAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:00:20 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21417 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaB1NAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:00:18 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-4c-5310885fbb18
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/5] rtc: s5m: Add support for S2MPS14
Date: Fri, 28 Feb 2014 14:00:03 +0100
Message-id: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xq7rxHQLBBq+n6FosuXiV3WLjjPWs
	Fq9fGFqcbXrDbnH/61FGi8u75rBZrD1yl91if2cHo8XpblaLiyu+MFmsn/GaxYHbY8/Ek2we
	d67tYfOYdzLQo2/LKkaP6fN+Mnl83iQXwBbFZZOSmpNZllqkb5fAlXF5bUHBJK6Kw5ua2BsY
	Wzm6GDk5JARMJOYcf88KYYtJXLi3nq2LkYtDSGApo0TrkwlQTh+TxN/OiWBVbALGEpuXLwFL
	iAhcZZSYuGQxO0iCWeA5o8TT7+EgtrCAmcS6dRvYQGwWAVWJB3uPMYPYvALuEovvrGDpYuQA
	WqcgMWeSzQRG7gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQgLqyw7GxcesDjEKcDAq
	8fBO8OQPFmJNLCuuzD3EKMHBrCTC+6RJIFiINyWxsiq1KD++qDQntfgQIxMHp1QD47ycgHTR
	qwsbfJu3fVrr/dB4pbeRqJTQwjTplvb5H0T5f7jkJLAlCof8srCpWvltfdISRq17xxOf7/wx
	4xTrV+/Dt6+aNjAsWKlkMe+B46/sT7ySNRurXh6KFRTcJOOy5HNdu0xxzQWbzqAVvEflCpZP
	bDFe9WqBo2G9luD2b0tq9yl8ljvxXImlOCPRUIu5qDgRAP2YPZ4GAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Few days ago I sent patches adding support for S2MPS14 device to the
sec-core/s2mps11 drivers. These patches were rather large as they covered
multiple subsystems so I decided to split everything into smaller, separate
patches.

The original patchset (version 3) can be found here:
http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27194/focus=1649217

This patchset is a small subset of above related to the S5M RTC driver.
It adds support for the S2MPS14 device.

These patches are rebased against Lee's "for-mfd-next" tree because they require
changes in main MFD sec-core driver ("Add support for S2MPS14 for-mfd-next",
which is already in Lee's "for-mfd-next" tree).


Best regards,
Krzysztof

Krzysztof Kozlowski (5):
  mfd/rtc: sec/s5m: Rename SEC* symbols to S5M
  rtc: s5m: Remove undocumented time init on first boot
  rtc: s5m: Use shorter time of register update
  rtc: s5m: Support different register layout
  rtc: s5m: Add support for S2MPS14 RTC

 drivers/mfd/sec-core.c          |    2 +-
 drivers/rtc/Kconfig             |    4 +-
 drivers/rtc/rtc-s5m.c           |  291 ++++++++++++++++++++++++++-------------
 include/linux/mfd/samsung/rtc.h |   86 +++++++-----
 4 files changed, 249 insertions(+), 134 deletions(-)

-- 
1.7.9.5

