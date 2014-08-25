Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaHYIsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:48:21 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:55828 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaHYIsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:48:19 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] regulator: Proofread documentation
Date: Mon, 25 Aug 2014 10:47:51 +0200
Message-Id: <1408956471-16579-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/power/regulator/consumer.txt  | 7 ++++---
 Documentation/power/regulator/design.txt    | 8 ++++----
 Documentation/power/regulator/machine.txt   | 4 ++--
 Documentation/power/regulator/overview.txt  | 6 +++---
 Documentation/power/regulator/regulator.txt | 6 +++---
 5 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/Documentation/power/regulator/consumer.txt b/Documentation/power/regulator/consumer.txt
index 81c0e2b49cd8..8afb236ca765 100644
--- a/Documentation/power/regulator/consumer.txt
+++ b/Documentation/power/regulator/consumer.txt
@@ -143,8 +143,9 @@ This will cause the core to recalculate the total load on the regulator (based
 on all its consumers) and change operating mode (if necessary and permitted)
 to best match the current operating load.
 
-The load_uA value can be determined from the consumers datasheet. e.g.most
-datasheets have tables showing the max current consumed in certain situations.
+The load_uA value can be determined from the consumer's datasheet. e.g. most
+datasheets have tables showing the maximum current consumed in certain
+situations.
 
 Most consumers will use indirect operating mode control since they have no
 knowledge of the regulator or whether the regulator is shared with other
@@ -173,7 +174,7 @@ Consumers can register interest in regulator events by calling :-
 int regulator_register_notifier(struct regulator *regulator,
 			      struct notifier_block *nb);
 
-Consumers can uregister interest by calling :-
+Consumers can unregister interest by calling :-
 
 int regulator_unregister_notifier(struct regulator *regulator,
 				struct notifier_block *nb);
diff --git a/Documentation/power/regulator/design.txt b/Documentation/power/regulator/design.txt
index f9b56b72b782..fdd919b96830 100644
--- a/Documentation/power/regulator/design.txt
+++ b/Documentation/power/regulator/design.txt
@@ -9,14 +9,14 @@ Safety
 
  - Errors in regulator configuration can have very serious consequences
    for the system, potentially including lasting hardware damage.
- - It is not possible to automatically determine the power confugration
+ - It is not possible to automatically determine the power configuration
    of the system - software-equivalent variants of the same chip may
-   have different power requirments, and not all components with power
+   have different power requirements, and not all components with power
    requirements are visible to software.
 
   => The API should make no changes to the hardware state unless it has
-     specific knowledge that these changes are safe to do perform on
-     this particular system.
+     specific knowledge that these changes are safe to perform on this
+     particular system.
 
 Consumer use cases
 ------------------
diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.txt
index ce63af0a8e35..757e3b53dc11 100644
--- a/Documentation/power/regulator/machine.txt
+++ b/Documentation/power/regulator/machine.txt
@@ -11,7 +11,7 @@ Consider the following machine :-
                +-> [Consumer B @ 3.3V]
 
 The drivers for consumers A & B must be mapped to the correct regulator in
-order to control their power supply. This mapping can be achieved in machine
+order to control their power supplies. This mapping can be achieved in machine
 initialisation code by creating a struct regulator_consumer_supply for
 each regulator.
 
@@ -39,7 +39,7 @@ to the 'Vcc' supply for Consumer A.
 
 Constraints can now be registered by defining a struct regulator_init_data
 for each regulator power domain. This structure also maps the consumers
-to their supply regulator :-
+to their supply regulators :-
 
 static struct regulator_init_data regulator1_data = {
 	.constraints = {
diff --git a/Documentation/power/regulator/overview.txt b/Documentation/power/regulator/overview.txt
index 8ed17587a74b..40ca2d6e2742 100644
--- a/Documentation/power/regulator/overview.txt
+++ b/Documentation/power/regulator/overview.txt
@@ -36,11 +36,11 @@ Some terms used in this document:-
                    Consumers can be classified into two types:-
 
                    Static: consumer does not change its supply voltage or
-                   current limit. It only needs to enable or disable it's
+                   current limit. It only needs to enable or disable its
                    power supply. Its supply voltage is set by the hardware,
                    bootloader, firmware or kernel board initialisation code.
 
-                   Dynamic: consumer needs to change it's supply voltage or
+                   Dynamic: consumer needs to change its supply voltage or
                    current limit to meet operation demands.
 
 
@@ -156,7 +156,7 @@ relevant to non SoC devices and is split into the following four interfaces:-
       This interface is for machine specific code and allows the creation of
       voltage/current domains (with constraints) for each regulator. It can
       provide regulator constraints that will prevent device damage through
-      overvoltage or over current caused by buggy client drivers. It also
+      overvoltage or overcurrent caused by buggy client drivers. It also
       allows the creation of a regulator tree whereby some regulators are
       supplied by others (similar to a clock tree).
 
diff --git a/Documentation/power/regulator/regulator.txt b/Documentation/power/regulator/regulator.txt
index 13902778ae44..b17e5833ce21 100644
--- a/Documentation/power/regulator/regulator.txt
+++ b/Documentation/power/regulator/regulator.txt
@@ -13,7 +13,7 @@ Drivers can register a regulator by calling :-
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 					 const struct regulator_config *config);
 
-This will register the regulators capabilities and operations to the regulator
+This will register the regulator's capabilities and operations to the regulator
 core.
 
 Regulators can be unregistered by calling :-
@@ -23,8 +23,8 @@ void regulator_unregister(struct regulator_dev *rdev);
 
 Regulator Events
 ================
-Regulators can send events (e.g. over temp, under voltage, etc) to consumer
-drivers by calling :-
+Regulators can send events (e.g. overtemperature, undervoltage, etc) to
+consumer drivers by calling :-
 
 int regulator_notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data);
-- 
1.9.1

