Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaCaNrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:47:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35609 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbaCaNXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michele Baldessari <michele@acksyn.org>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 22/71] libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)
Date: Mon, 31 Mar 2014 14:22:28 +0100
Message-Id: <1396272197-13394-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

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
index f1e3b76..f3d75fe 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4107,6 +4107,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
 	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
-- 
1.9.1

