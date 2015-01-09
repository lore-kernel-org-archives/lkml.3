Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbbAIR5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:57:03 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:33276 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbAIR47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:56:59 -0500
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        James Hartley <james.hartley@imgtec.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, <vladimir_zapolskiy@mentor.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>
Subject: [PATCH v8 0/2] Imagination Technologies PWM support
Date: Fri, 9 Jan 2015 14:54:46 -0300
Message-ID: <1420826088-13113-1-git-send-email-ezequiel.garcia@imgtec.com>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.100.200.183]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new round for the IMG PWM driver.

The IMG PWM controller is muxed with a PDM controller, through a shared
so-called periph register bit, which sets the output as PWM or PDM.
Because this register is not part of the pin controller block, but rather
PWM/PDM specific, and because the register is also used to set the PDM value,
it is simpler to use a regmap-based syscon to deal with it.

This time, I'm removing the PDM driver from the submission and submitting the PWM
alone. The PDM was written as a misc driver, but had some design issues, so for
now I'm proposing to merge the PWM only.

The series is based on v3.19-rc3. If at all possible I'd like to see this merged
for v3.20.

Comments welcome!

Naidu Tellapati (2):
  pwm: Imagination Technologies PWM DAC driver
  DT: pwm: Add binding document for IMG PWM DAC

 Documentation/devicetree/bindings/pwm/img-pwm.txt |  24 +++
 drivers/pwm/Kconfig                               |  13 ++
 drivers/pwm/Makefile                              |   1 +
 drivers/pwm/pwm-img.c                             | 250 ++++++++++++++++++++++
 4 files changed, 288 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/img-pwm.txt
 create mode 100644 drivers/pwm/pwm-img.c

-- 
2.2.1

