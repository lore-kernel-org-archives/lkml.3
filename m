Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbaAVOse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:48:34 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:46985 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbaAVOsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:48:32 -0500
Date: Wed, 22 Jan 2014 15:48:24 +0100
From: Rob Schroer <sulamiification@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hid/wacom: fixed coding style issues
Message-ID: <20140122144824.GA15985@hal9k.fritz.box>
References: <20140121195153.GA4198@fedora.fritz.box>
 <20140121200645.GC29615@core.coreip.homeip.net>
 <20140121202944.GA4554@fedora.fritz.box>
 <20140121211823.GD29615@core.coreip.homeip.net>
 <1390339554.31946.6.camel@joe-AO722>
 <20140121224203.GA12427@fedora.fritz.box>
 <20140122064045.GA4143@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140122064045.GA4143@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:40:45PM -0800, Dmitry Torokhov wrote:
> I think this should be
>
> 	error = kstrtoint(buf, 10, &new_speed);
> 	if (error)
> 		return error;
>

I just lost my SSD/branch, so here is a fresh patch for mainline:

Fixed some coding style issues, removed unessecary spaces, added
linebreaks, converted an occurence of sscanf to kstrtoint.

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/hid/hid-wacom.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 60c75dc..c7f9d1c 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -77,8 +77,8 @@ static void wacom_scramble(__u8 *image)
 	__u16 mask;
 	__u16 s1;
 	__u16 s2;
-	__u16 r1 ;
-	__u16 r2 ;
+	__u16 r1;
+	__u16 r2;
 	__u16 r;
 	__u8 buf[256];
 	int i, w, x, y, z;
@@ -336,7 +336,8 @@ static void wacom_set_features(struct hid_device *hdev, u8 speed)

 	switch (hdev->product) {
 	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
-		rep_data[0] = 0x03 ; rep_data[1] = 0x00;
+		rep_data[0] = 0x03;
+		rep_data[1] = 0x00;
 		limit = 3;
 		do {
 			ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
@@ -403,9 +404,11 @@ static ssize_t wacom_store_speed(struct device *dev,
 {
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	int new_speed;
+	int error;

-	if (sscanf(buf, "%1d", &new_speed ) != 1)
-		return -EINVAL;
+	error = kstrtoint(buf, 10, &new_speed);
+	if (error)
+		return error;

 	if (new_speed == 0 || new_speed == 1) {
 		wacom_set_features(hdev, new_speed);
--
1.8.4.2

--
Robin
