Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab3CRVPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:15:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab3CRVKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 28/40] hwmon: (sht15) Fix memory leak if regulator_enable() fails
Date: Mon, 18 Mar 2013 14:11:06 -0700
Message-Id: <20130318211018.279265089@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Commit 3e78080f8148 ('hwmon: (sht15) Check return value of
regulator_enable()') depends on the use of devm_kmalloc() for automatic
resource cleanup in the failure cases, which was introduced in 3.7.  In
older stable branches, explicit cleanup is needed.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Applies to stable branches between 3.0 and 3.6 where commit 3e78080f8148
has been applied.

 drivers/hwmon/sht15.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -930,7 +930,7 @@ static int __devinit sht15_probe(struct
 		if (ret != 0) {
 			dev_err(&pdev->dev,
 				"failed to enable regulator: %d\n", ret);
-			return ret;
+			goto err_free_data;
 		}
 
 		/*


