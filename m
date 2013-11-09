Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab3KIHAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:00:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926Ab3KIGwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.11 77/94] drm/vmwgfx: Dont put resources with invalid ids on lru list
Date: Fri,  8 Nov 2013 22:52:23 -0800
Message-Id: <20131109065209.694947043@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 26682480c202e7360cbcdc3bc9e962bf749c6b8d upstream.

The evict code may try to swap them out causing a BUG in the destroy
function.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -970,7 +970,7 @@ void vmw_resource_unreserve(struct vmw_r
 	if (new_backup)
 		res->backup_offset = new_backup_offset;
 
-	if (!res->func->may_evict)
+	if (!res->func->may_evict || res->id == -1)
 		return;
 
 	write_lock(&dev_priv->resource_lock);


