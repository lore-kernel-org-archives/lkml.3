Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaDAQKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:10:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44463 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaDAQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:10:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michele Baldessari <michele@acksyn.org>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 50/86] libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)
Date: Tue,  1 Apr 2014 09:08:03 -0700
Message-Id: <1396368519-12728-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/libata-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0dbb6c4..a93366f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4150,6 +4150,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
 	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
-- 
1.8.3.2

