Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3AJXlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:41:45 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55381 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385Ab3AJXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:41:44 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: [PATCH 3/6] VMCI: Fix deref before NULL-check of queuepair ptr
Date: Thu, 10 Jan 2013 15:41:40 -0800
Message-Id: <1357861303-25903-3-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357861303-25903-1-git-send-email-dtor@vmware.com>
References: <1357861303-25903-1-git-send-email-dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy King <acking@vmware.com>

Check for a valid queuepair ptr before trying to lock the queuepair (which will
deref it).

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andy King <acking@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index da47e45..6417a26 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -3355,11 +3355,11 @@ ssize_t vmci_qpair_dequev(struct vmci_qp *qpair,
 {
 	ssize_t result;
 
-	qp_lock(qpair);
-
 	if (!qpair || !iov)
 		return VMCI_ERROR_INVALID_ARGS;
 
+	qp_lock(qpair);
+
 	do {
 		result = qp_dequeue_locked(qpair->produce_q,
 					   qpair->consume_q,
-- 
1.7.4.1

