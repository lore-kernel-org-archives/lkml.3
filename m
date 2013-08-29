Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3H2VIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:08:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53233 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757166Ab3H2VIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:08:21 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] hvc_xen: Remove unnecessary __GFP_ZERO from kzalloc
Date: Thu, 29 Aug 2013 14:08:18 -0700
Message-Id: <3cf4280498661e3099cf53ef408581fb2de9c006.1377810330.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc already adds this __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/tty/hvc/hvc_xen.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 682210d..e61c36c 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -208,7 +208,7 @@ static int xen_hvm_console_init(void)
 
 	info = vtermno_to_xencons(HVC_COOKIE);
 	if (!info) {
-		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
+		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 		if (!info)
 			return -ENOMEM;
 	} else if (info->intf != NULL) {
@@ -257,7 +257,7 @@ static int xen_pv_console_init(void)
 
 	info = vtermno_to_xencons(HVC_COOKIE);
 	if (!info) {
-		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
+		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 		if (!info)
 			return -ENOMEM;
 	} else if (info->intf != NULL) {
@@ -284,7 +284,7 @@ static int xen_initial_domain_console_init(void)
 
 	info = vtermno_to_xencons(HVC_COOKIE);
 	if (!info) {
-		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
+		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 		if (!info)
 			return -ENOMEM;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

