Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3CRVGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:06:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab3CRVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: [ 07/75] usb: dwc3: core: dont forget to free coherent memory
Date: Mon, 18 Mar 2013 14:06:30 -0700
Message-Id: <20130318210510.788591416@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit d9b4330adec006c2e8907bdcacd9dcc0e8874d18 upstream.

commit 3921426 (usb: dwc3: core: move
event buffer allocation out of
dwc3_core_init()) introduced a memory leak
of the coherent memory we use as event
buffers on dwc3 driver.

If the driver is compiled as a dynamically
loadable module and use constantly loads
and unloads the driver, we will continue
to leak the coherent memory allocated during
->probe() because dwc3_free_event_buffers()
is never called during ->remove().

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -575,6 +575,7 @@ static int dwc3_remove(struct platform_d
 		break;
 	}
 
+	dwc3_free_event_buffers(dwc);
 	dwc3_core_exit(dwc);
 
 	return 0;


