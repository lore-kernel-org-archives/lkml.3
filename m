Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbaF1S6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:58:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaF1Rs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 76/77] Target/iser: Wait for proper cleanup before unloading
Date: Sat, 28 Jun 2014 10:47:09 -0700
Message-Id: <20140628174525.605645640@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit f5ebec9629cf78eeeea4b8258882a9f439ab2404 upstream.

disconnected_handler works are scheduled on system_wq.
When attempting to unload, first make sure all works
have cleaned up.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2332,6 +2332,7 @@ destroy_rx_wq:
 
 static void __exit isert_exit(void)
 {
+	flush_scheduled_work();
 	kmem_cache_destroy(isert_cmd_cache);
 	destroy_workqueue(isert_comp_wq);
 	destroy_workqueue(isert_rx_wq);


