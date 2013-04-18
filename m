Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967553Ab3DRJiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:38:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40055 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab3DRJRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shan Hai <shan.hai@windriver.com>, Jeff Garzik <jgarzik@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 14/72] libata: Use integer return value for atapi_command_packet_set
Date: Thu, 18 Apr 2013 10:15:59 +0100
Message-Id: <1366276617-3553-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shan Hai <shan.hai@windriver.com>

commit d8668fcb0b257d9fdcfbe5c172a99b8d85e1cd82 upstream.

The function returns type of ATAPI drives so it should return integer value.
The commit 4dce8ba94c7 (libata: Use 'bool' return value for ata_id_XXX) since
v2.6.39 changed the type of return value from int to bool, the change would
cause all of the ATAPI class drives to be treated as TYPE_TAPE and the
max_sectors of the drives to be set to 65535 because of the commit
f8d8e5799b7(libata: increase 128 KB / cmd limit for ATAPI tape drives), for the
function would return true for all ATAPI class drives and the TYPE_TAPE is
defined as 0x01.

Signed-off-by: Shan Hai <shan.hai@windriver.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/ata.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index 32df2b6..5856c9e 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -937,7 +937,7 @@ static inline int atapi_cdb_len(const u16 *dev_id)
 	}
 }
 
-static inline bool atapi_command_packet_set(const u16 *dev_id)
+static inline int atapi_command_packet_set(const u16 *dev_id)
 {
 	return (dev_id[ATA_ID_CONFIG] >> 8) & 0x1f;
 }
-- 
1.8.1.2

