Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3AaDWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 22:22:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53016 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3AaDWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 22:22:37 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5109E366.4090703@jp.fujitsu.com>
Date: Thu, 31 Jan 2013 12:22:14 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [RESEND PATCH 1/4] ACPI/PM: Fix acpi_bus_get_device() check in drivers/acpi/device_pm.c
References: <1451967.YMyGeCCNtu@vostro.rjw.lan> <6099377.PFvsxPeyib@vostro.rjw.lan> <5109E11A.5030400@jp.fujitsu.com> <5109E189.7040105@jp.fujitsu.com>
In-Reply-To: <5109E189.7040105@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fogot to change subject. So I resend a patch.

---
acpi_bus_get_device() returns int not acpi_status.

The patch change not to apply ACPI_FAILURE() to the return value of
acpi_bus_get_device().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
  drivers/acpi/device_pm.c |    6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c	2013-01-31 11:04:30.000000000 +0900
+++ linux-pm/drivers/acpi/device_pm.c	2013-01-31 11:28:51.366849592 +0900
@@ -213,7 +213,7 @@ int acpi_pm_device_sleep_state(struct de
  	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
  	struct acpi_device *adev;
  
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
+	if (!handle || acpi_bus_get_device(handle, &adev)) {
  		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
  		return -ENODEV;
  	}
@@ -290,7 +290,7 @@ int acpi_pm_device_run_wake(struct devic
  		return -EINVAL;
  
  	handle = DEVICE_ACPI_HANDLE(phys_dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
+	if (!handle || acpi_bus_get_device(handle, &adev)) {
  		dev_dbg(phys_dev, "ACPI handle without context in %s!\n",
  			__func__);
  		return -ENODEV;
@@ -334,7 +334,7 @@ int acpi_pm_device_sleep_wake(struct dev
  		return -EINVAL;
  
  	handle = DEVICE_ACPI_HANDLE(dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
+	if (!handle || acpi_bus_get_device(handle, &adev)) {
  		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
  		return -ENODEV;
  	}

