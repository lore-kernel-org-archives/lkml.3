Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3DVO3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51424 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214Ab3DVO3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jeff Garzik" <jgarzik@redhat.com>,
        "Shan Hai" <shan.hai@windriver.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.533505146@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [20/75] libata: Use integer return value for atapi_command_packet_set
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/ata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -937,7 +937,7 @@ static inline int atapi_cdb_len(const u1
 	}
 }
 
-static inline bool atapi_command_packet_set(const u16 *dev_id)
+static inline int atapi_command_packet_set(const u16 *dev_id)
 {
 	return (dev_id[ATA_ID_CONFIG] >> 8) & 0x1f;
 }

