Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaHLCBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:01:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28970 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaHLCBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:01:20 -0400
X-AuditID: cbfee61b-f79f86d00000144c-96-53e9756b7b64
From: y@samsung.com
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/5] rtc: s3c: Refactoring s3c-rtc driver and support
 Exynos3250 RTC
Date: Tue, 12 Aug 2014 11:01:06 +0900
Message-id: <1407808871-6046-1-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <y@samsung.com>
References: <y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e+xgG5O6ctgg9sfmSyWXLzKbnH9y3NW
	i94FV9kszja9Ybe4vGsOm8WM8/uYLPZ3djA6sHvsmXiSzaNvyypGj+nzfjJ5fN4kF8ASxWWT
	kpqTWZZapG+XwJVx/vc59oL3HBVXN8xkamD8zdbFyMkhIWAicXBhOzuELSZx4d56oDgXh5DA
	IkaJmxOesIIkhASamCQWHDDpYuTgYBMQlph6QAskLCIgIbFkzh1GkHpmgd2MEpPXvGQBSQgL
	REjcn3wHbAGLgKrEqQenmEB6eQVsJGasUYDYJSfxYc8jsL2cAjISc2avYodYJS1xv7uHZQIj
	7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwYH0THoH46oGi0OMAhyMSjy8M/6+CBZi
	TSwrrsw9xCjBwawkwntM9mWwEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2amp
	BalFMFkmDk6pBkbz4LygvVYzenP5np5t+fLb98Sd5WkPrR4uEbs1Y3EeQxvbKr3QVEG2tDdL
	L1+082Xi8tJa2eHw9VOEHNeplKz61Dbj905XBd//SGsTdZgWt/KjiLT866rt3utPuVmLVd6U
	+Wv/TtxcWqNsdsfaJ6Iqgn+e3si+HxVS9etpWdZ7Ve8lmiEMM5VYijMSDbWYi4oTAfTdmh0g	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

This patchset clean up codes to improve readability as following and support
the RTC of Exynos3250 SoC.
- Remove global variables and then use new s3c_rtc structure
- Remove warn message with checking checkpatch script
- Use variant structure according to SoC type instead of legacy enum variable(s3c_cpu_type)

Changes from v1:
- Fix NULL pointer panic of s3c_rtc_settime()
- Check info->base value to protect NULL pointer panic

Chanwoo Choi (5):
  rtc: s3c: Define s3c_rtc structure to remove global variables.
  rtc: s3c: Remove warning message when checking coding style with checkpatch script
  rtc: s3c: Add s3c_rtc_data structure to use variant data instead of s3c_cpu_type
  rtc: s3c: Add support for RTC of Exynos3250 SoC
  ARM: dts: Fix wrong compatible string of Exynos3250 RTC dt node

 Documentation/devicetree/bindings/rtc/s3c-rtc.txt |   3 +
 arch/arm/boot/dts/exynos3250.dtsi                 |   2 +-
 drivers/rtc/rtc-s3c.c                             | 869 ++++++++++++++--------
 3 files changed, 553 insertions(+), 321 deletions(-)

-- 
1.8.0

