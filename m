Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3AaDRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 22:17:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58063 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab3AaDRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 22:17:05 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5109E21C.4010904@jp.fujitsu.com>
Date: Thu, 31 Jan 2013 12:16:44 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 0/4] Fix acpi_bus_get_device() check
References: <1451967.YMyGeCCNtu@vostro.rjw.lan> <6099377.PFvsxPeyib@vostro.rjw.lan> <5109E11A.5030400@jp.fujitsu.com>
In-Reply-To: <5109E11A.5030400@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_bus_get_device() returns int not acpi_status.

The patch change not to apply ACPI_FAILURE() to the return value of
acpi_bus_get_device().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
  drivers/pnp/pnpacpi/core.c |   10 +++++-----
  1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-pm.orig/drivers/pnp/pnpacpi/core.c	2013-01-31 11:04:43.000000000 +0900
+++ linux-pm/drivers/pnp/pnpacpi/core.c	2013-01-31 11:38:47.659849883 +0900
@@ -90,7 +90,7 @@ static int pnpacpi_set_resources(struct
  	pnp_dbg(&dev->dev, "set resources\n");
  
  	handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev))) {
+	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
  		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
  		return -ENODEV;
  	}
@@ -123,7 +123,7 @@ static int pnpacpi_disable_resources(str
  	dev_dbg(&dev->dev, "disable resources\n");
  
  	handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev))) {
+	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
  		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
  		return 0;
  	}
@@ -145,7 +145,7 @@ static bool pnpacpi_can_wakeup(struct pn
  	acpi_handle handle;
  
  	handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev))) {
+	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
  		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
  		return false;
  	}
@@ -160,7 +160,7 @@ static int pnpacpi_suspend(struct pnp_de
  	int error = 0;
  
  	handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev))) {
+	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
  		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
  		return 0;
  	}
@@ -197,7 +197,7 @@ static int pnpacpi_resume(struct pnp_dev
  	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
  	int error = 0;
  
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev))) {
+	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
  		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
  		return -ENODEV;
  	}

