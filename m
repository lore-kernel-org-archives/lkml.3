Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbaCTOLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:11:20 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:49243 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaCTOLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:11:16 -0400
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        colin.king@canonical.com, bjking1@us.ibm.com, esa@de.ibm.com,
        haver@linux.vnet.ibm.com
Subject: [PATCH 1/5] GenWQE: Enable access to VPD flash area
Date: Thu, 20 Mar 2014 15:11:02 +0100
Message-Id: <1395324666-27153-1-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032014-4966-0000-0000-000008CB55BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the two flash partitions we used so far, there is a 3rd
one which is enabled for usage by this fix.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_dev.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -531,7 +531,9 @@ static int do_flash_update(struct genwqe
 	case '1':
 		cmdopts = 0x1C;
 		break;		/* download/erase_first/part_1 */
-	case 'v':		/* cmdopts = 0x0c (VPD) */
+	case 'v':
+		cmdopts = 0x0C;
+		break;		/* download/erase_first/vpd */
 	default:
 		return -EINVAL;
 	}
@@ -665,6 +667,8 @@ static int do_flash_read(struct genwqe_f
 		cmdopts = 0x1A;
 		break;		/* upload/part_1 */
 	case 'v':
+		cmdopts = 0x0A;
+		break;		/* upload/vpd */
 	default:
 		return -EINVAL;
 	}

