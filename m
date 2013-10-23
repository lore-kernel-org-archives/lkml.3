Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3JWTQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:16:09 -0400
Received: from smtprelay0026.hostedemail.com ([216.40.44.26]:48744 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753230Ab3JWTQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:16:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:2:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1606:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3355:3867:3868:4117:4250:4321:4605:5007:6117:6261:10004:10026:10848:11026:11232:11473:11658:11914:12043:12114:12296:12438:12517:12519:12555:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: able44_6e39a21829437
X-Filterd-Recvd-Size: 6207
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Ike Panhc <ike.pan@canonical.com>, Harald Welte <laforge@gnumonks.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net
Subject: [PATCH 6/8] platform:x86: Remove OOM message after input_allocate_device
Date: Wed, 23 Oct 2013 12:14:52 -0700
Message-Id: <93f2f693853e4409877d3d639e39b3b497738757.1382555436.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382555436.git.joe@perches.com>
References: <cover.1382555436.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emitting an OOM message isn't necessary after input_allocate_device
as there's a generic OOM and a dump_stack already done.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/asus-laptop.c        | 5 ++---
 drivers/platform/x86/eeepc-laptop.c       | 4 +---
 drivers/platform/x86/ideapad-laptop.c     | 4 +---
 drivers/platform/x86/intel_mid_powerbtn.c | 4 +---
 drivers/platform/x86/panasonic-laptop.c   | 5 +----
 drivers/platform/x86/thinkpad_acpi.c      | 1 -
 drivers/platform/x86/topstar-laptop.c     | 4 +---
 drivers/platform/x86/toshiba_acpi.c       | 4 +---
 8 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 0e9c169..594323a 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1494,10 +1494,9 @@ static int asus_input_init(struct asus_laptop *asus)
 	int error;
 
 	input = input_allocate_device();
-	if (!input) {
-		pr_warn("Unable to allocate input device\n");
+	if (!input)
 		return -ENOMEM;
-	}
+
 	input->name = "Asus Laptop extra buttons";
 	input->phys = ASUS_LAPTOP_FILE "/input0";
 	input->id.bustype = BUS_HOST;
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index aefcc32..dec68e7 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1203,10 +1203,8 @@ static int eeepc_input_init(struct eeepc_laptop *eeepc)
 	int error;
 
 	input = input_allocate_device();
-	if (!input) {
-		pr_info("Unable to allocate input device\n");
+	if (!input)
 		return -ENOMEM;
-	}
 
 	input->name = "Asus EeePC extra buttons";
 	input->phys = EEEPC_LAPTOP_FILE "/input0";
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 89c4519..d826f30 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -574,10 +574,8 @@ static int ideapad_input_init(struct ideapad_private *priv)
 	int error;
 
 	inputdev = input_allocate_device();
-	if (!inputdev) {
-		pr_info("Unable to allocate input device\n");
+	if (!inputdev)
 		return -ENOMEM;
-	}
 
 	inputdev->name = "Ideapad extra buttons";
 	inputdev->phys = "ideapad/input0";
diff --git a/drivers/platform/x86/intel_mid_powerbtn.c b/drivers/platform/x86/intel_mid_powerbtn.c
index 6b18aba..8d67752 100644
--- a/drivers/platform/x86/intel_mid_powerbtn.c
+++ b/drivers/platform/x86/intel_mid_powerbtn.c
@@ -66,10 +66,8 @@ static int mfld_pb_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	input = input_allocate_device();
-	if (!input) {
-		dev_err(&pdev->dev, "Input device allocation error\n");
+	if (!input)
 		return -ENOMEM;
-	}
 
 	input->name = pdev->name;
 	input->phys = "power-button/input0";
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 10d12b2..3008fd2 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -490,11 +490,8 @@ static int acpi_pcc_init_input(struct pcc_acpi *pcc)
 	int error;
 
 	input_dev = input_allocate_device();
-	if (!input_dev) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-				  "Couldn't allocate input device for hotkey"));
+	if (!input_dev)
 		return -ENOMEM;
-	}
 
 	input_dev->name = ACPI_PCC_DRIVER_NAME;
 	input_dev->phys = ACPI_PCC_INPUT_PHYS;
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 03ca6c1..b38ab7d 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -9056,7 +9056,6 @@ static int __init thinkpad_acpi_module_init(void)
 	mutex_init(&tpacpi_inputdev_send_mutex);
 	tpacpi_inputdev = input_allocate_device();
 	if (!tpacpi_inputdev) {
-		pr_err("unable to allocate input device\n");
 		thinkpad_acpi_module_exit();
 		return -ENOMEM;
 	} else {
diff --git a/drivers/platform/x86/topstar-laptop.c b/drivers/platform/x86/topstar-laptop.c
index 67897c8..e597de0 100644
--- a/drivers/platform/x86/topstar-laptop.c
+++ b/drivers/platform/x86/topstar-laptop.c
@@ -97,10 +97,8 @@ static int acpi_topstar_init_hkey(struct topstar_hkey *hkey)
 	int error;
 
 	input = input_allocate_device();
-	if (!input) {
-		pr_err("Unable to allocate input device\n");
+	if (!input)
 		return -ENOMEM;
-	}
 
 	input->name = "Topstar Laptop extra buttons";
 	input->phys = "topstar/input0";
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 0cfadb6..7fce391 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -975,10 +975,8 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 	u32 hci_result;
 
 	dev->hotkey_dev = input_allocate_device();
-	if (!dev->hotkey_dev) {
-		pr_info("Unable to register input device\n");
+	if (!dev->hotkey_dev)
 		return -ENOMEM;
-	}
 
 	dev->hotkey_dev->name = "Toshiba input device";
 	dev->hotkey_dev->phys = "toshiba_acpi/input0";
-- 
1.8.1.2.459.gbcd45b4.dirty

