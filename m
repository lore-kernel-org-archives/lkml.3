Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaKRQD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:03:57 -0500
Received: from sauhun.de ([89.238.76.85]:46108 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbaKRQDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:03:52 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 0/3] i2c: slave support framework for Linux devices
Date: Tue, 18 Nov 2014 17:04:52 +0100
Message-Id: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, here is my take on the often desired feature that Linux can not only
be an I2C master, but also an I2C slave. Since RFC, most open issues have been
dealt with. Find details in the patch descriptions. Documentation is still
missing and will come later this or next week, but surely early enough for
the 3.19 release which this series wants to go in. Yet, I'd like to encourage
code-review and build-testing already.

Basically, an I2C slave is a standard I2C client providing a callback function.
When registering as a slave, the connection to the I2C adapter is made which
uses the callback when a slave event happens. That splits the HW support
(enabling slave mode on the adapter) and SW support (here a generic eeprom
simulator) nicely IMO.

The patches have been tested with a Renesas R8A7790 based Lager board. They are
based on top of 3.18-rc5, but will easily apply to renesas/devel. A git tree
can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/slave-support

Comments welcome! Thanks,

   Wolfram


Wolfram Sang (3):
  i2c: core changes for slave support
  i2c: slave-eeprom: add eeprom simulator driver
  i2c: rcar: add slave support

 drivers/i2c/Kconfig            |  10 +++
 drivers/i2c/Makefile           |   1 +
 drivers/i2c/busses/i2c-rcar.c  | 125 +++++++++++++++++++++++++++---
 drivers/i2c/i2c-core.c         |  49 ++++++++++++
 drivers/i2c/i2c-slave-eeprom.c | 170 +++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c.h            |  29 +++++++
 6 files changed, 375 insertions(+), 9 deletions(-)
 create mode 100644 drivers/i2c/i2c-slave-eeprom.c

-- 
2.1.1

