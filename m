Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaAQXDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 18:03:51 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9615 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115AbaAQXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 18:03:46 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        James Ralston <james.d.ralston@intel.com>,
        Bill Brown <bill.e.brown@intel.com>,
        Matt Porter <matt.porter@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: [PATCH v3 0/2] Qualcomm Universal Peripheral (QUP) I2C controller
Date: Fri, 17 Jan 2014 15:03:37 -0800
Message-ID: <1389999819-10648-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing on Ivans i2c-qup series.

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

Ivan T. Ivanov (2):
  i2c: qup: Add device tree bindings information
  i2c: New bus driver for the QUP I2C controller

 .../devicetree/bindings/i2c/qcom,i2c-qup.txt       |  41 +
 drivers/i2c/busses/Kconfig                         |  10 +
 drivers/i2c/busses/Makefile                        |   1 +
 drivers/i2c/busses/i2c-qup.c                       | 894 +++++++++++++++++++++
 4 files changed, 946 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
 create mode 100644 drivers/i2c/busses/i2c-qup.c

-- 
1.8.2.2

