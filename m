Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaDVEAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:00:19 -0400
Received: from ozlabs.org ([103.22.144.67]:55016 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbaDVD7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:59:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: [PATCH 7/9] drivers/hid/hid-picolcd_fb: avoid world-writable sysfs files.
Date: Tue, 22 Apr 2014 13:03:30 +0930
Message-Id: <1398137612-9714-8-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In line with practice for module parameters, we're adding a build-time
check that sysfs files aren't world-writable.

Cc: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/hid/hid-picolcd_fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
index c930ab8554ea..7f965e231433 100644
--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -501,7 +501,7 @@ static ssize_t picolcd_fb_update_rate_store(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(fb_update_rate, 0666, picolcd_fb_update_rate_show,
+static DEVICE_ATTR(fb_update_rate, 0664, picolcd_fb_update_rate_show,
 		picolcd_fb_update_rate_store);
 
 /* initialize Framebuffer device */
-- 
1.8.3.2

