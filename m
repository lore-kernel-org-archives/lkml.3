Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaKXMZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:25:16 -0500
Received: from atl4mhob10.myregisteredsite.com ([209.17.115.48]:53741 "EHLO
	atl4mhob10.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbaKXMZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:25:15 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: airlied@linux.ie
Cc: lars@metafoo.de, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] gpu/drm/drm_sysfs.c: Export drm_sysfs_connector_add and drm_sysfs_connector_remove
Date: Mon, 24 Nov 2014 13:25:03 +0100
Message-Id: <1416831903-5138-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building the adi_axi_hdmi driver as a module failed:
ERROR: "drm_sysfs_connector_remove" [drivers/gpu/drm/adi_axi_hdmi/adi_axi_hdmi.ko] undefined!

Mark drm_sysfs_connector_remove for export to fix this. Also mark
drm_sysfs_connector_add for export, for symetry and because at least
one other module uses it (xylon_connector.c).

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/gpu/drm/drm_sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index ab1a5f6..d0296cc 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -438,6 +438,7 @@ err_out_files:
 out:
 	return ret;
 }
+EXPORT_SYMBOL(drm_sysfs_connector_add);
 
 /**
  * drm_sysfs_connector_remove - remove an connector device from sysfs
@@ -467,6 +468,7 @@ void drm_sysfs_connector_remove(struct drm_connector *connector)
 	device_unregister(connector->kdev);
 	connector->kdev = NULL;
 }
+EXPORT_SYMBOL(drm_sysfs_connector_remove);
 
 /**
  * drm_sysfs_hotplug_event - generate a DRM uevent
-- 
1.7.9.5

