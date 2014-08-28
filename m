Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaH1PDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:03:16 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58687 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaH1PDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:03:15 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Olof Johansson <olof@lixom.net>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] drivers: char: hw_random: printk replacement
Date: Thu, 28 Aug 2014 20:32:58 +0530
Message-Id: <1409238178-16496-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as pr_* macros are more preffered over printk, so printk replaced with corresponding pr_* macros

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

The replacement was done by a bash script to avoid copy paste error. The script is as follows :

OLD="printk(KERN_ERR \?"
OLD1="printk(KERN_NOTICE \?"
OLD2="printk(KERN_WARNING \?"
OLD3="printk(KERN_INFO \?"
NEW="pr_err("
NEW1="pr_notice("
NEW2="pr_warn("
NEW3="pr_info("
TFILE="/tmp/out.tmp.$$"
for f in *.c
do
sed -e "s/$OLD/$NEW/g" -e "s/$OLD1/$NEW1/g" -e "s/$OLD2/$NEW2/g" -e "s/$OLD3/$NEW3/g" "$f" > $TFILE && mv $TFILE "$f"
done

Frankly speaking this script has missed one instance of printk(warning) in intel-rng.c file , and this one was edited manually.

 drivers/char/hw_random/amd-rng.c     |  4 ++--
 drivers/char/hw_random/geode-rng.c   |  4 ++--
 drivers/char/hw_random/intel-rng.c   | 12 ++++++------
 drivers/char/hw_random/pasemi-rng.c  |  2 +-
 drivers/char/hw_random/pseries-rng.c |  2 +-
 drivers/char/hw_random/via-rng.c     |  8 ++++----
 6 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index c6af038..48f6a83 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -142,10 +142,10 @@ found:
 	amd_rng.priv = (unsigned long)pmbase;
 	amd_pdev = pdev;
 
-	printk(KERN_INFO "AMD768 RNG detected\n");
+	pr_info("AMD768 RNG detected\n");
 	err = hwrng_register(&amd_rng);
 	if (err) {
-		printk(KERN_ERR PFX "RNG registering failed (%d)\n",
+		pr_err(PFX "RNG registering failed (%d)\n",
 		       err);
 		release_region(pmbase + 0xF0, 8);
 		goto out;
diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index 4c4d4e1..0d0579f 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -109,10 +109,10 @@ found:
 		goto out;
 	geode_rng.priv = (unsigned long)mem;
 
-	printk(KERN_INFO "AMD Geode RNG detected\n");
+	pr_info("AMD Geode RNG detected\n");
 	err = hwrng_register(&geode_rng);
 	if (err) {
-		printk(KERN_ERR PFX "RNG registering failed (%d)\n",
+		pr_err(PFX "RNG registering failed (%d)\n",
 		       err);
 		goto err_unmap;
 	}
diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 86fe45c..3122376 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -199,7 +199,7 @@ static int intel_rng_init(struct hwrng *rng)
 	if ((hw_status & INTEL_RNG_ENABLED) == 0)
 		hw_status = hwstatus_set(mem, hw_status | INTEL_RNG_ENABLED);
 	if ((hw_status & INTEL_RNG_ENABLED) == 0) {
-		printk(KERN_ERR PFX "cannot enable RNG, aborting\n");
+		pr_err(PFX "cannot enable RNG, aborting\n");
 		goto out;
 	}
 	err = 0;
@@ -216,7 +216,7 @@ static void intel_rng_cleanup(struct hwrng *rng)
 	if (hw_status & INTEL_RNG_ENABLED)
 		hwstatus_set(mem, hw_status & ~INTEL_RNG_ENABLED);
 	else
-		printk(KERN_WARNING PFX "unusual: RNG already disabled\n");
+		pr_warn(PFX "unusual: RNG already disabled\n");
 }
 
 
@@ -274,7 +274,7 @@ static int __init intel_rng_hw_init(void *_intel_rng_hw)
 	if (mfc != INTEL_FWH_MANUFACTURER_CODE ||
 	    (dvc != INTEL_FWH_DEVICE_CODE_8M &&
 	     dvc != INTEL_FWH_DEVICE_CODE_4M)) {
-		printk(KERN_NOTICE PFX "FWH not detected\n");
+		pr_notice(PFX "FWH not detected\n");
 		return -ENODEV;
 	}
 
@@ -314,7 +314,7 @@ PFX "RNG, try using the 'no_fwh_detect' option.\n";
 
 		if (no_fwh_detect)
 			return -ENODEV;
-		printk(warning);
+		pr_warn(warning);
 		return -EBUSY;
 	}
 
@@ -392,10 +392,10 @@ fwh_done:
 		goto out;
 	}
 
-	printk(KERN_INFO "Intel 82802 RNG detected\n");
+	pr_info("Intel 82802 RNG detected\n");
 	err = hwrng_register(&intel_rng);
 	if (err) {
-		printk(KERN_ERR PFX "RNG registering failed (%d)\n",
+		pr_err(PFX "RNG registering failed (%d)\n",
 		       err);
 		iounmap(mem);
 	}
diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index c66279b..c0347d1 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -113,7 +113,7 @@ static int rng_probe(struct platform_device *ofdev)
 
 	pasemi_rng.priv = (unsigned long)rng_regs;
 
-	printk(KERN_INFO "Registering PA Semi RNG\n");
+	pr_info("Registering PA Semi RNG\n");
 
 	err = hwrng_register(&pasemi_rng);
 
diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index ab7ffde..6226aa0 100644
--- a/drivers/char/hw_random/pseries-rng.c
+++ b/drivers/char/hw_random/pseries-rng.c
@@ -86,7 +86,7 @@ static struct vio_driver pseries_rng_driver = {
 
 static int __init rng_init(void)
 {
-	printk(KERN_INFO "Registering IBM pSeries RNG driver\n");
+	pr_info("Registering IBM pSeries RNG driver\n");
 	return vio_register_driver(&pseries_rng_driver);
 }
 
diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index de5a6dc..a3bebef 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -141,7 +141,7 @@ static int via_rng_init(struct hwrng *rng)
 	 * register */
 	if ((c->x86 == 6) && (c->x86_model >= 0x0f)) {
 		if (!cpu_has_xstore_enabled) {
-			printk(KERN_ERR PFX "can't enable hardware RNG "
+			pr_err(PFX "can't enable hardware RNG "
 				"if XSTORE is not enabled\n");
 			return -ENODEV;
 		}
@@ -180,7 +180,7 @@ static int via_rng_init(struct hwrng *rng)
 	   unneeded */
 	rdmsr(MSR_VIA_RNG, lo, hi);
 	if ((lo & VIA_RNG_ENABLE) == 0) {
-		printk(KERN_ERR PFX "cannot enable VIA C3 RNG, aborting\n");
+		pr_err(PFX "cannot enable VIA C3 RNG, aborting\n");
 		return -ENODEV;
 	}
 
@@ -202,10 +202,10 @@ static int __init mod_init(void)
 
 	if (!cpu_has_xstore)
 		return -ENODEV;
-	printk(KERN_INFO "VIA RNG detected\n");
+	pr_info("VIA RNG detected\n");
 	err = hwrng_register(&via_rng);
 	if (err) {
-		printk(KERN_ERR PFX "RNG registering failed (%d)\n",
+		pr_err(PFX "RNG registering failed (%d)\n",
 		       err);
 		goto out;
 	}
-- 
1.8.1.2

