Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaAFWkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:40:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679AbaAFWkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.12 096/144] drm/nouveau: only runtime suspend by default in optimus configuration
Date: Mon,  6 Jan 2014 14:37:37 -0800
Message-Id: <20140106223748.112280191@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit b25b4427e9dfba073cf9bc86603956ed395eb6e3 upstream.

The intent was to only enable it by default for optimus, e.g. see the
runtime_idle callback. The suspend callback may be called directly, e.g.
as a result of nouveau_crtc_set_config.

Reported-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_drm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -879,6 +879,12 @@ static int nouveau_pmops_runtime_suspend
 	if (nouveau_runtime_pm == 0)
 		return -EINVAL;
 
+	/* are we optimus enabled? */
+	if (nouveau_runtime_pm == -1 && !nouveau_is_optimus() && !nouveau_is_v1_dsm()) {
+		DRM_DEBUG_DRIVER("failing to power off - not optimus\n");
+		return -EINVAL;
+	}
+
 	drm_kms_helper_poll_disable(drm_dev);
 	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_OFF);
 	nouveau_switcheroo_optimus_dsm();


