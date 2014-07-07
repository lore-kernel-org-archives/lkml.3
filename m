Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaGGTju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:39:50 -0400
Received: from mail1.windriver.com ([147.11.146.13]:49927 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaGGTjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:39:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
CC: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] acpi/osl: clear high bits in acpi_os_read_memory value
Date: Mon, 7 Jul 2014 15:38:53 -0400
Message-ID: <1404761933-27300-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one looks at acpi_os_read_port() it is very similar to the
acpi_os_read_memory() aside from the underlying I/O method.
However we zero out the u32 in the former and not in the latter,
when it seems prudent to do so in both.

This was found by quasi-random code inspection, and as such there
is no known symptom or bug to associate with possibly having stale
data in the high bits of "value".

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/acpi/osl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index bad25b070fe0..a7373f1f31c8 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -953,6 +953,7 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 	if (!value)
 		value = &dummy;
 
+	*value = 0;
 	switch (width) {
 	case 8:
 		*(u8 *) value = readb(virt_addr);
-- 
1.9.2

