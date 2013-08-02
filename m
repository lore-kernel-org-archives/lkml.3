Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664Ab3HBKMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:12:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030606Ab3HBKMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:12:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Zhouping Liu <zliu@redhat.com>
Subject: [ 98/99] drm/i915: Correct obj->mm_list link to dev_priv->dev_priv->mm.inactive_list
Date: Fri,  2 Aug 2013 18:08:51 +0800
Message-Id: <20130802100239.592262663@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiong Zhang <xiong.y.zhang@intel.com>

commit 067556084a0e412013af6b0250a3143ae5afde6d upstream.

obj->mm_list link to dev_priv->mm.inactive_list/active_list
obj->global_list link to dev_priv->mm.unbound_list/bound_list

This regression has been introduced in

commit 93927ca52a55c23e0a6a305e7e9082e8411ac9fa
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Jan 10 18:03:00 2013 +0100

    drm/i915: Revert shrinker changes from "Track unbound pages"

Cc: stable@vger.kernel.org
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
[danvet: Add regression notice.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zhouping Liu <zliu@redhat.com>


---
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4493,7 +4493,7 @@ i915_gem_inactive_shrink(struct shrinker
 	list_for_each_entry(obj, &dev_priv->mm.unbound_list, gtt_list)
 		if (obj->pages_pin_count == 0)
 			cnt += obj->base.size >> PAGE_SHIFT;
-	list_for_each_entry(obj, &dev_priv->mm.inactive_list, gtt_list)
+	list_for_each_entry(obj, &dev_priv->mm.inactive_list, mm_list)
 		if (obj->pin_count == 0 && obj->pages_pin_count == 0)
 			cnt += obj->base.size >> PAGE_SHIFT;
 


