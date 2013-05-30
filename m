Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965988Ab3E3Rrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:47:39 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:46667 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965718Ab3E3Rre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:47:34 -0400
Date: Thu, 30 May 2013 19:46:51 +0200
From: Alexander Holler <holler@ahsoftware.de>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: xhci: rename ambiguous named XHCI_NEC_HOST to
 XHCI_NEC_SHOW_FW
Message-ID: <20130530174648.GA25187@krabat.ahsoftware>
References: <1369862073-3685-1-git-send-email-holler@ahsoftware.de>
 <20130529222500.GC7151@xanatos>
 <51A6D2A2.30302@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51A6D2A2.30302@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 06:16:34AM +0200, Alexander Holler wrote:
> Am 30.05.2013 00:25, schrieb Sarah Sharp:
> > 
> > On Wed, May 29, 2013 at 11:14:32PM +0200, Alexander Holler wrote:
> >> Current Renesas Electronics XHCI hosts (which were formerly NEC)
> >> do support the same vendor command to show the firmware. Rename the
> >> ambigious named define XHCI_NEC_HOST to XHCI_NEC_SHOW_FW because it's
> >> only used to display the firmware version. Besides that, change the
> >> output "... NEC firmware version x.y" to "... firmware version x.y"
> >> to not confuse owners of Renesas USB hosts.
> >>
> >> (so only cosmetic, no functional changes)
> > 
> > I'm actually inclined to say you should just rip out the firmware
> > version code entirely.  I haven't needed to use it for years, and if
> > Renesas changed their vendor command set, I would rather not submit
> > random commands to the host.
> > 
> > So, can you redo this patch to just rip out XHCI_NEC_HOST and everything
> > that uses it?
> 
> Hmm, I find the firmware version rather informational and would even
> display it unconditionally (instead of with xhci_debug). It prevents the
> need to boot Windows to checkout if the latest version is installed,
> especially if someone is hunting a bug.

Below is the patch I'm using locally on top of the two previous patches.
Feel free to use/submit/merge it too.

Regards,

Alexander Holler


>From 9bf9e555600626b87371a8825c2557bdf5621e76 Mon Sep 17 00:00:00 2001
From: Alexander Holler <holler@ahsoftware.de>
Date: Thu, 30 May 2013 18:04:14 +0200
Subject: [PATCH] USB: xhci: always show the firmware version for NEC/Renesas
 hosts

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/usb/host/xhci-ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 761d566..8873b3e 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1493,7 +1493,7 @@ bandwidth_change:
 			xhci->error_bitmask |= 1 << 6;
 			break;
 		}
-		xhci_dbg(xhci, "firmware version %2x.%02x\n",
+		dev_info(xhci_to_hcd(xhci)->self.controller, "firmware version %2x.%02x\n",
 			 NEC_FW_MAJOR(le32_to_cpu(event->status)),
 			 NEC_FW_MINOR(le32_to_cpu(event->status)));
 		break;
-- 
1.8.1.4

