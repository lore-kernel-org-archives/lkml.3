Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbaF1Rwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:52:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbaF1Rwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.15 090/139] Target/iser: Wait for proper cleanup before unloading
Date: Sat, 28 Jun 2014 10:47:31 -0700
Message-Id: <20140628174609.531335330@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3289,6 +3289,7 @@ destroy_rx_wq:
 
 static void __exit isert_exit(void)
 {
+	flush_scheduled_work();
 	destroy_workqueue(isert_comp_wq);
 	destroy_workqueue(isert_rx_wq);
 	iscsit_unregister_transport(&iser_target_transport);


