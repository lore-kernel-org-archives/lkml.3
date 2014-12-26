Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaLZMfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 07:35:22 -0500
Received: from ring0.de ([5.45.105.125]:36790 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaLZMfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:35:19 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Pali Rohar <pali.rohar@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 0/3] OMAP3 temperature sensor
Date: Fri, 26 Dec 2014 13:34:51 +0100
Message-Id: <1419597294-21487-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141226102933.GA28778@amd>
References: <20141226102933.GA28778@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've prepared an updated variant of the omap34xx temperature monitor driver.
It's based on the N9 driver instead of the N900 driver (and thus has omap36xx
support).

The differences compared to the original driver are:

 * DT based
 * No includes from arch, instead uses syscon DT node + regmap
 * Removed support for raw temperature reading
  - I assume this was used for debugging and regmap can be used
    instead with newer kernels.
 * Introduction of managed resources where possible
 * Usage of module_platform_driver() macro
 * Added some comments referencing the TRM

So far the patchset is _compile-tested only_. I will test it on my N900 in
the next days.

-- Sebastian

Sebastian Reichel (3):
  DT Binding for omap3 temperature sensor
  hwmon: Driver for OMAP3 temperature sensor
  ARM: dts: OMAP34xx/36xx: Add temperature sensor

 .../bindings/hwmon/omap3-temperature.txt           |  25 ++
 arch/arm/boot/dts/omap34xx.dtsi                    |   7 +
 arch/arm/boot/dts/omap36xx.dtsi                    |   7 +
 drivers/hwmon/Kconfig                              |   8 +
 drivers/hwmon/Makefile                             |   1 +
 drivers/hwmon/omap3-temp.c                         | 307 +++++++++++++++++++++
 6 files changed, 355 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/omap3-temperature.txt
 create mode 100644 drivers/hwmon/omap3-temp.c

-- 
2.1.3

