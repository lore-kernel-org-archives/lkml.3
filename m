Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934631Ab3DOCpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:45:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934407Ab3DOCoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:44:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [ 22/27] udl: handle EDID failure properly.
Date: Sun, 14 Apr 2013 19:43:21 -0700
Message-Id: <20130415024233.001786045@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@gmail.com>

commit 1baee58638fc58248625255f5c5fcdb987f11b1f upstream.

Don't oops seems proper.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/udl/udl_connector.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -61,6 +61,10 @@ static int udl_get_modes(struct drm_conn
 	int ret;
 
 	edid = (struct edid *)udl_get_edid(udl);
+	if (!edid) {
+		drm_mode_connector_update_edid_property(connector, NULL);
+		return 0;
+	}
 
 	/*
 	 * We only read the main block, but if the monitor reports extension


