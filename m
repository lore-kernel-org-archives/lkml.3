Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbaIOXAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:00:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50839 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678AbaIOWOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:14:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 064/187] drm/tilcdc: tfp410: fix dangling sysfs connector node
Date: Mon, 15 Sep 2014 15:07:54 -0700
Message-Id: <1410818997-9432-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>

commit 16dcbdef404f4e87dab985494381939fe0a2d456 upstream.

Add a drm_sysfs_connector_remove call when we destroy the panel to make
sure the connector node in sysfs gets deleted.

This is required for proper unload and re-load of this driver, otherwise
we will get a warning about a duplicate filename in sysfs.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
Tested-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index c38b56b..ce75ac8 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -167,6 +167,7 @@ struct tfp410_connector {
 static void tfp410_connector_destroy(struct drm_connector *connector)
 {
 	struct tfp410_connector *tfp410_connector = to_tfp410_connector(connector);
+	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(tfp410_connector);
 }
-- 
1.9.1

