Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaDTO43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 10:56:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53854 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaDTO4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 10:56:24 -0400
Date: Sun, 20 Apr 2014 16:56:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: hans.verkuil@cisco.com, m.chehab@samsung.com, ext-eero.nurkkala@nokia.com,
        nils.faerber@kernelconcepts.de, joni.lapilainen@gmail.com,
        freemangordon@abv.bg, sre@ring0.de, dan.carpenter@oracle.com,
        pali.rohar@gmail.com, Greg KH <greg@kroah.com>, trivial@kernel.org
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] radio-bcm2048.c: fix wrong overflow check
Message-ID: <20140420145622.GA15567@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix wrong overflow check in radio-bcm2048.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>


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
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
