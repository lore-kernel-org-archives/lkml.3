Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaFDMKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:10:13 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:46756 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaFDMKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:10:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: [PATCH 0/7] i2c: Relax mandatory I2C ID table passing
Date: Wed,  4 Jun 2014 13:09:49 +0100
Message-Id: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

As previously discussed I believe it should be okay for an I2C device
driver _not_ supply an I2C ID table to match to.  The I2C subsystem
should be able to match via other means, such as via OF and/or ACPI
tables.  The blocking factor during our previous conversation was
to keep registering via sysfs up and running.  This set does that.

After thinking more deeply about the problem, it occurred to me that
any I2C device driver which issues an {of,acpi}_match)_device()
would also fail their probe().  Bolted on to this set is a new, more
generic way for these devices to match against any of the tables
which are present in the kernel today i.e. OF, ACPI and I2C.

NB: ACPI is not fully supported, but OF is.

I hope this ticks all of your boxes.

Kind regards,
Lee

 drivers/i2c/i2c-core.c          | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/of/device.c             | 16 +++++++++++++++-
 include/acpi/platform/aclinux.h |  5 +++--
 include/linux/i2c.h             | 19 +++++++++++++++++++
 include/linux/match.h           | 40 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 135 insertions(+), 10 deletions(-)

