Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbaHHUtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:49:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228AbaHHUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:49:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxime Bizon <mbizon@freebox.fr>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 058/259] workqueue: fix dev_set_uevent_suppress() imbalance
Date: Fri,  8 Aug 2014 13:38:01 -0700
Message-Id: <1407530482-4483-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bizon <mbizon@freebox.fr>

commit bddbceb688c6d0decaabc7884fede319d02f96c8 upstream.

Uevents are suppressed during attributes registration, but never
restored, so kobject_uevent() does nothing.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 226223ab3c4118ddd10688cc2c131135848371ab
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/workqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1b23f5b..61212c9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3415,6 +3415,7 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 		}
 	}
 
+	dev_set_uevent_suppress(&wq_dev->dev, false);
 	kobject_uevent(&wq_dev->dev.kobj, KOBJ_ADD);
 	return 0;
 }
-- 
1.9.1

