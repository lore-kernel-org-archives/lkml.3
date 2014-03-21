Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966232AbaCUBOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:14:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964898AbaCUAEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marios Andreopoulos <opensource@andmarios.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.13 078/149] libata: disable queued TRIM for Crucial M500 mSATA SSDs
Date: Thu, 20 Mar 2014 17:04:01 -0700
Message-Id: <20140321000439.666831422@linuxfoundation.org>
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

From: Marios Andreopoulos <opensource@andmarios.com>

commit 2564338b13e6e132ee224edb63e1e872adf431f4 upstream.

Queued TRIM commands cause problems and silent file system corruption
on Crucial M500 SSDs. This patch disables them for the mSATA model of
the drive.

Signed-off-by: Marios Andreopoulos <opensource@andmarios.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=71371
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4225,6 +4225,7 @@ static const struct ata_blacklist_entry
 	/* devices that don't properly handle queued TRIM commands */
 	{ "Micron_M500*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 	{ "Crucial_CT???M500SSD1",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT???M500SSD3",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 
 	/*
 	 * Some WD SATA-I drives spin up and down erratically when the link


