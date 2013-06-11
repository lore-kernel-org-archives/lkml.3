Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3FKULV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:11:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab3FKUEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Egbert Eich <eich@suse.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 55/79] drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.
Date: Tue, 11 Jun 2013 13:03:21 -0700
Message-Id: <20130611195323.365512974@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.de>

commit 53d3b4d7778daf15900867336c85d3f8dd70600c upstream.

In intel_sdvo_get_lvds_modes() the wrong i2c adapter record is used
for DDC. Thus the code will always have to rely on a LVDS panel
mode supplied by VBT.
In most cases this succeeds, so this didn't get detected for quite
a while.

This regression seems to have been introduced in

commit f899fc64cda8569d0529452aafc0da31c042df2e
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Jul 20 15:44:45 2010 -0700

    drm/i915: use GMBUS to manage i2c links

Signed-off-by: Egbert Eich <eich@suse.de>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
[danvet: Add note about which commit likely introduced this issue.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_sdvo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1770,7 +1770,7 @@ static void intel_sdvo_get_lvds_modes(st
 	 * Assume that the preferred modes are
 	 * arranged in priority order.
 	 */
-	intel_ddc_get_modes(connector, intel_sdvo->i2c);
+	intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 	if (list_empty(&connector->probed_modes) == false)
 		goto end;
 


