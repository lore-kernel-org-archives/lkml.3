Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab3LBUp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:45:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3LBTN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.10 098/173] drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previous fence
Date: Mon,  2 Dec 2013 11:11:21 -0800
Message-Id: <20131202191155.308810169@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 9360bd1112d8874d21942e2ae74f5416b00a8db6 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -287,7 +287,8 @@ validate_fini_list(struct list_head *lis
 	list_for_each_safe(entry, tmp, list) {
 		nvbo = list_entry(entry, struct nouveau_bo, entry);
 
-		nouveau_bo_fence(nvbo, fence);
+		if (likely(fence))
+			nouveau_bo_fence(nvbo, fence);
 
 		if (unlikely(nvbo->validate_mapped)) {
 			ttm_bo_kunmap(&nvbo->kmap);


