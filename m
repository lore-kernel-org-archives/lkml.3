Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaIKUyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:54:00 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47069 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbaIKUx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:53:59 -0400
Date: Thu, 11 Sep 2014 13:53:54 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/ttm: make sure format string cannot leak in
Message-ID: <20140911205354.GA2959@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While zone->name is currently hard coded, the call to kobject_init_and_add()
should follow the more defensive argument list usage (as already done in
other places in ttm_memory.c) where "%s" is used instead of directly passing
in a variable as a format string.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/ttm/ttm_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
index fa53df487875..1e688b603e46 100644
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -300,7 +300,8 @@ static int ttm_mem_init_highmem_zone(struct ttm_mem_global *glob,
 	zone->glob = glob;
 	glob->zone_highmem = zone;
 	ret = kobject_init_and_add(
-		&zone->kobj, &ttm_mem_zone_kobj_type, &glob->kobj, zone->name);
+		&zone->kobj, &ttm_mem_zone_kobj_type, &glob->kobj, "%s",
+		zone->name);
 	if (unlikely(ret != 0)) {
 		kobject_put(&zone->kobj);
 		return ret;
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
