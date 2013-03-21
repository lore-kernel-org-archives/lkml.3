Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3CUTIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:08:37 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45539 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3CUTIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:08:36 -0400
Date: Thu, 21 Mar 2013 12:08:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Samuel Ortiz <sameo@linux.intel.com>
cc: Simon Glass <sjg@chromium.org>, linux-kernel@vger.kernel.org
Subject: [patch] drivers, mfd: fix link error
Message-ID: <alpine.DEB.2.02.1303211206160.5662@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_MFD_CROS_EC requires CONFIG_MFD_CORE for a couple of functions that 
are declared but not defined:

	ERROR: "mfd_remove_devices" [drivers/mfd/cros_ec.ko] undefined!
	ERROR: "mfd_add_devices" [drivers/mfd/cros_ec.ko] undefined!

Fix it by selecting CONFIG_MFD_CORE anytime CONFIG_MFD_CROS_EC is enabled.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -23,6 +23,7 @@ config MFD_88PM860X
 
 config MFD_CROS_EC
 	tristate "Support ChromeOS Embedded Controller"
+	select MFD_CORE
 	help
 	  If you say Y here you get support for the ChromeOS Embedded
 	  Controller (EC) providing keyboard, battery and power services.
