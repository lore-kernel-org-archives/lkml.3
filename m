Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbaGOXNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:13:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759882AbaGOXNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxime Bizon <mbizon@freebox.fr>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 06/44] workqueue: fix dev_set_uevent_suppress() imbalance
Date: Tue, 15 Jul 2014 16:17:04 -0700
Message-Id: <20140715231646.877385105@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231646.690728348@linuxfoundation.org>
References: <20140715231646.690728348@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bizon <mbizon@freebox.fr>

commit bddbceb688c6d0decaabc7884fede319d02f96c8 upstream.

Uevents are suppressed during attributes registration, but never
restored, so kobject_uevent() does nothing.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 226223ab3c4118ddd10688cc2c131135848371ab
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3373,6 +3373,7 @@ int workqueue_sysfs_register(struct work
 		}
 	}
 
+	dev_set_uevent_suppress(&wq_dev->dev, false);
 	kobject_uevent(&wq_dev->dev.kobj, KOBJ_ADD);
 	return 0;
 }


