Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbaGRNgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:36:36 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17700 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965674AbaGRNNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:13:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 132/170] workqueue: fix dev_set_uevent_suppress() imbalance
Date: Fri, 18 Jul 2014 14:12:17 +0200
Message-Id: <d5c66201eaff070b915bd31fdc1d03dbe96180d7.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bddbceb688c6d0decaabc7884fede319d02f96c8 upstream.

Uevents are suppressed during attributes registration, but never
restored, so kobject_uevent() does nothing.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 226223ab3c4118ddd10688cc2c131135848371ab
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/workqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cea58300f650..e0b695893579 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3412,6 +3412,7 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 		}
 	}
 
+	dev_set_uevent_suppress(&wq_dev->dev, false);
 	kobject_uevent(&wq_dev->dev.kobj, KOBJ_ADD);
 	return 0;
 }
-- 
2.0.0

