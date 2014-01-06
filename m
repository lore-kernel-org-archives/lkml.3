Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaAFXiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:38:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbaAFWkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 143/144] nouveau_acpi: convert acpi_get_handle() to acpi_has_method()
Date: Mon,  6 Jan 2014 14:38:24 -0800
Message-Id: <20140106223749.447002709@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

commit 187b5b5d520c2318a1f88fb8d8913a9d7fbf7d92 upstream.

acpi_has_method() is a new ACPI API introduced to check
the existence of an ACPI control method.

It can be used to replace acpi_get_handle() in the case that
1. the calling function doesn't need the ACPI handle of the control method.
and
2. the calling function doesn't care the reason why the method is unavailable.

Convert acpi_get_handle() to acpi_has_method()
in drivers/gpu/drm/nouveau/nouveau_acpi.c in this patch.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
CC: Ben Skeggs <bskeggs@redhat.com>
CC: Dave Airlie <airlied@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_acpi.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -253,18 +253,15 @@ static struct vga_switcheroo_handler nou
 
 static int nouveau_dsm_pci_probe(struct pci_dev *pdev)
 {
-	acpi_handle dhandle, nvidia_handle;
-	acpi_status status;
+	acpi_handle dhandle;
 	int retval = 0;
 
 	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
 	if (!dhandle)
 		return false;
 
-	status = acpi_get_handle(dhandle, "_DSM", &nvidia_handle);
-	if (ACPI_FAILURE(status)) {
+	if (!acpi_has_method(dhandle, "_DSM"))
 		return false;
-	}
 
 	if (nouveau_test_dsm(dhandle, nouveau_dsm, NOUVEAU_DSM_POWER))
 		retval |= NOUVEAU_DSM_HAS_MUX;


