Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbbALS2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:28:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57512 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbALSF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 049/216] cdc-acm: memory leak in error case
Date: Mon, 12 Jan 2015 18:02:46 +0000
Message-Id: <1421085933-32536-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit d908f8478a8d18e66c80a12adb27764920c1f1ca upstream.

If probe() fails not only the attributes need to be removed
but also the memory freed.

Reported-by: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 7daaef192c28..48e7a7e60937 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1470,6 +1470,7 @@ alloc_fail8:
 				&dev_attr_wCountryCodes);
 		device_remove_file(&acm->control->dev,
 				&dev_attr_iCountryCodeRelDate);
+		kfree(acm->country_codes);
 	}
 	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
 alloc_fail7:
-- 
2.1.4

