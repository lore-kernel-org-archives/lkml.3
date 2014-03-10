Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaCJSrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:47:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37185 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaCJSrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:47:46 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH v2 0/6] rtc: make the pm8xxx RTC driver usable
Date: Mon, 10 Mar 2014 13:44:43 -0500
Message-Id: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is based on Stephen Boyd's PM8921 modernization/cleanups[1], and
allows for this RTC driver to be usable again.

Changes since v1:
  * Further style cleanups as suggested by Stephen Boyd
  * Dropped the use of reg-names/interrupt-names properties entirely

[1]: http://lkml.kernel.org/g/1393441166-32692-1-git-send-email-sboyd@codeaurora.org

Josh Cartwright (6):
  rtc: pm8xxx: fixup checkpatch/style issues
  rtc: pm8xxx: use regmap API for register accesses
  rtc: pm8xxx: use devm_request_any_context_irq
  rtc: pm8xxx: add support for devicetree
  rtc: pm8xxx: move device_init_wakeup() before rtc_register
  documentation: bindings: document PMIC8921/8058 RTC

 .../devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt    |  21 ++
 drivers/rtc/rtc-pm8xxx.c                           | 284 ++++++++++-----------
 include/linux/mfd/pm8xxx/rtc.h                     |  25 --
 3 files changed, 150 insertions(+), 180 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
 delete mode 100644 include/linux/mfd/pm8xxx/rtc.h

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

