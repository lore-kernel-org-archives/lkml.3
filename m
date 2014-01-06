Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbaAFWja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:39:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441AbaAFWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3.12 060/144] firewire: sbp2: bring back WRITE SAME support
Date: Mon,  6 Jan 2014 14:37:01 -0800
Message-Id: <20140106223747.064087046@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit ce027ed98fd176710fb14be9d6015697b62436f0 upstream.

Commit 54b2b50c20a6 "[SCSI] Disable WRITE SAME for RAID and virtual
host adapter drivers" disabled WRITE SAME support for all SBP-2 attached
targets.  But as described in the changelog of commit b0ea5f19d3d8
"firewire: sbp2: allow WRITE SAME and REPORT SUPPORTED OPERATION CODES",
it is not required to blacklist WRITE SAME.

Bring the feature back by reverting the sbp2.c hunk of commit 54b2b50c20a6.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firewire/sbp2.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1623,7 +1623,6 @@ static struct scsi_host_template scsi_dr
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
-	.no_write_same		= 1,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");


