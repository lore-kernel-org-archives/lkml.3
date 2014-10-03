Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009AbaJDAhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:37:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbaJCVmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <jroedel@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 3.16 152/357] iommu/vt-d: Check return value of acpi_bus_get_device()
Date: Fri,  3 Oct 2014 14:28:58 -0700
Message-Id: <20141003212938.037461480@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <jroedel@suse.de>

commit c0df975f9045d6b2b13d88746e628ac308ff49ea upstream.

Checking adev == NULL is not sufficient as
acpi_bus_get_device() might not touch the value of this
parameter in an error case, so check the return value
directly.

Fixes: ed40356b5fcf1ce28e026ab39c5b2b6939068b50
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/dmar.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -677,8 +677,7 @@ static int __init dmar_acpi_dev_scope_in
 				       andd->object_name);
 				continue;
 			}
-			acpi_bus_get_device(h, &adev);
-			if (!adev) {
+			if (acpi_bus_get_device(h, &adev)) {
 				pr_err("Failed to get device for ACPI object %s\n",
 				       andd->object_name);
 				continue;


