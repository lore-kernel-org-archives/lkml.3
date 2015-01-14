Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbbANIQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:16:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbbANHay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:30:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ahmed Tamrawi <ahmedtamrawi@gmail.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 3.18 090/150] cdc-acm: memory leak in error case
Date: Tue, 13 Jan 2015 23:22:41 -0800
Message-Id: <20150114072059.954375580@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit d908f8478a8d18e66c80a12adb27764920c1f1ca upstream.

If probe() fails not only the attributes need to be removed
but also the memory freed.

Reported-by: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1476,6 +1476,7 @@ alloc_fail8:
 				&dev_attr_wCountryCodes);
 		device_remove_file(&acm->control->dev,
 				&dev_attr_iCountryCodeRelDate);
+		kfree(acm->country_codes);
 	}
 	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
 alloc_fail7:


