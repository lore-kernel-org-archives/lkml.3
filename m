Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab3H3KbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:31:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13902 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab3H3Ka6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:30:58 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-76-52207461a9b3
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Len Brown <lenb@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI / cpuidle: remove superfluous pr == NULL checks
Date: Fri, 30 Aug 2013 12:30:51 +0200
Message-id: <5858980.cRdNx0rNzu@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jQd3EEoUgg1uTBS3mfZa12PnwLZvF
	8n39jBaXd81hs/jce4TRon9hL5MDm8emVZ1sHneu7WHzeLS4hdHj8ya5AJYoLpuU1JzMstQi
	fbsErowrrfUFFwQqFt+dyNjAeIu3i5GTQ0LAROLGlx42CFtM4sK99UA2F4eQwHRGialfXrBA
	OC1MElMPbmAGqWITsJKY2L6KEcQWEZCX2LSzE6yIWWAlo8S7q5/YQRLCAq4Sf55OBrNZBFQl
	TnWtAbN5BTQlVq/dA2aLCnhKfJq0lBkiLijxY/I9FhCbGWjovv1TWSFsLYn1O48zTWDkm4Wk
	bBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7QZ9I7GFc1WBxiFOBgVOLh
	bZgqHyTEmlhWXJl7iFGCg1lJhLciVSFIiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0
	xJLU7NTUgtQimCwTB6dUA6MXp/a9MzozjyuJVm7hmbtM5eWaqexfRPW45pa8fPxKMjr7wSvx
	tVvND8vq6H4Mna23PqFxE+OmfQc/8AaaTzjVv0D+gnjjwZ/mzyziTe/8an7YKqBSbdDjsGpz
	RwDXx6zbbDouR7O3nD7z5Ks91+r2+/11bxZvtN096+BsnXodpyxe0X2v4liUWIozEg21mIuK
	EwGu2Of4TAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only acpi_processor_get_power_info_fadt() user
(acpi_processor_get_power_info()) dereferences pr before calling
the function.

The only acpi_processor_hotplug() user (acpi_cpu_soft_notify())
checks for pr == NULL before calling the function.

The only acpi_processor_cst_has_changed() user (acpi_processor_notify())
checks for pr == NULL before calling the function.

The only acpi_processor_power_init() user (__acpi_processor_start())
dereferences pr before calling the function.

Thus remove superfluous pr == NULL checks from affected functions.

Also:

While at it remove redundant brackets from acpi_processor_hotplug().

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/processor_idle.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f98dd00..35c8f2b 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -272,9 +272,6 @@ static void tsc_check_state(int state) { return; }
 static int acpi_processor_get_power_info_fadt(struct acpi_processor *pr)
 {
 
-	if (!pr)
-		return -EINVAL;
-
 	if (!pr->pblk)
 		return -ENODEV;
 
@@ -1076,12 +1073,8 @@ int acpi_processor_hotplug(struct acpi_processor *pr)
 	if (disabled_by_idle_boot_param())
 		return 0;
 
-	if (!pr)
-		return -EINVAL;
-
-	if (nocst) {
+	if (nocst)
 		return -ENODEV;
-	}
 
 	if (!pr->flags.power_setup_done)
 		return -ENODEV;
@@ -1108,9 +1101,6 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 	if (disabled_by_idle_boot_param())
 		return 0;
 
-	if (!pr)
-		return -EINVAL;
-
 	if (nocst)
 		return -ENODEV;
 
@@ -1183,9 +1173,6 @@ int acpi_processor_power_init(struct acpi_processor *pr)
 		first_run++;
 	}
 
-	if (!pr)
-		return -EINVAL;
-
 	if (acpi_gbl_FADT.cst_control && !nocst) {
 		status =
 		    acpi_os_write_port(acpi_gbl_FADT.smi_command, acpi_gbl_FADT.cst_control, 8);
-- 
1.8.2.3


