Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbaFIWpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:45:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaFIWpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 42/78] libata: Blacklist queued trim for Crucial M500
Date: Mon,  9 Jun 2014 15:48:22 -0700
Message-Id: <20140609224814.710878695@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 3b8d2676d15d6b2326757adb66b70a9cd6650373 upstream.

Queued trim only works for some users with MU05 firmware.  Revert to
blacklisting all firmware versions.

Introduced by commit d121f7d0cbb8 ("libata: Update queued trim blacklist
for M5x0 drives") which this effectively reverts, while retaining the
blacklisting of M550.

See

    https://bugzilla.kernel.org/show_bug.cgi?id=71371

for reports of trouble with MU05 firmware.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4224,10 +4224,10 @@ static const struct ata_blacklist_entry
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 
 	/* devices that don't properly handle queued TRIM commands */
-	{ "Micron_M500*",		"MU0[1-4]*",	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M500SSD*",	"MU0[1-4]*",	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Micron_M550*",		NULL,		ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M550SSD*",	NULL,		ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Micron_M500*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT???M500SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Micron_M550*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT???M550SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 
 	/*
 	 * Some WD SATA-I drives spin up and down erratically when the link


