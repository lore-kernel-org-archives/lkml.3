Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3HPPdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:33:24 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33562 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901Ab3HPPdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:33:18 -0400
Date: Fri, 16 Aug 2013 17:32:49 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Felipe Balbi <balbi@ti.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Roger Quadros <rogerq@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] usb: phy: am335x-control: make it compile with
Message-ID: <20130816153249.GA3570@breakpoint.cc>
References: <20130815165829.6a401f104ee2a98dd48bcb58@canb.auug.org.au>
 <520D0AD7.6050002@infradead.org>
 <520E0304.5050906@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520E0304.5050906@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Randy reported this
|drivers/usb/phy/phy-am335x-control.c:45:3: error: implicit declaration
|of function '__WARN' [-Werror=implicit-function-declaration]

and left it as an excercice to figure out that this happens only with
CONFIG_BUG=n. As a fix I replace it with WARN_ON(). And there is a space
before return so fix this, too.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/phy/phy-am335x-control.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-am335x-control.c b/drivers/usb/phy/phy-am335x-control.c
index 7597545..22cf07d 100644
--- a/drivers/usb/phy/phy-am335x-control.c
+++ b/drivers/usb/phy/phy-am335x-control.c
@@ -42,8 +42,8 @@ static void am335x_phy_power(struct phy_control *phy_ctrl, u32 id, bool on)
 		reg = AM335X_USB1_CTRL;
 		break;
 	default:
-		__WARN();
-		 return;
+		WARN_ON(1);
+		return;
 	}
 
 	val = readl(usb_ctrl->phy_reg + reg);
-- 
1.8.4.rc2

