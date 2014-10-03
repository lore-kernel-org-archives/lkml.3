Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbaJDAxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:53:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaJCVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Charles Reiss <woggling@gmail.com>
Subject: [PATCH 3.16 029/357] libata: widen Crucial M550 blacklist matching
Date: Fri,  3 Oct 2014 14:26:55 -0700
Message-Id: <20141003212934.343688390@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 2a13772a144d2956a7fedd18685921d0a9b8b783 upstream.

Crucial M550 may cause data corruption on queued trims and is
blacklisted.  The pattern used for it fails to match 1TB one as the
capacity section will be four chars instead of three.  Widen the
pattern.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Charles Reiss <woggling@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81071
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4227,7 +4227,7 @@ static const struct ata_blacklist_entry
 	{ "Micron_M500*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 	{ "Crucial_CT???M500SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 	{ "Micron_M550*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M550SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT*M550SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 
 	/*
 	 * Some WD SATA-I drives spin up and down erratically when the link


