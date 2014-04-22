Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbaDVPDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:03:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20353 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaDVPDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:03:42 -0400
Date: Tue, 22 Apr 2014 18:02:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com, m.chehab@samsung.com, ext-eero.nurkkala@nokia.com,
        nils.faerber@kernelconcepts.de, joni.lapilainen@gmail.com,
        freemangordon@abv.bg, sre@ring0.de, pali.rohar@gmail.com,
        Greg KH <greg@kroah.com>, trivial@kernel.org,
        linux-media@vger.kernel.org
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] [media] radio-bcm2048: fix wrong overflow check
Message-ID: <20140422150239.GA32637@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140422125726.GA30238@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

This patch fixes an off by one check in bcm2048_set_region().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Send it to the correct list.  Re-work the changelog.
v3: Correct subsystem prefix.

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index b2cd3a8..bbf236e 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -737,7 +737,7 @@ static int bcm2048_set_region(struct bcm2048_device *bdev, u8 region)
 	int err;
 	u32 new_frequency = 0;
 
-	if (region > ARRAY_SIZE(region_configs))
+	if (region >= ARRAY_SIZE(region_configs))
 		return -EINVAL;
 
 	mutex_lock(&bdev->mutex);

-- 

