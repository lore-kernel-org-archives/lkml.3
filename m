Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaCNCH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:07:57 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9411 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755195AbaCNCHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:07:53 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v5 0/2] Qualcomm Universal Peripheral (QUP) I2C controller
Date: Thu, 13 Mar 2014 19:07:41 -0700
Message-ID: <1394762863-12154-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fifth revision of the QUP I2C driver comes with minor fixes, as per review
comments on the second third revision.

Regards,
Bjorn

Changes from second v3:
 - Reformat device tree binding description related to clocks
 - Minor cleanup related to dt parsing of clock frequency
 - Properly return EINVAL on dt parse error
 - Use i2c_add_adapter instead of numbered version
 - Call pm_runtime_set_active() before we leave probe with clocks enabled
 - Remove debug prints from suspend and resume

Changes from v3:
 - Simplified interrupt handler
 - Corrected the state transition poll timeout
 - Refactored state transition code
 - Refactored the polling functions waiting for transfers to finish
 - Made the write fifo fill function care if there's space
 - Corrected programmed length on writes
 - Made block read and block write work
 - Removed data duplicates from qup_i2c_dev
 - Changed timeout to HZ, to give room for clock stretching
 - Properly reject reads over 256 bytes, as limited by HW
 - Dropped reinitialization of completions
 - Made sure to not re-initiate reads for every block read
 - Added QUP version number to compatible

Changes from v2:
 - Removed unused variables and includes
 - Corrected read logic in irq handler
 - Made the polling loop in qup_i2c_poll_state() less arbitrary
 - Only building suspend/resume if CONFIG_PM_SLEEP

Changes from v1:
 - Cleaned up device tree binding example.
 - Refrased device tree bindings.
 - Following changes in the i2c framework.
 - Use the core clock to calculate divider for the bus clock, instead of
   explicitly setting it.
 - Remove explicit pinctrl settting.
 - Split/renamed qup_i2c_enable(bool) into enable/disable functions.
 - Return value was overwritten on error in write_one/read_one.
 - Initialize the i2c core every time, so that we actually can execute
   more than 1 transmission per xfer.

Bjorn Andersson (1):
  i2c: New bus driver for the Qualcomm QUP I2C controller

Ivan T. Ivanov (1):
  i2c: qup: Add device tree bindings information

 .../devicetree/bindings/i2c/qcom,i2c-qup.txt       |   46 ++
 drivers/i2c/busses/Kconfig                         |   10 +
 drivers/i2c/busses/Makefile                        |    1 +
 drivers/i2c/busses/i2c-qup.c                       |  768 ++++++++++++++++++++
 4 files changed, 825 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
 create mode 100644 drivers/i2c/busses/i2c-qup.c

-- 
1.7.9.5

