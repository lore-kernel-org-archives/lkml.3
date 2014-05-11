Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbaEKTrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:47:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251AbaEKTXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Samuel <chris@csamuel.org>, Marc MERLIN <marc@merlins.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.14 38/83] libata: Update queued trim blacklist for M5x0 drives
Date: Sun, 11 May 2014 21:19:39 +0200
Message-Id: <20140511191912.241969634@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit d121f7d0cbb875abce249dbf7eb191f9bafe80b7 upstream.

Crucial/Micron M500 drives properly support queued DSM TRIM starting
with firmware MU05. Update the blacklist so we only disable queued trim
for older firmware releases.

Early M550 series drives suffer from the same issue as M500. A bugfix
firmware is in the pipeline but not ready yet. Until then, blacklist
queued trim for M550.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Chris Samuel <chris@csamuel.org>
Cc: Marc MERLIN <marc@merlins.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4224,8 +4224,10 @@ static const struct ata_blacklist_entry
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 
 	/* devices that don't properly handle queued TRIM commands */
-	{ "Micron_M500*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M500SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Micron_M500*",		"MU0[1-4]*",	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT???M500SSD*",	"MU0[1-4]*",	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Micron_M550*",		NULL,		ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT???M550SSD*",	NULL,		ATA_HORKAGE_NO_NCQ_TRIM, },
 
 	/*
 	 * Some WD SATA-I drives spin up and down erratically when the link


