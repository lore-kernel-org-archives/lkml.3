Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936023Ab3DHJyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:54:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43085 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935987Ab3DHJw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Guy Briggs <rbriggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 099/102] thermal: return an error on failure to register thermal class
Date: Mon,  8 Apr 2013 10:50:54 +0100
Message-Id: <1365414657-29191-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rbriggs@redhat.com>

commit da28d966f6aa942ae836d09729f76a1647932309 upstream.

The return code from the registration of the thermal class is used to
unallocate resources, but this failure isn't passed back to the caller of
thermal_init.  Return this failure back to the caller.

This bug was introduced in changeset 4cb18728 which overwrote the return code
when the variable was re-used to catch the return code of the registration of
the genetlink thermal socket family.

Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/thermal/thermal_sys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 022bacb..5c26dda 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1383,6 +1383,7 @@ static int __init thermal_init(void)
 		idr_destroy(&thermal_cdev_idr);
 		mutex_destroy(&thermal_idr_lock);
 		mutex_destroy(&thermal_list_lock);
+		return result;
 	}
 	result = genetlink_init();
 	return result;
-- 
1.8.1.2

