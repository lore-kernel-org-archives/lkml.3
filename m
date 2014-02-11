Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaBKTHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:07:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaBKTHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Akash Goel <akash.goel@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 083/107] drm/i915: Fix the offset issue for the stolen GEM objects
Date: Tue, 11 Feb 2014 11:05:49 -0800
Message-Id: <20140211184750.563254817@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Goel <akash.goel@intel.com>

commit ec14ba47791965d2c08e0a681ff44eacbf3c4553 upstream.

The 'offset' field of the 'scatterlist' structure was wrongly
programmed with the offset value from the base of stolen area,
whereas this field indicates the offset from where the interested
data starts within the first PAGE pointed to by 'scattterlist'
structure. As a result when a new GEM object allocated from stolen
area is mapped to GTT, it could lead to an overwrite of GTT entries
as the page count calculation will go wrong, refer the function
'sg_page_count'.

v2: Modified the commit message. (Chris)

Signed-off-by: Akash Goel <akash.goel@intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=71908
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=69104
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_stolen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -250,7 +250,7 @@ i915_pages_create_for_stolen(struct drm_
 	}
 
 	sg = st->sgl;
-	sg->offset = offset;
+	sg->offset = 0;
 	sg->length = size;
 
 	sg_dma_address(sg) = (dma_addr_t)dev_priv->mm.stolen_base + offset;


