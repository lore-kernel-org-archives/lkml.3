Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaGFTat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 15:30:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37421 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaGFTas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 15:30:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53B9A38F.9000609@jp.fujitsu.com>
Date: Mon, 7 Jul 2014 04:29:19 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <fengguang.wu@intel.com>, <santosh.shilimkar@ti.com>,
        <toshi.kani@hp.com>
Subject: [PATCH 1/2] firmware/memmap: pass the correct argument to firmware_map_find_entry_bootmem()
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

firmware_map_add_hotplug() calls firmware_map_find_entry_bootmem() to get
free firmware_map_entry. But end arguments is not correct. So
firmware_map_find_entry_bootmem() cannot not find firmware_map_entry.

The patch passes the correct end argument to firmware_map_find_entry_bootmem().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 drivers/firmware/memmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 17cf96c..1815849 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -286,7 +286,7 @@ int __meminit firmware_map_add_hotplug(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;

-	entry = firmware_map_find_entry_bootmem(start, end, type);
+	entry = firmware_map_find_entry_bootmem(start, end - 1, type);
 	if (!entry) {
 		entry = kzalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
 		if (!entry)

