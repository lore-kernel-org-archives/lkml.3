Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab3I3NQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:16:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11849 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3I3NQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:16:18 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-2a-524979a1423d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] x86/acpi: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 15:16:06 +0200
Message-id: <12346908.30tngvOZuc@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jQd2FlZ5BBusPa1ucbXrDbjFryl4m
	i8u75rBZfO49wmhx99RRNov+hb1MDmwei/e8ZPLo27KK0ePR4hZGjxWrv7N7fN4kF8AaxWWT
	kpqTWZZapG+XwJVx9eEDtoIHbBWzX7azNzA+YO1i5OSQEDCR+HHjFTuELSZx4d56ti5GLg4h
	gemMEvP+n4dyWpgkzrcdZwOpYhOwkpjYvooRxBYRUJZYfOU2WBGzwEpGiT3v5oIlhAVcJJ42
	vWXqYuTgYBFQlbi7VBAkzCugJbHi/B4mEFtUwFPi06SlzBBxQYkfk++xgNjMAvIS+/ZPZYWw
	tSTW7zzONIGRbxaSsllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhYn0nv
	YFzVYHGIUYCDUYmH12KpR5AQa2JZcWXuIUYJDmYlEV7xMs8gId6UxMqq1KL8+KLSnNTiQ4zS
	HCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYxLfxys+9cQKF1u7tzovUFD7OIt307FaQuu
	XIkVb/J5FDeT7cBTjhMm21fvlhHcwuDgpF54tGTLt4Nzsk++v+9hb59tayjIkB19Q/bo+9iz
	IZs2sp+Iz81bZPX20qITe/JKL0nZfPn9+7FzZmLPi/PsST6agjZFfPtVbn+2+r558r521z1e
	H22VWIozEg21mIuKEwFIbgNpUgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/x86/kernel/acpi/boot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 1f7c074..6c0b43b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -695,7 +695,7 @@ static int __init acpi_parse_sbf(struct acpi_table_header *table)
 #ifdef CONFIG_HPET_TIMER
 #include <asm/hpet.h>
 
-static struct __initdata resource *hpet_res;
+static struct resource *hpet_res __initdata;
 
 static int __init acpi_parse_hpet(struct acpi_table_header *table)
 {
-- 
1.8.2.3


