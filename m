Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaAUWmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:42:10 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:47158 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaAUWmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:42:07 -0500
Date: Tue, 21 Jan 2014 23:42:03 +0100
From: Rob Schroer <sulamiification@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hid/wacom: fixed coding style issues
Message-ID: <20140121224203.GA12427@fedora.fritz.box>
References: <20140121195153.GA4198@fedora.fritz.box>
 <20140121200645.GC29615@core.coreip.homeip.net>
 <20140121202944.GA4554@fedora.fritz.box>
 <20140121211823.GD29615@core.coreip.homeip.net>
 <1390339554.31946.6.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390339554.31946.6.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 01:25:54PM -0800, Joe Perches wrote:
> On Tue, 2014-01-21 at 13:18 -0800, Dmitry Torokhov wrote:
> > On Tue, Jan 21, 2014 at 09:29:44PM +0100, Rob Schroer wrote:
> > > As far as I can see, kstrtoXXX() might be an alternative, but I was just
> > > fixing coding style issues, no need to break anything IMO.
> > 
> > You could do the breaking in a follow up patch ;)
> 
> Yes please.
> 
> Include the breaking of multiple statements
> into multiple lines too please like
> 
> from:
> 	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
> 		rep_data[0] = 0x03; rep_data[1] = 0x00;
> 
> to:
> 	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
> 		rep_data[0] = 0x03;
> 		rep_data[1] = 0x00;
> 
> 

Added a cosmetical linebreak, switched an occurence of sscanf to kstrtoint.

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/hid/hid-wacom.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index ebcca0d..5daf80c 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -336,7 +336,8 @@ static void wacom_set_features(struct hid_device *hdev, u8 speed)

 	switch (hdev->product) {
 	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
-		rep_data[0] = 0x03; rep_data[1] = 0x00;
+		rep_data[0] = 0x03;
+		rep_data[1] = 0x00;
 		limit = 3;
 		do {
 			ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
@@ -404,7 +405,7 @@ static ssize_t wacom_store_speed(struct device *dev,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	int new_speed;

-	if (sscanf(buf, "%1d", &new_speed) != 1)
+	if (kstrtoint(buf, 10, &new_speed))
 		return -EINVAL;

 	if (new_speed == 0 || new_speed == 1) {
--
1.8.4.2

Well, I hope this works as intended.

--
Robin
