Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbbAARLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:11:09 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:47831 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbbAARLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:11:08 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-omap2: voltage.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:06:34 +0100
Message-Id: <1420131994-31636-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
voltdm_for_each_pwrdm() omap_change_voltscale_method()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-omap2/voltage.c |   65 ++---------------------------------------
 arch/arm/mach-omap2/voltage.h |    5 ----
 2 files changed, 3 insertions(+), 67 deletions(-)

diff --git a/arch/arm/mach-omap2/voltage.c b/arch/arm/mach-omap2/voltage.c
index 3783b86..43e42fd 100644
--- a/arch/arm/mach-omap2/voltage.c
+++ b/arch/arm/mach-omap2/voltage.c
@@ -224,37 +224,6 @@ int omap_voltage_register_pmic(struct voltagedomain *voltdm,
 }
 
 /**
- * omap_change_voltscale_method() - API to change the voltage scaling method.
- * @voltdm:	pointer to the VDD whose voltage scaling method
- *		has to be changed.
- * @voltscale_method:	the method to be used for voltage scaling.
- *
- * This API can be used by the board files to change the method of voltage
- * scaling between vpforceupdate and vcbypass. The parameter values are
- * defined in voltage.h
- */
-void omap_change_voltscale_method(struct voltagedomain *voltdm,
-				  int voltscale_method)
-{
-	if (!voltdm || IS_ERR(voltdm)) {
-		pr_warn("%s: VDD specified does not exist!\n", __func__);
-		return;
-	}
-
-	switch (voltscale_method) {
-	case VOLTSCALE_VPFORCEUPDATE:
-		voltdm->scale = omap_vp_forceupdate_scale;
-		return;
-	case VOLTSCALE_VCBYPASS:
-		voltdm->scale = omap_vc_bypass_scale;
-		return;
-	default:
-		pr_warn("%s: Trying to change the method of voltage scaling to an unsupported one!\n",
-			__func__);
-	}
-}
-
-/**
  * omap_voltage_late_init() - Init the various voltage parameters
  *
  * This API is to be called in the later stages of the
@@ -321,10 +290,9 @@ static struct voltagedomain *_voltdm_lookup(const char *name)
  * @voltdm: struct voltagedomain * to add the powerdomain to
  * @pwrdm: struct powerdomain * to associate with a voltagedomain
  *
- * Associate the powerdomain @pwrdm with a voltagedomain @voltdm.  This
- * enables the use of voltdm_for_each_pwrdm().  Returns -EINVAL if
- * presented with invalid pointers; -ENOMEM if memory could not be allocated;
- * or 0 upon success.
+ * Associate the powerdomain @pwrdm with a voltagedomain @voltdm.
+ * Returns -EINVAL if presented with invalid pointers;
+ * -ENOMEM if memory could not be allocated; or 0 upon success.
  */
 int voltdm_add_pwrdm(struct voltagedomain *voltdm, struct powerdomain *pwrdm)
 {
@@ -340,33 +308,6 @@ int voltdm_add_pwrdm(struct voltagedomain *voltdm, struct powerdomain *pwrdm)
 }
 
 /**
- * voltdm_for_each_pwrdm - call function for each pwrdm in a voltdm
- * @voltdm: struct voltagedomain * to iterate over
- * @fn: callback function *
- *
- * Call the supplied function @fn for each powerdomain in the
- * voltagedomain @voltdm.  Returns -EINVAL if presented with invalid
- * pointers; or passes along the last return value of the callback
- * function, which should be 0 for success or anything else to
- * indicate failure.
- */
-int voltdm_for_each_pwrdm(struct voltagedomain *voltdm,
-			  int (*fn)(struct voltagedomain *voltdm,
-				    struct powerdomain *pwrdm))
-{
-	struct powerdomain *pwrdm;
-	int ret = 0;
-
-	if (!fn)
-		return -EINVAL;
-
-	list_for_each_entry(pwrdm, &voltdm->pwrdm_list, voltdm_node)
-		ret = (*fn)(voltdm, pwrdm);
-
-	return ret;
-}
-
-/**
  * voltdm_for_each - call function on each registered voltagedomain
  * @fn: callback function *
  *
diff --git a/arch/arm/mach-omap2/voltage.h b/arch/arm/mach-omap2/voltage.h
index f7f2879..d8208f3 100644
--- a/arch/arm/mach-omap2/voltage.h
+++ b/arch/arm/mach-omap2/voltage.h
@@ -163,8 +163,6 @@ struct omap_volt_data *omap_voltage_get_voltdata(struct voltagedomain *voltdm,
 		unsigned long volt);
 int omap_voltage_register_pmic(struct voltagedomain *voltdm,
 			       struct omap_voltdm_pmic *pmic);
-void omap_change_voltscale_method(struct voltagedomain *voltdm,
-		int voltscale_method);
 int omap_voltage_late_init(void);
 
 extern void omap2xxx_voltagedomains_init(void);
@@ -177,9 +175,6 @@ void voltdm_init(struct voltagedomain **voltdm_list);
 int voltdm_add_pwrdm(struct voltagedomain *voltdm, struct powerdomain *pwrdm);
 int voltdm_for_each(int (*fn)(struct voltagedomain *voltdm, void *user),
 		    void *user);
-int voltdm_for_each_pwrdm(struct voltagedomain *voltdm,
-			  int (*fn)(struct voltagedomain *voltdm,
-				    struct powerdomain *pwrdm));
 int voltdm_scale(struct voltagedomain *voltdm, unsigned long target_volt);
 void voltdm_reset(struct voltagedomain *voltdm);
 unsigned long voltdm_get_voltage(struct voltagedomain *voltdm);
-- 
1.7.10.4

