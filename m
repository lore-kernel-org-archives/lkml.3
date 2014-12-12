Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbaLLGS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:18:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52419 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759517AbaLLGSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:18:06 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sitsofe Wheeler" <sitsofe@yahoo.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.278990834@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 022/164] Drivers: hv: vmbus: Fix a bug in vmbus_open()
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 45d727cee9e200f5b351528b9fb063b69cf702c8 upstream.

Fix a bug in vmbus_open() and properly propagate the error. I would
like to thank Dexuan Cui <decui@microsoft.com> for identifying the
issue.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hv/channel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -207,8 +207,10 @@ int vmbus_open(struct vmbus_channel *new
 	ret = vmbus_post_msg(open_msg,
 			       sizeof(struct vmbus_channel_open_channel));
 
-	if (ret != 0)
+	if (ret != 0) {
+		err = ret;
 		goto error1;
+	}
 
 	t = wait_for_completion_timeout(&open_info->waitevent, 5*HZ);
 	if (t == 0) {

