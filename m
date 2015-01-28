Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbbA2CfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:35:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762069AbbA2CfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:18 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 048/139] cdc-acm: memory leak in error case
Date: Wed, 28 Jan 2015 14:19:51 -0800
Message-Id: <1422483682-15393-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit d908f8478a8d18e66c80a12adb27764920c1f1ca upstream.

If probe() fails not only the attributes need to be removed
but also the memory freed.

Reported-by: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 4c43b31..8a236bf 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1326,6 +1326,7 @@ alloc_fail8:
 				&dev_attr_wCountryCodes);
 		device_remove_file(&acm->control->dev,
 				&dev_attr_iCountryCodeRelDate);
+		kfree(acm->country_codes);
 	}
 	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
 alloc_fail7:
-- 
1.9.1

