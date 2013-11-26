Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3KZNul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:50:41 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61045 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3KZNuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:50:40 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-8c-5294a72ef07b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/5] rtc: s5m: Bug fixes of the driver after tests
Date: Tue, 26 Nov 2013 14:50:23 +0100
Message-id: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xK7p6y6cEGVzfqGyx5OJVdotnt/Yy
	Wbx+YWhxtukNu8X9r0cZLS7vmsNmsfbIXXaL/Z0djBanu1ktLq74wuTA5bFn4kk2jzvX9rB5
	HDrcwegx72SgR9+WVYwe0+f9ZPL4vEkugD2KyyYlNSezLLVI3y6BK2Pe11VMBQvYK55d+MPe
	wHiTtYuRg0NCwERi99HMLkZOIFNM4sK99WxdjFwcQgJLGSU2LD3LCpIQEuhjkuiaYQViswkY
	S2xevgSsSETgKqPExCWL2UEcZoFdjBJvf+5iBKkSFnCSWLFtF1g3i4CqxJ/m++wgNq+Au8Te
	4/PYIDYrSMyZZDOBkXsBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJCA+rqDcekxq0OM
	AhyMSjy8Ep2Tg4RYE8uKK3MPMUpwMCuJ8MZOnxIkxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVGX
	KV9/2csnKcFezzW8C6K+3bt2k3lnXjhDrYCPQ7fDauM7a5SKohYy7q+a7bix1cYy0HF5ltY/
	/pdzl/ap78r/tCRePOv1Kq7g1Yk5xa+3RM295RtyNfdbwNTwuqkGb4x9Xx7W3vsg07R/vkNB
	BUcHi2b+pFs1deKmr/f4TTJbeuPwa7X5FkosxRmJhlrMRcWJAMYstGAGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a patchset of small but important fixes for rtc-s5m driver. Last
patches also add waking up on RTC alarm interrupts.

The patchset is based on v3.13-rc1-95-gb975dc3 and depends on patch from 
Geert Uytterhoeven:
 - rtc: s5m-rtc: Fix info->rtc assignment
   http://article.gmane.org/gmane.linux.kernel/1595905

Best regards,
Krzysztof

Krzysztof Kozlowski (5):
  rtc: s5m: Fix register updating by adding regmap for RTC
  rtc: s5m: Fix unsuccesful IRQ request during probe
  rtc: s5m: Limit endless loop waiting for register update
  mfd: sec: Add PM ops and make it a wake up source
  rtc: s5m: Enable IRQ wake during suspend

 drivers/mfd/sec-core.c           |   54 +++++++++++++++++++++++++++++
 drivers/rtc/rtc-s5m.c            |   70 +++++++++++++++++++++++++++++++++-----
 include/linux/mfd/samsung/core.h |    1 +
 3 files changed, 116 insertions(+), 9 deletions(-)

-- 
1.7.9.5

