Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965904AbaCUBNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:13:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbaCUAED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 080/149] libata: use wider match for blacklisting Crucial M500
Date: Thu, 20 Mar 2014 17:04:03 -0700
Message-Id: <20140321000439.735550435@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 83493d7e782d2630f1a55def14a79f0e7c4faac3 upstream.

We're now blacklisting "Crucial_CT???M500SSD1" and
"Crucial_CT???M500SSD3".  Also, "Micron_M500*" is blacklisted which is
about the same devices as the crucial branded ones.  Let's merge the
two Crucial M500 entries and widen the match to
"Crucial_CT???M500SSD*" so that we don't have to fiddle with new
entries for similar devices.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4225,8 +4225,7 @@ static const struct ata_blacklist_entry
 
 	/* devices that don't properly handle queued TRIM commands */
 	{ "Micron_M500*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M500SSD1",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M500SSD3",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT???M500SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 
 	/*
 	 * Some WD SATA-I drives spin up and down erratically when the link


