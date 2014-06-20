Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967304AbaFTNw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:52:29 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:65122 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965694AbaFTNw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:52:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/3] thunderbolt: fix format string for size_t
Date: Fri, 20 Jun 2014 15:52:11 +0200
Message-Id: <1403272331-3790755-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403272331-3790755-1-git-send-email-arnd@arndb.de>
References: <1403272331-3790755-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:IrU+fBYu2kBshyBozmxQBFtL53UQoU0Rl03IqW/Ug8k
 OsgOeQ1PWsNB9pvUp/yS3mtX64g3z0eZEq6GviftRyloZRbvLk
 eV540UeiSXG2lkjFbSmNm+NLiYPBKW3QBXVozQVHvgGCc9xyAB
 tUypxRddMRdyyS+8GL+7QPiN8HcxMi+p+J1YLJ2akwNcPQu4BK
 yG4cEoEFLneK5NeLRWjqYfvHb1TYT9CN0AqP1SbziIPXmQBOBO
 fL9ykdDHcKZn0JAV5VU+rgQia3ReK8EHhJf5cN3W3zAJEombHH
 uBZNdvrmG3BMRv03czs7rGQiiJERzsIp6KhtYjjh3PEjQtHoQm
 1TS1wi+nv3w5as84MYWVwuOoEoQXb7VvKT8cfI938
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The result of "sizeof(struct tb_drom_entry_port)" is a size_t, which
is not necessarily the same as 'long', so we should use the appropriate
%z format string instead of %l.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/thunderbolt/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index bc0449f..b133f3f 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -323,7 +323,7 @@ static int tb_drom_parse_entry(struct tb_switch *sw,
 		struct tb_drom_entry_port *entry = (void *) header;
 		if (header->len != sizeof(*entry)) {
 			tb_sw_warn(sw,
-				"port entry has size %#x (expected %#lx)\n",
+				"port entry has size %#x (expected %#zx)\n",
 				header->len, sizeof(struct tb_drom_entry_port));
 			return -EIO;
 		}
-- 
1.8.3.2

