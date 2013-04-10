Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937502Ab3DJXBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:01:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937435Ab3DJWuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shan Hai <shan.hai@windriver.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [ 12/29] libata: Use integer return value for atapi_command_packet_set
Date: Wed, 10 Apr 2013 15:49:30 -0700
Message-Id: <20130410224805.377523384@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224804.061806042@linuxfoundation.org>
References: <20130410224804.061806042@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


