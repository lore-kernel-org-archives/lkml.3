Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbaJIVJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:09:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59321 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbaJIVJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 107/163] vgaswitcheroo: add vga_switcheroo_fini_domain_pm_ops
Date: Thu,  9 Oct 2014 14:02:12 -0700
Message-Id: <1412888588-26755-108-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 766a53d059d1500c9755c8af017bd411bd8f1b20 upstream.

Drivers should call this on unload to unregister pmops.

Bug:
https://bugzilla.kernel.org/show_bug.cgi?id=84431

Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/vga/vga_switcheroo.c | 6 ++++++
 include/linux/vga_switcheroo.h   | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 6866448..37ac7b5 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -660,6 +660,12 @@ int vga_switcheroo_init_domain_pm_ops(struct device *dev, struct dev_pm_domain *
 }
 EXPORT_SYMBOL(vga_switcheroo_init_domain_pm_ops);
 
+void vga_switcheroo_fini_domain_pm_ops(struct device *dev)
+{
+	dev->pm_domain = NULL;
+}
+EXPORT_SYMBOL(vga_switcheroo_fini_domain_pm_ops);
+
 static int vga_switcheroo_runtime_resume_hdmi_audio(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
index 502073a..b483abd 100644
--- a/include/linux/vga_switcheroo.h
+++ b/include/linux/vga_switcheroo.h
@@ -64,6 +64,7 @@ int vga_switcheroo_get_client_state(struct pci_dev *dev);
 void vga_switcheroo_set_dynamic_switch(struct pci_dev *pdev, enum vga_switcheroo_state dynamic);
 
 int vga_switcheroo_init_domain_pm_ops(struct device *dev, struct dev_pm_domain *domain);
+void vga_switcheroo_fini_domain_pm_ops(struct device *dev);
 int vga_switcheroo_init_domain_pm_optimus_hdmi_audio(struct device *dev, struct dev_pm_domain *domain);
 #else
 
@@ -82,6 +83,7 @@ static inline int vga_switcheroo_get_client_state(struct pci_dev *dev) { return
 static inline void vga_switcheroo_set_dynamic_switch(struct pci_dev *pdev, enum vga_switcheroo_state dynamic) {}
 
 static inline int vga_switcheroo_init_domain_pm_ops(struct device *dev, struct dev_pm_domain *domain) { return -EINVAL; }
+static inline void vga_switcheroo_fini_domain_pm_ops(struct device *dev) {}
 static inline int vga_switcheroo_init_domain_pm_optimus_hdmi_audio(struct device *dev, struct dev_pm_domain *domain) { return -EINVAL; }
 
 #endif
-- 
1.9.1

