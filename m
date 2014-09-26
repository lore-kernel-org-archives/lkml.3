Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaIZJuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:50:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225AbaIZJqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 122/142] drm/tilcdc: tfp410: fix dangling sysfs connector node
Date: Fri, 26 Sep 2014 11:45:33 +0200
Message-Id: <e2f57296d3f3c4f5cdf5aa4f4c26b3c68ff17005.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guido Martínez <guido@vanguardiasur.com.ar>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 16dcbdef404f4e87dab985494381939fe0a2d456 upstream.

Add a drm_sysfs_connector_remove call when we destroy the panel to make
sure the connector node in sysfs gets deleted.

This is required for proper unload and re-load of this driver, otherwise
we will get a warning about a duplicate filename in sysfs.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
Tested-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index c38b56b268ac..ce75ac8de4f8 100644
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
2.1.0

