Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3FXTcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:32:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:47644 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3FXTcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:32:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>
Subject: [PATCH 27/32] acpi: delete __cpuinit usage from all acpi files
Date: Mon, 24 Jun 2013 15:30:32 -0400
Message-ID: <1372102237-8757-28-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

This removes all the drivers/acpi uses of the __cpuinit macros
from all C files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 drivers/acpi/acpi_processor.c   | 2 +-
 drivers/acpi/processor_core.c   | 8 ++++----
 drivers/acpi/processor_driver.c | 8 ++++----
 drivers/acpi/processor_idle.c   | 6 ++----
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index e9b01e3..fd6c51c 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -340,7 +340,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
  */
 static DEFINE_PER_CPU(void *, processor_device_array);
 
-static int __cpuinit acpi_processor_add(struct acpi_device *device,
+static int acpi_processor_add(struct acpi_device *device,
 					const struct acpi_device_id *id)
 {
 	struct acpi_processor *pr;
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 164d495..a5e9f4a 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -253,7 +253,7 @@ static bool __init processor_physically_present(acpi_handle handle)
 	return true;
 }
 
-static void __cpuinit acpi_set_pdc_bits(u32 *buf)
+static void acpi_set_pdc_bits(u32 *buf)
 {
 	buf[0] = ACPI_PDC_REVISION_ID;
 	buf[1] = 1;
@@ -265,7 +265,7 @@ static void __cpuinit acpi_set_pdc_bits(u32 *buf)
 	arch_acpi_set_pdc_bits(buf);
 }
 
-static struct acpi_object_list *__cpuinit acpi_processor_alloc_pdc(void)
+static struct acpi_object_list *acpi_processor_alloc_pdc(void)
 {
 	struct acpi_object_list *obj_list;
 	union acpi_object *obj;
@@ -308,7 +308,7 @@ static struct acpi_object_list *__cpuinit acpi_processor_alloc_pdc(void)
  * _PDC is required for a BIOS-OS handshake for most of the newer
  * ACPI processor features.
  */
-static int __cpuinit
+static int
 acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
 {
 	acpi_status status = AE_OK;
@@ -336,7 +336,7 @@ acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
 	return status;
 }
 
-void __cpuinit acpi_processor_set_pdc(acpi_handle handle)
+void acpi_processor_set_pdc(acpi_handle handle)
 {
 	struct acpi_object_list *obj_list;
 
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index d93963f..e1acb47 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -124,9 +124,9 @@ static void acpi_processor_notify(acpi_handle handle, u32 event, void *data)
 	return;
 }
 
-static __cpuinit int __acpi_processor_start(struct acpi_device *device);
+static int __acpi_processor_start(struct acpi_device *device);
 
-static int __cpuinit acpi_cpu_soft_notify(struct notifier_block *nfb,
+static int acpi_cpu_soft_notify(struct notifier_block *nfb,
 					  unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -168,7 +168,7 @@ static struct notifier_block __refdata acpi_cpu_notifier =
 	    .notifier_call = acpi_cpu_soft_notify,
 };
 
-static __cpuinit int __acpi_processor_start(struct acpi_device *device)
+static int __acpi_processor_start(struct acpi_device *device)
 {
 	struct acpi_processor *pr = acpi_driver_data(device);
 	acpi_status status;
@@ -232,7 +232,7 @@ static __cpuinit int __acpi_processor_start(struct acpi_device *device)
 	return result;
 }
 
-static int __cpuinit acpi_processor_start(struct device *dev)
+static int acpi_processor_start(struct device *dev)
 {
 	struct acpi_device *device;
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0461ccc..f98dd00 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -96,9 +96,7 @@ static int set_max_cstate(const struct dmi_system_id *id)
 	return 0;
 }
 
-/* Actually this shouldn't be __cpuinitdata, would be better to fix the
-   callers to only run once -AK */
-static struct dmi_system_id __cpuinitdata processor_power_dmi_table[] = {
+static struct dmi_system_id processor_power_dmi_table[] = {
 	{ set_max_cstate, "Clevo 5600D", {
 	  DMI_MATCH(DMI_BIOS_VENDOR,"Phoenix Technologies LTD"),
 	  DMI_MATCH(DMI_BIOS_VERSION,"SHE845M0.86C.0013.D.0302131307")},
@@ -1165,7 +1163,7 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 
 static int acpi_processor_registered;
 
-int __cpuinit acpi_processor_power_init(struct acpi_processor *pr)
+int acpi_processor_power_init(struct acpi_processor *pr)
 {
 	acpi_status status = 0;
 	int retval;
-- 
1.8.1.2

