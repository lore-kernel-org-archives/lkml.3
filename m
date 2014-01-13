Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaAMO1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:27:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51268 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaAMOZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michele Baldessari <michele@acksyn.org>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 24/96] libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8
Date: Mon, 13 Jan 2014 14:23:47 +0000
Message-Id: <1389623099-18783-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michele Baldessari <michele@acksyn.org>

commit 87809942d3fa60bafb7a58d0bdb1c79e90a6821d upstream.

We've received multiple reports in Fedora via (BZ 907193)
that the Seagate Momentus SpinPoint M8 errors out when enabling AA:
[    2.555905] ata2.00: failed to enable AA (error_mask=0x1)
[    2.568482] ata2.00: failed to enable AA (error_mask=0x1)

Add the ATA_HORKAGE_BROKEN_FPDMA_AA for this specific harddisk.

Reported-by: Nicholas <arealityfarbetween@googlemail.com>
Signed-off-by: Michele Baldessari <michele@acksyn.org>
Tested-by: Nicholas <arealityfarbetween@googlemail.com>
Acked-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 705658d..92f2d3d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4105,6 +4105,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
+	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
+	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
-- 
1.8.3.2

