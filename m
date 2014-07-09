Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaGHXqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:46:38 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:40509
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaGHXqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:46:33 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Tue,  8 Jul 2014 17:46:48 -0700
Message-Id: <1404866812-26950-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1404866812-26950-1-git-send-email-kys@microsoft.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Host does not handle WRITE_SAME_16; filter this command out. This patch
is required to handle large devices (greater than 2 TB disks).

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index d9d8051..428dbda 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1529,6 +1529,7 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 	switch (scsi_op) {
 	/* the host does not handle WRITE_SAME, log accident usage */
 	case WRITE_SAME:
+	case WRITE_SAME_16:
 	/*
 	 * smartd sends this command and the host does not handle
 	 * this. So, don't send it.
-- 
1.7.4.1

