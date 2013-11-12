Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3KLDjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 22:39:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11748 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3KLDiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 22:38:50 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-0a-5281a2c92c00
Date: Tue, 12 Nov 2013 12:39:06 +0900
From: Kyungmin Park <kmpark@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, kay@vrfy.org
Subject: [PATCH v2] video: backlight: Remove backlight sysfs uevent
Message-id: <20131112033906.GA30454@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jAd2TixqDDB6tEbS4vPASq8WtVc/Z
	LU70fWC1uLxrDpvF7l1PWR1YPfbM/8Hq0bdlFaPH501yHh/XewawRHHZpKTmZJalFunbJXBl
	LLr/grngPHfFqdYjzA2MDzi7GDk5JARMJG7u3M0KYYtJXLi3nq2LkYtDSGARo8TL76uZIZwv
	jBLPp/5nA6kSEvCVuLanlbGLkYODRUBV4vUGbpAwm4CWxJUPe9hBbBEBD4npz44ygdjMAt4S
	h6fMAlsgLOAscezWSrA4r4CmxNoLb9ghbEGJH5PvsUDUa0ms33kcqlda4tHfGWA1ogIqElNO
	bmObwMg/C0nLLCQts5C0LGBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHKzPpHYwrmyw
	OMQowMGoxMO7g6sxSIg1say4MvcQowQHs5IIr3kuUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjv
	gVbrQCGB9MSS1OzU1ILUIpgsEwenVAOj1O/ob5lX+Sqnhafd1E6Qd4lamffvhIpVYm3JOe8H
	ejfWSt4rDeRar1e3hkfkzM6/qr4W9602bfB9+DUyO7Nomu+jNtm/ex7EXP7KpqVmt9Up/uCu
	gFcMm7+lfXD0Z90guXDmSh0/uff8r3PTY94G2Xkdnv/0TT631buDZbIOkiFLQoVKrn1XYinO
	SDTUYi4qTgQAPHFCp1ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

The most mobile phones have Ambient Light Sensors and it changes brightness according lux.
It means it changes backlight brightness frequently by just writing sysfs node, so it generates uevent.
 
Usually there's no user to use this backlight changes. But it forks udev worker threads and it takes about 5ms. The main problem is that it hurts other process activities. so remove it.

Kay said 
"Uevents are for the major, low-frequent, global device state-changes,
 not for carrying-out any sort of measurement data. Subsystems which
 need that should use other facilities like poll()-able sysfs file or
 any other subscription-based, client-tracking interface which does not
 cause overhead if it isn't used. Uevents are not the right thing to
 use here, and upstream udev should not paper-over broken kernel
 subsystems."

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v1: there's still user to use BACKLIGHT_UPDATE_SYSFS. so just remove store sysfs node uevent

---
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 94a403a..292cf99 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -172,8 +172,6 @@ static ssize_t brightness_store(struct device *dev,
 	}
 	mutex_unlock(&bd->ops_lock);
 
-	backlight_generate_event(bd, BACKLIGHT_UPDATE_SYSFS);
-
 	return rc;
 }
 static DEVICE_ATTR_RW(brightness);
