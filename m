Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaIIOyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:54:32 -0400
Received: from sauhun.de ([89.238.76.85]:34779 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331AbaIIOyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:25 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Jean Delvare <jdelvare@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [RFC 0/4] i2c: slave support framework for Linux devices
Date: Tue,  9 Sep 2014 16:54:26 +0200
Message-Id: <1410274470-12712-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, here is my take on the often desired feature that Linux can not only
be an I2C master, but also an I2C slave. Compared to my draft sent out last
week, this RFC has been tested on hardware (Renesas Lager board) and works \o/

One big part still missing is documentation, so brave ones need to "use the
source". However, this approach turned out to be even less intrusive than
expected, so that is hopefully a good sign.

Basically, an I2C slave is a standard I2C client providing a callback function.
When registering as a slave, the connection to the I2C adapter is made which
uses the callback when a slave event happens. That splits the HW support
(enabling slave mode on the adapter) and SW support (here a generic eeprom
simulator) nicely IMO.

Besides documentation, there are still some error checks missing and more
features could also be added (of course). Yet, I think this version is good
enough to discuss the steps taken here.

The patches are based on top of 3.17-rc4, but will easily apply to renesas/devel.
A git tree can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/slave-support

Comments welcome! Thanks,

   Wolfram


Wolfram Sang (4):
  i2c: core changes for slave support
  i2c: slave: add eeprom simulator driver
  i2c: rcar: add slave support
  ARM: shmobile: r8a7790: adapt DTS for I2C slave support

 arch/arm/boot/dts/r8a7790-lager.dts |  15 ++--
 drivers/i2c/Kconfig                 |  10 +++
 drivers/i2c/Makefile                |   1 +
 drivers/i2c/busses/i2c-rcar.c       | 122 ++++++++++++++++++++++++++---
 drivers/i2c/i2c-core.c              |  44 +++++++++++
 drivers/i2c/i2c-slave-eeprom.c      | 152 ++++++++++++++++++++++++++++++++++++
 include/linux/i2c.h                 |  22 ++++++
 7 files changed, 352 insertions(+), 14 deletions(-)
 create mode 100644 drivers/i2c/i2c-slave-eeprom.c

-- 
2.0.0

