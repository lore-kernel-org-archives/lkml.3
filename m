Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3ARTzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:55:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44443 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab3ARTxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:53:06 -0500
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Rafael <rjw@sisk.pl>, Kevin <khilman@deeprootsystems.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        lkml <linux-kernel@vger.kernel.org>, lo <linux-omap@vger.kernel.org>,
        Jack <jack@embed.me.uk>, Alexander <holler@ahsoftware.de>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 3/4] PM / devfreq: add locking documentation for recommended_opp
Date: Fri, 18 Jan 2013 13:52:34 -0600
Message-ID: <1358538755-29109-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358538755-29109-1-git-send-email-nm@ti.com>
References: <1358538755-29109-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OPP pointers are protected by RCU locks, the pointer validity is
permissible only under the section of rcu_read_lock to rcu_read_unlock

Add documentation to the effect.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/devfreq/devfreq.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 53766f3..3b36797 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -994,6 +994,11 @@ module_exit(devfreq_exit);
  * @freq:	The frequency given to target function
  * @flags:	Flags handed from devfreq framework.
  *
+ * Locking: This function must be called under rcu_read_lock(). opp is a rcu
+ * protected pointer. The reason for the same is that the opp pointer which is
+ * returned will remain valid for use with opp_get_{voltage, freq} only while
+ * under the locked area. The pointer returned must be used prior to unlocking
+ * with rcu_read_unlock() to maintain the integrity of the pointer.
  */
 struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
 				    u32 flags)
-- 
1.7.9.5

