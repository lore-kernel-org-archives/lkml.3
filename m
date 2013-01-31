Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3AaD1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 22:27:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40822 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3AaD1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 22:27:51 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5109E49E.1070005@jp.fujitsu.com>
Date: Thu, 31 Jan 2013 12:27:26 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        <daniel.vetter@ffwll.ch>, <airlied@linux.ie>,
        <dri-devel@lists.freedesktop.org>
Subject: [RESEND PATCH 4/4] GPU/i915: Fix acpi_bus_get_device() check in drivers/gpu/drm/i915/intel_opregion.c
References: <1451967.YMyGeCCNtu@vostro.rjw.lan> <6099377.PFvsxPeyib@vostro.rjw.lan> <5109E11A.5030400@jp.fujitsu.com> <5109E2AF.2000107@jp.fujitsu.com>
In-Reply-To: <5109E2AF.2000107@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to change subject. So I resend a patch.

---
acpi_bus_get_device() returns int not acpi_status.

The patch change not to apply ACPI_FAILURE() to the return value of
acpi_bus_get_device().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
  drivers/gpu/drm/i915/intel_opregion.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/gpu/drm/i915/intel_opregion.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/i915/intel_opregion.c	2013-01-31 11:39:37.075849905 +0900
+++ linux-pm/drivers/gpu/drm/i915/intel_opregion.c	2013-01-31 11:52:18.796850274 +0900
@@ -347,7 +347,7 @@ static void intel_didl_outputs(struct dr
  	int i = 0;
  
  	handle = DEVICE_ACPI_HANDLE(&dev->pdev->dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev)))
+	if (!handle || acpi_bus_get_device(handle, &acpi_dev))
  		return;
  
  	if (acpi_is_video_device(acpi_dev))

