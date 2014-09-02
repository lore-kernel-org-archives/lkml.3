Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaIBA1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:27:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:61283 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbaIBA1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:27:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="380007801"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 4/6] ACPICA: Disassembler: Fix for gpio_int interrupt polarity flags.
Date: Tue,  2 Sep 2014 08:27:27 +0800
Message-Id: <12baecbee2b8eecbbd27cda45da060bc096cfc7f.1409617516.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1409617516.git.lv.zheng@intel.com>
References: <cover.1409617516.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

The field is actually 2 bits, not 1.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/utresrc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/utresrc.c b/drivers/acpi/acpica/utresrc.c
index 14cb6c0..5cd017c 100644
--- a/drivers/acpi/acpica/utresrc.c
+++ b/drivers/acpi/acpica/utresrc.c
@@ -87,7 +87,9 @@ const char *acpi_gbl_io_decode[] = {
 
 const char *acpi_gbl_ll_decode[] = {
 	"ActiveHigh",
-	"ActiveLow"
+	"ActiveLow",
+	"ActiveBoth",
+	"Reserved"
 };
 
 const char *acpi_gbl_max_decode[] = {
-- 
1.7.10

