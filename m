Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaCGQel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:34:41 -0500
Received: from palahniuk.acksyn.org ([5.9.7.26]:44288 "EHLO
	palahniuk.acksyn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaCGQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:34:40 -0500
From: Michele Baldessari <michele@acksyn.org>
To: linux-ide@vger.kernel.org
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, guilherme.amadio@gmail.com,
        arealityfarbetween@googlemail.com,
        Michele Baldessari <michele@acksyn.org>
Subject: [PATCH] libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)
Date: Fri,  7 Mar 2014 16:34:29 +0000
Message-Id: <1394210069-26977-1-git-send-email-michele@acksyn.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Via commit 87809942d3fa "libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk
for Seagate Momentus SpinPoint M8" we added a quirk for disks named
"ST1000LM024 HN-M101MBB" with firmware revision "2AR10001".

As reported on https://bugzilla.redhat.com/show_bug.cgi?id=1073901,
we need to also add firmware revision 2BA30001 as it is broken as well.

Reported-by: Nicholas <arealityfarbetween@googlemail.com>
Signed-off-by: Michele Baldessari <michele@acksyn.org>
Tested-by: Guilherme Amadio <guilherme.amadio@gmail.com>
---
 drivers/ata/libata-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1a3dbd1b196e..87a489a22306 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4175,6 +4175,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
 	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
-- 
1.8.5.3

