Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576Ab3IHDU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55999 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755821Ab3IHDSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.764584425@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [068/121] USB: adutux: fix big-endian device-type reporting
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d482b9d558602a9cacab063b1c8779f9b5214da7 upstream.

Make sure the reported device-type on big-endian machines is the same as
on little-endian ones.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/adutux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -829,7 +829,7 @@ static int adu_probe(struct usb_interfac
 
 	/* let the user know what node this device is now attached to */
 	dev_info(&interface->dev, "ADU%d %s now attached to /dev/usb/adutux%d\n",
-		 udev->descriptor.idProduct, dev->serial_number,
+		 le16_to_cpu(udev->descriptor.idProduct), dev->serial_number,
 		 (dev->minor - ADU_MINOR_BASE));
 exit:
 	dbg(2," %s : leave, return value %p (dev)", __func__, dev);

