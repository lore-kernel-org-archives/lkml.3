Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3B0BDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:03:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760232Ab3BZX5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 073/150] drm: shut up invalid edid messages
Date: Tue, 26 Feb 2013 15:55:30 -0800
Message-Id: <20130226235531.760245302@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit f934ec8c34b9dcefb5a4f35b0bda33bca289cbe6 upstream.

My cheapo monitor has an invalid block 1, resulting in a lot of dmesg spam every few seconds.

I get it the first time that the entire block is all 0xff..

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -357,10 +357,14 @@ drm_do_get_edid(struct drm_connector *co
 				break;
 			}
 		}
-		if (i == 4)
+
+		if (i == 4 && print_bad_edid) {
 			dev_warn(connector->dev->dev,
 			 "%s: Ignoring invalid EDID block %d.\n",
 			 drm_get_connector_name(connector), j);
+
+			connector->bad_edid_counter++;
+		}
 	}
 
 	if (valid_extensions != block[0x7e]) {


