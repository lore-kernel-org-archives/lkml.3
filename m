Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab3EGELg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:11:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab3EGD6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:47 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=sy9Gx369cj0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3TuL5Nk-cTAA:10 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=2e6ZYRoF4I4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035843.092818112@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Shan Hai <shan.hai@windriver.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [013/126] libata: Use integer return value for atapi_command_packet_set
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0013-libata-Use-integer-return-value-for-atapi_command_pa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Shan Hai <shan.hai@windriver.com>

[ Upstream commit d8668fcb0b257d9fdcfbe5c172a99b8d85e1cd82 ]

The function returns type of ATAPI drives so it should return integer value.
The commit 4dce8ba94c7 (libata: Use 'bool' return value for ata_id_XXX) since
v2.6.39 changed the type of return value from int to bool, the change would
cause all of the ATAPI class drives to be treated as TYPE_TAPE and the
max_sectors of the drives to be set to 65535 because of the commit
f8d8e5799b7(libata: increase 128 KB / cmd limit for ATAPI tape drives), for the
function would return true for all ATAPI class drives and the TYPE_TAPE is
defined as 0x01.

Cc: stable@vger.kernel.org
Signed-off-by: Shan Hai <shan.hai@windriver.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index 5713d3a..b07e008 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -938,7 +938,7 @@ static inline int atapi_cdb_len(const u16 *dev_id)
 	}
 }
 
-static inline bool atapi_command_packet_set(const u16 *dev_id)
+static inline int atapi_command_packet_set(const u16 *dev_id)
 {
 	return (dev_id[ATA_ID_CONFIG] >> 8) & 0x1f;
 }
-- 
1.7.10.4


