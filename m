Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935581AbaICXQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:16:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbaICWQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.16 025/125] mei: start disconnect request timer consistently
Date: Wed,  3 Sep 2014 15:06:22 -0700
Message-Id: <20140903220624.420181028@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 22b987a325701223f9a37db700c6eb20b9924c6f upstream.

Link must be reset in case the fw doesn't
respond to client disconnect request.
We did charge the timer only in irq path
from mei_cl_irq_close and not in mei_cl_disconnect

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -491,6 +491,7 @@ int mei_cl_disconnect(struct mei_cl *cl)
 			cl_err(dev, cl, "failed to disconnect.\n");
 			goto free;
 		}
+		cl->timer_count = MEI_CONNECT_TIMEOUT;
 		mdelay(10); /* Wait for hardware disconnection ready */
 		list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
 	} else {


