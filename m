Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966853Ab3DQV2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:28:51 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53952 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965687Ab3DQV2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:28:49 -0400
Date: Wed, 17 Apr 2013 14:28:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org
Subject: [patch] drivers, mfd: fix tps65912 link error when core mfd is a
 module
Message-ID: <alpine.DEB.2.02.1304171428000.31235@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_MFD_CORE must be statically linked if CONFIG_MFD_TPS65912 is
selected, otherwise it results in a link error:

	drivers/built-in.o: In function `tps65912_device_init':
	(.text+0x587e4): undefined reference to `mfd_add_devices'
	drivers/built-in.o: In function `tps65912_device_init':
	(.text+0x5884c): undefined reference to `mfd_remove_devices'
	drivers/built-in.o: In function `tps65912_device_exit':
	(.text+0x58878): undefined reference to `mfd_remove_devices'

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -805,6 +805,7 @@ config MFD_TPS65910
 config MFD_TPS65912
 	bool "TI TPS65912 Power Management chip"
 	depends on GPIOLIB
+	select MFD_CORE
 	help
 	  If you say yes here you get support for the TPS65912 series of
 	  PM chips.
