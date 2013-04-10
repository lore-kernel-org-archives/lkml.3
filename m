Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937540Ab3DJXGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:06:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937363Ab3DJWrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lauri Kasanen <cand@gmx.com>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 49/64] drm/i915: Fix build failure
Date: Wed, 10 Apr 2013 15:46:46 -0700
Message-Id: <20130410224344.793164797@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lauri Kasanen <cand@gmx.com>

commit 27b7c63a7c509d797c151e95a641e1d94d94bbd9 upstream.

ERROR: "__build_bug_on_failed" [drivers/gpu/drm/i915/i915.ko] undefined!

Originally reported at http://www.gossamer-threads.com/lists/linux/kernel/1631803
FDO bug #62775

This needs to be backported to both 3.7 and 3.8 stable trees. Doesn't apply straight,
but it's a quick change.

Signed-off-by: Lauri Kasanen <cand@gmx.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=62775
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -43,7 +43,7 @@ eb_create(int size)
 {
 	struct eb_objects *eb;
 	int count = PAGE_SIZE / sizeof(struct hlist_head) / 2;
-	BUILD_BUG_ON(!is_power_of_2(PAGE_SIZE / sizeof(struct hlist_head)));
+	BUILD_BUG_ON_NOT_POWER_OF_2(PAGE_SIZE / sizeof(struct hlist_head));
 	while (count > size)
 		count >>= 1;
 	eb = kzalloc(count*sizeof(struct hlist_head) +


