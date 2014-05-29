Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaE2TLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaE2TLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:11:38 -0400
Date: Thu, 29 May 2014 15:11:30 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk
Subject: block: remove dead code in scsi_ioctl:blk_verify_command
Message-ID: <20140529191130.GA10405@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org, axboe@kernel.dk
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

filter gets assigned the address of blk_default_cmd_filter on
entry to this function, so the !filter condition can never be true.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 26487972ac54..9c28a5b38042 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -205,10 +205,6 @@ int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
 	if (capable(CAP_SYS_RAWIO))
 		return 0;
 
-	/* if there's no filter set, assume we're filtering everything out */
-	if (!filter)
-		return -EPERM;
-
 	/* Anybody who can open the device can do a read-safe command */
 	if (test_bit(cmd[0], filter->read_ok))
 		return 0;
