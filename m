Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab3JNOuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:50:37 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:62724 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab3JNOue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:50:34 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the spi tree
Date: Mon, 14 Oct 2013 16:48:08 +0200
Message-Id: <1381762088-18880-8-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381762088-18880-1-git-send-email-treding@nvidia.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the spi tree got a conflict in

	drivers/spi/spi.c

Caused by commits cf9eb39 (spi: Fix modalias for ACPI enumerated SPI devices)
and 33cf00e (spi: attach/detach SPI device to the ACPI power domain).

I fixed it up (see below). Please verify that the resolution looks good.

Thanks,
Thierry
---
diff --cc drivers/spi/spi.c
index 740f9dd,2d29dee..8a0fc92
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@@ -1037,10 -1143,8 +1155,10 @@@ static acpi_status acpi_spi_add_device(
  		return AE_OK;
  	}
  
 +	adev->power.flags.ignore_parent = true;
- 	strlcpy(spi->modalias, dev_name(&adev->dev), sizeof(spi->modalias));
+ 	strlcpy(spi->modalias, acpi_device_hid(adev), sizeof(spi->modalias));
  	if (spi_add_device(spi)) {
 +		adev->power.flags.ignore_parent = false;
  		dev_err(&master->dev, "failed to add SPI device %s from ACPI\n",
  			dev_name(&adev->dev));
  		spi_dev_put(spi);
