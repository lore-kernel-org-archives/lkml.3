Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3CAU0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:26:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3CATpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        David Dillow <dave@thedillows.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 06/77] IB/srp: Track connection state properly
Date: Fri,  1 Mar 2013 11:43:51 -0800
Message-Id: <20130301194352.616583154@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit e1b2f13aba9ff714d23ecd4a950e744ee7ad72e1 upstream.

Remove an assignment that incorrectly overwrites the connection state
update by srp_connect_target().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Dillow <dave@thedillows.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1972,7 +1972,6 @@ static int srp_add_target(struct srp_hos
 	spin_unlock(&host->target_lock);
 
 	target->state = SRP_TARGET_LIVE;
-	target->connected = false;
 
 	scsi_scan_target(&target->scsi_host->shost_gendev,
 			 0, target->scsi_id, SCAN_WILD_CARD, 0);


