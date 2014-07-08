Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaGHTeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:34:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932566AbaGHTeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mike Marciniszyn" <mike.marciniszyn@intel.com>,
        "Alex Estrin" <alex.estrin@intel.com>,
        "Dennis Dalessandro" <dennis.dalessandro@intel.com>,
        "Roland Dreier" <roland@purestorage.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.583610007@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 022/125] IB/qib: Fix port in pkey change event
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/hw/qib/qib_mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -1007,7 +1007,7 @@ static int set_pkeys(struct qib_devdata
 
 		event.event = IB_EVENT_PKEY_CHANGE;
 		event.device = &dd->verbs_dev.ibdev;
-		event.element.port_num = 1;
+		event.element.port_num = port;
 		ib_dispatch_event(&event);
 	}
 	return 0;

