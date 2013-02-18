Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab3BRGu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:50:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41078 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078Ab3BRGus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:50:48 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/4] regulator: core: support shared enable GPIO
Thread-Topic: [PATCH v3 0/4] regulator: core: support shared enable GPIO
Thread-Index: Ac4NpD3H31kdvjSMT5++YJ+JS02KMg==
Date: Mon, 18 Feb 2013 06:50:30 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F792729E9@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Regulator can be enabled by external GPIO pin which is configurable in the
regulator_config.
At this moment, the GPIO can be owned by only one regulator device.
In some devices like LP8788 LDOs, multiple regulators are enabled by shared
one GPIO pin.
This patch-set enables shared enable GPIO concept and fix LP8788 LDO driver
as well.

Patches were generated based on 'for-next' of regulator.git
(git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git)

 Patch v3.
 a) Add a reference count, 'request_count' which makes sure only free the GPIO
    when it has no users
 b) Make return type of regulator_ena_gpio_ctrl()
 c) Free the GPIO when kzalloc() gets failed in regulator_ena_gpio_request()
 d) Add a pointer to the GPIO structure to the regulator_dev on setting the GPIO
    : use a GPIO structure directly instead of scanning the GPIO list

 Patch v2.
 a) Add a list for enable GPIO
 b) Add a reference count, 'enable_count' for actual pin control

 Patch v1.
 Initial patch

Milo(Woogyom) Kim (4):
  regulator: core: support shared enable GPIO concept
  regulator: core: manage enable GPIO list
  regulator: core: use regulator_ena_pin member
  regulator: lp8788-ldo: use ena_pin of regulator-core for external control

 drivers/regulator/core.c         |  142 +++++++++++++++++++++++++++++++++-----
 drivers/regulator/lp8788-ldo.c   |   98 +++++---------------------
 include/linux/regulator/driver.h |    4 +-
 3 files changed, 142 insertions(+), 102 deletions(-)

-- 
1.7.9.5


Best Regards,
Milo


