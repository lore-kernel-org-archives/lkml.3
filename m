Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaDVM6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:58:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41221 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaDVM6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:58:11 -0400
Date: Tue, 22 Apr 2014 15:57:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com, m.chehab@samsung.com, ext-eero.nurkkala@nokia.com,
        nils.faerber@kernelconcepts.de, joni.lapilainen@gmail.com,
        freemangordon@abv.bg, sre@ring0.de, pali.rohar@gmail.com,
        Greg KH <greg@kroah.com>, trivial@kernel.org,
        linux-media@vger.kernel.org
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] radio-bcm2048.c: fix wrong overflow check
Message-ID: <20140422125726.GA30238@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201404221147.05726@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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

This patch has been floating around for four months but Pavel and Pali
are knuckle-heads and don't know how to use get_maintainer.pl so they
never send it to linux-media.

Also Pali doesn't give reporter credit and Pavel steals authorship
credit.

Also when you try explain to them about how to send patches correctly
they complain that they have been trying but it is too much work so now
I have to do it.  During the past four months thousands of other people
have been able to send patches in the correct format to the correct list
but it is too difficult for Pavel and Pali...  *sigh*.

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

