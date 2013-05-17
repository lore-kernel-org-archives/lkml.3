Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab3EQWOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:14:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab3EQVhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 052/102] drm: dont check modeset locks in panic handler
Date: Fri, 17 May 2013 14:36:07 -0700
Message-Id: <20130517213249.824850746@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit a9b054e8ab06504c2afa0e307ee78d3778993a1d upstream.

Since we know that locking is broken in that case and it's more
important to not flood the dmesg with random gunk.

Reported-and-tested-by: Borislav Petkov <bp@suse.de>
References: http://lkml.kernel.org/r/20130502000206.GH15623@pd.tnic
Cc: Dave Airlie <airlied@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_crtc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -78,6 +78,10 @@ void drm_warn_on_modeset_not_all_locked(
 {
 	struct drm_crtc *crtc;
 
+	/* Locking is currently fubar in the panic handler. */
+	if (oops_in_progress)
+		return;
+
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
 		WARN_ON(!mutex_is_locked(&crtc->mutex));
 


