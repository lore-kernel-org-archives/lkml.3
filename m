Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012AbaICXOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:14:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513AbaICWSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.16 007/125] uas: Limit qdepth to 32 when connected over usb-2
Date: Wed,  3 Sep 2014 15:06:04 -0700
Message-Id: <20140903220623.890436935@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit e2875c33787ebda21aeecc1a9d3ff52b3aa413ec upstream.

Some jmicron uas chipsets act up (they disconnect from the bus) when sending
more then 32 commands to them at once.

Rather then building an ever growing list with usb-id based quirks for
devices using this chipset, simply reduce the qdepth to 32 when connected
over usb-2. 32 should be plenty to keep things close to maximum
possible throughput on usb-2.

Tested-and-reported-by: Laszlo T. <tlacix@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1026,7 +1026,7 @@ static int uas_configure_endpoints(struc
 					    usb_endpoint_num(&eps[3]->desc));
 
 	if (udev->speed != USB_SPEED_SUPER) {
-		devinfo->qdepth = 256;
+		devinfo->qdepth = 32;
 		devinfo->use_streams = 0;
 	} else {
 		devinfo->qdepth = usb_alloc_streams(devinfo->intf, eps + 1,


