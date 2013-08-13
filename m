Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab3HMGdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab3HMGdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [ 41/60] drm/ast: invalidate page tables when pinning a BO
Date: Mon, 12 Aug 2013 23:34:08 -0700
Message-Id: <20130813063337.622259408@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 3ac65259328324de323dc006b52ff7c1a5b18d19 upstream.

same fix as cirrus and mgag200.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ast/ast_ttm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -348,6 +348,7 @@ int ast_bo_create(struct drm_device *dev
 
 	astbo->gem.driver_private = NULL;
 	astbo->bo.bdev = &ast->ttm.bdev;
+	astbo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	ast_ttm_placement(astbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 


