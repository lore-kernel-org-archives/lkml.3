Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3HPPlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:41:17 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33589 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239Ab3HPPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:41:13 -0400
Date: Fri, 16 Aug 2013 17:40:55 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Felipe Balbi <balbi@ti.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Roger Quadros <rogerq@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: [PATCH] dma: cpp41: make it compile with CONFIG_BUG=n
Message-ID: <20130816154055.GB3570@breakpoint.cc>
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

Before Randy figures out that this does not compile with CONFIG_BUG=n
here is a fix for it.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/dma/cppi41.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index 5dcebca..e696178 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -579,7 +579,7 @@ static int cppi41_tear_down_chan(struct cppi41_channel *c)
 				WARN_ON(!c->is_tx && !(pd0 & TD_DESC_IS_RX));
 				WARN_ON((pd0 & 0x1f) != c->port_num);
 			} else {
-				__WARN();
+				WARN_ON_ONCE(1);
 			}
 			c->td_seen = 1;
 		}
-- 
1.8.4.rc2

