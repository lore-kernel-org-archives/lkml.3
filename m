Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbaJDAXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:23:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbaJCVnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Fu Zhonghui <zhonghui.fu@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 197/357] ACPI / platform / LPSS: disable async suspend/resume of LPSS devices
Date: Fri,  3 Oct 2014 14:29:43 -0700
Message-Id: <20141003212939.394437302@linuxfoundation.org>
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

From: Fu Zhonghui <zhonghui.fu@linux.intel.com>

commit 457920817e645a7dee42c2a75c81c5ed8e12ee1c upstream.

On some systems (Asus T100 in particular) there are strict ordering
dependencies between LPSS devices with respect to power management
that break if they suspend/resume asynchronously.

In theory it should be possible to follow those dependencies in the
async suspend/resume case too (the ACPI tables tell as that the
dependencies are there), but since we're missing infrastructure
for that at the moment, disable async suspend/resume for all of
the LPSS devices for the time being.

Link: http://marc.info/?l=linux-acpi&m=141158962321905&w=2
Fixes: 8ce62f85a81f (ACPI / platform / LPSS: Enable async suspend/resume of LPSS devices)
Signed-off-by: Li Aubrey <aubrey.li@linux.intel.com>
Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
[ rjw: Changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_lpss.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -392,7 +392,6 @@ static int acpi_lpss_create_device(struc
 	adev->driver_data = pdata;
 	pdev = acpi_create_platform_device(adev);
 	if (!IS_ERR_OR_NULL(pdev)) {
-		device_enable_async_suspend(&pdev->dev);
 		return 1;
 	}
 


