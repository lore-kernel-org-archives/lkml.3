Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760465Ab3ICVgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:36:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab3ICVgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:36:06 -0400
Date: Tue, 3 Sep 2013 17:35:52 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org
Subject: Restrict AM335x PHY driver to only be built on !ARM when
 COMPILE_TEST is set.
Message-ID: <20130903213552.GD2247@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org
References: <20130903185917.BC7BD660DE3@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903185917.BC7BD660DE3@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index d5589f9..51ffe11 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -93,6 +93,7 @@ config AM335X_CONTROL_USB
 
 config AM335X_PHY_USB
 	tristate "AM335x USB PHY Driver"
+	depends on ARM || COMPILE_TEST
 	select USB_PHY
 	select AM335X_CONTROL_USB
 	select NOP_USB_XCEIV
