Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaGITGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:06:04 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48538 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaGITGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:06:02 -0400
Message-ID: <53BD942A.2070106@gmail.com>
Date: Wed, 09 Jul 2014 21:12:42 +0200
From: Roald Frederickx <roald.frederickx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: platform-driver-x86@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] compal-laptop: correct invalid hwmon name
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roald Frederickx <roald.frederickx@gmail.com>

Change the name of the hwmon interface from "compal-laptop" to "compal". 
A dash is an invalid character for a hwmon name and caused the call to 
hwmon_device_register_with_groups() to fail.

Signed-off-by: Roald Frederickx <roald.frederickx@gmail.com>
---

diff --git a/drivers/platform/x86/compal-laptop.c 
b/drivers/platform/x86/compal-laptop.c
index 7297df2..26bfd7b 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -1028,7 +1028,7 @@ static int compal_probe(struct platform_device *pdev)
  		return err;

  	hwmon_dev = hwmon_device_register_with_groups(&pdev->dev,
-						      DRIVER_NAME, data,
+						      "compal", data,
  						      compal_hwmon_groups);
  	if (IS_ERR(hwmon_dev)) {
  		err = PTR_ERR(hwmon_dev);

