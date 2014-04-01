Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaDAMBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:01:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42365 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaDALRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michele Baldessari <michele@acksyn.org>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 059/144] libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)
Date: Tue,  1 Apr 2014 12:14:23 +0100
Message-Id: <1396350948-29910-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michele Baldessari <michele@acksyn.org>

commit b28a613e9138e4b3a64649bd60b13436f4b4b49b upstream.

Via commit 87809942d3fa "libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk
for Seagate Momentus SpinPoint M8" we added a quirk for disks named
"ST1000LM024 HN-M101MBB" with firmware revision "2AR10001".

As reported on https://bugzilla.redhat.com/show_bug.cgi?id=1073901,
we need to also add firmware revision 2BA30001 as it is broken as well.

Reported-by: Nicholas <arealityfarbetween@googlemail.com>
Signed-off-by: Michele Baldessari <michele@acksyn.org>
Tested-by: Guilherme Amadio <guilherme.amadio@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/libata-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 71e85c2..ac04311 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4152,6 +4152,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
 	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
-- 
1.9.1

