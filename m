Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213Ab3DCOCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:02:43 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34181 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab3DCOCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:02:40 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/3] check regulator_enable() return value
Date: Wed,  3 Apr 2013 16:02:24 +0200
Message-Id: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe,

While testing your 'next' branch merged with today's next I got some new
warnings, caused by a recently introduced __must_check in:

c8801a8 regulator: core: Mark all get and enable calls as __must_check

These patches introduces a check for regulator_enable() return value in
all three affected USB phy drivers, and issue a dev_err() in case it
fails.

TWL4030 and TWL6030 patches has been build-tested only.

Thanks,
Fabio


Fabio Baltieri (3):
  usb: phy: ab8500-usb: check regulator_enable return value
  usb: phy: twl4030-usb: check regulator_enable return value
  usb: phy: twl6030-usb: check regulator_enable return value

 drivers/usb/phy/phy-ab8500-usb.c  | 12 +++++++++---
 drivers/usb/phy/phy-twl4030-usb.c | 18 +++++++++++++++---
 drivers/usb/phy/phy-twl6030-usb.c | 11 +++++++++--
 3 files changed, 33 insertions(+), 8 deletions(-)

-- 
1.8.1.3

