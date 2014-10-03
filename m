Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbaJDAgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:36:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbaJCVmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Knibbs <markk@clara.co.uk>
Subject: [PATCH 3.16 137/357] USB: storage: Add quirk for Ariston Technologies iConnect USB to SCSI adapter
Date: Fri,  3 Oct 2014 14:28:43 -0700
Message-Id: <20141003212937.583507339@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark <markk@clara.co.uk>

commit b6a3ed677991558ce09046397a7c4d70530d15b3 upstream.

Hi,

The Ariston Technologies iConnect 025 and iConnect 050 (also known as e.g.
iSCSI-50) are SCSI-USB converters which use Shuttle Technology/SCM
Microsystems chips. Only the connectors differ; both have the same USB ID.
The US_FL_SCM_MULT_TARG quirk is required to use SCSI devices with ID other
than 0.

I don't have one of these, but based on the other entries for Shuttle/
SCM-based converters this patch is very likely correct. I used 0x0000 and
0x9999 for bcdDeviceMin and bcdDeviceMax because I'm not sure which
bcdDevice value the products use.

Signed-off-by: Mark Knibbs <markk@clara.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1986,6 +1986,12 @@ UNUSUAL_DEV(  0x177f, 0x0400, 0x0000, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
 
+UNUSUAL_DEV(  0x1822, 0x0001, 0x0000, 0x9999,
+		"Ariston Technologies",
+		"iConnect USB to SCSI adapter",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
 /* Reported by Hans de Goede <hdegoede@redhat.com>
  * These Appotech controllers are found in Picture Frames, they provide a
  * (buggy) emulation of a cdrom drive which contains the windows software


