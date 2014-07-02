Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaGBKHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:07:44 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:40912 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752032AbaGBKHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:07:39 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: lgirdwood@gmail.com, broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk, heiko@sntech.de,
        rob.jones@codethink.co.uk
Subject: [PATCH V2 0/3] Change gpio_regulator_probe() to use managed resources.
Date: Wed,  2 Jul 2014 11:05:48 +0100
Message-Id: <1404295551-13470-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the use of managed resource functions in regulator by replacing
all calls to unmanaged resource allocation functions in
gpio_regulator_probe() with their managed equivalent.

Add a new function, devm_kmemdup(), to drivers/base/devres.c to support this.

Rob Jones (3):
  base: Add block copy func. for managed devices
  gpio: allow gpio array requests for managed devices
  regulator: use managed resources for gpio_regulator_probe().

 drivers/base/devres.c              |   25 +++++++++++++
 drivers/gpio/devres.c              |   63 ++++++++++++++++++++++++++++++++
 drivers/regulator/gpio-regulator.c |   70 ++++++++++++------------------------
 include/linux/device.h             |    2 ++
 include/linux/gpio.h               |    4 +++
 5 files changed, 117 insertions(+), 47 deletions(-)

-- 
1.7.10.4

Incorporates requested changes.

Note that this patch series no longer includes a change to devm_kstrdup()
as this was not essential to the primary aim of the series. This will be
submitted later once devm_kmemdup() has been accepted.
