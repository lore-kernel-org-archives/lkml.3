Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbaJ1HQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:16:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbaJ1DoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:44:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [PATCH 3.16 041/127] Drivers: hv: vmbus: Fix a bug in vmbus_open()
Date: Tue, 28 Oct 2014 11:34:36 +0800
Message-Id: <20141028033422.703134645@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 45d727cee9e200f5b351528b9fb063b69cf702c8 upstream.

Fix a bug in vmbus_open() and properly propagate the error. I would
like to thank Dexuan Cui <decui@microsoft.com> for identifying the
issue.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/channel.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -165,8 +165,10 @@ int vmbus_open(struct vmbus_channel *new
 	ret = vmbus_post_msg(open_msg,
 			       sizeof(struct vmbus_channel_open_channel));
 
-	if (ret != 0)
+	if (ret != 0) {
+		err = ret;
 		goto error1;
+	}
 
 	t = wait_for_completion_timeout(&open_info->waitevent, 5*HZ);
 	if (t == 0) {


