Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbaGXJsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:48:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55036 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbaGXJsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxime Bizon <mbizon@freebox.fr>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 089/128] workqueue: fix dev_set_uevent_suppress() imbalance
Date: Thu, 24 Jul 2014 10:45:38 +0100
Message-Id: <1406195177-8656-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bizon <mbizon@freebox.fr>

commit bddbceb688c6d0decaabc7884fede319d02f96c8 upstream.

Uevents are suppressed during attributes registration, but never
restored, so kobject_uevent() does nothing.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 226223ab3c4118ddd10688cc2c131135848371ab
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/workqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 23071c9acdc1..ac1336d91ba1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3391,6 +3391,7 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 		}
 	}
 
+	dev_set_uevent_suppress(&wq_dev->dev, false);
 	kobject_uevent(&wq_dev->dev.kobj, KOBJ_ADD);
 	return 0;
 }
-- 
1.9.1

