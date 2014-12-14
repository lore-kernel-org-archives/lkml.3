Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaLNUnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:43:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaLNUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.17 10/47] nouveau: move the hotplug ignore to correct place.
Date: Sun, 14 Dec 2014 12:20:45 -0800
Message-Id: <20141214201818.913413454@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 8b62c8c6df08ca567c78afa51aa7bbc554cede06 upstream.

Introduced in b440bde74f, however it was added to
the wrong function in nouveau.

https://bugzilla.kernel.org/show_bug.cgi?id=86011
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_drm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -626,7 +626,6 @@ int nouveau_pmops_suspend(struct device
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
-	pci_ignore_hotplug(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 	return 0;
 }
@@ -930,6 +929,7 @@ static int nouveau_pmops_runtime_suspend
 	ret = nouveau_do_suspend(drm_dev, true);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
+	pci_ignore_hotplug(pdev);
 	pci_set_power_state(pdev, PCI_D3cold);
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_DYNAMIC_OFF;
 	return ret;


