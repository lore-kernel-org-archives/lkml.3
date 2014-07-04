Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbaGDWkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:40:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031215AbaGDWVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:21:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Estrin <alex.estrin@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.14 24/59] IB/qib: Fix port in pkey change event
Date: Fri,  4 Jul 2014 15:19:13 -0700
Message-Id: <20140704221540.701798423@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221539.544876024@linuxfoundation.org>
References: <20140704221539.544876024@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 911eccd284d13d78c92ec4f1f1092c03457d732a upstream.

The code used a literal 1 in dispatching an IB_EVENT_PKEY_CHANGE.

As of the dual port qib QDR card, this is not necessarily correct.

Change to use the port as specified in the call.

Reported-by: Alex Estrin <alex.estrin@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/qib/qib_mad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -1028,7 +1028,7 @@ static int set_pkeys(struct qib_devdata
 
 		event.event = IB_EVENT_PKEY_CHANGE;
 		event.device = &dd->verbs_dev.ibdev;
-		event.element.port_num = 1;
+		event.element.port_num = port;
 		ib_dispatch_event(&event);
 	}
 	return 0;


