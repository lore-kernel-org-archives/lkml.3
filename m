Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3LSPEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:04:51 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:62228 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3LSPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:48 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-ia64@vger.kernel.org
Subject: [PATCH 18/38] ia64: kernel: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:29 +0100
Message-Id: <1387465429-3568-19-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.
Removed kfree() as put_device() will result in tiocx_bus_release called.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/ia64/sn/kernel/tiocx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/sn/kernel/tiocx.c b/arch/ia64/sn/kernel/tiocx.c
index e35f648..6f369cc 100644
--- a/arch/ia64/sn/kernel/tiocx.c
+++ b/arch/ia64/sn/kernel/tiocx.c
@@ -209,7 +209,7 @@ cx_device_register(nasid_t nasid, int part_num, int mfg_num,
 	dev_set_name(&cx_dev->dev, "%d", cx_dev->cx_id.nasid);
 	r = device_register(&cx_dev->dev);
 	if (r) {
-		kfree(cx_dev);
+		put_device(&cx_dev->dev);
 		return r;
 	}
 	get_device(&cx_dev->dev);
-- 
1.8.3.1

