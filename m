Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967209AbaFTMDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:03:13 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65530 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966555AbaFTMDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:03:12 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: [PATCH v3 0/7] i2c: Relax mandatory I2C ID table passing
Date: Fri, 20 Jun 2014 13:02:23 +0100
Message-Id: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,
 
As previously discussed I believe it should be okay for an I2C device
driver _not_ supply an I2C ID table to match to.  The I2C subsystem
should be able to match via other means, such as via OF tables.  The
blocking factor during our previous conversation was to keep
registering via sysfs up and running.  This set does that.

After thinking more deeply about the problem, it occurred to me that
any I2C device driver which uses the sysfs method and issues an
of_match_device() would also fail their probe().  Bolted on to this
set is a new, more generic way for these devices to match against
either of the I2C/OF tables.

I hope this ticks all of your boxes.

v3:
  - Insist on passing 'struct i2c_client' instead of 'struct device'
  - Remove hook from of_match_device()

v2:
  - Removal of ACPI support (this is really an OF issue).
  - Add a new .probe2( with will seamlessly replace
  - Supply a warning on devices matching via OF without a suitable compatible
  - Remove unified match_device() - bad idea as it subverts type-safe behaviour
  - Provide examples of the kind of clean-up possible after this set.
    - I already have the full support from the maintainer of these drivers =;-)

Kind regards,
Lee

 arch/arm/configs/multi_v7_defconfig |  1 +
 drivers/i2c/i2c-core.c              | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 drivers/mfd/88pm860x-core.c         |  5 ++---
 drivers/mfd/as3722.c                | 12 ++----------
 include/linux/i2c.h                 | 22 +++++++++++++++++++++-
 5 files changed, 89 insertions(+), 23 deletions(-)

