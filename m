Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3FYSwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:52:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab3FYSeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 83/95] Input: add missing dependencies on CONFIG_HAS_IOMEM
Date: Tue, 25 Jun 2013 11:33:10 -0700
Message-Id: <20130625182202.971212839@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 150e5928d6063b273a80d9d6722417ac3c93ff82 upstream.

Several drivers don't build on s390 with CONFIG_PCI disabled as
they require MMIO functions.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/keyboard/Kconfig |    1 +
 drivers/input/serio/Kconfig    |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -431,6 +431,7 @@ config KEYBOARD_TEGRA
 
 config KEYBOARD_OPENCORES
 	tristate "OpenCores Keyboard Controller"
+	depends on HAS_IOMEM
 	help
 	  Say Y here if you want to use the OpenCores Keyboard Controller
 	  http://www.opencores.org/project,keyboardcontroller
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -205,6 +205,7 @@ config SERIO_XILINX_XPS_PS2
 
 config SERIO_ALTERA_PS2
 	tristate "Altera UP PS/2 controller"
+	depends on HAS_IOMEM
 	help
 	  Say Y here if you have Altera University Program PS/2 ports.
 


