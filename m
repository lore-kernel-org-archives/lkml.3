Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbaEGPLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:11:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33369 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaEGPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:11:47 -0400
X-AuditID: cbfee61b-b7f766d00000646c-42-536a4d3037c8
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata: use CONFIG_PM_SLEEP instead of CONFIG_PM where applicable
 in host drivers
Date: Wed, 07 May 2014 17:11:31 +0200
Message-id: <2557366.uRpR4azrSj@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jQV0D36xgg41zjCyO7XjEZHF51xw2
	i1/LjzI6MHtsWtXJ5vF5k1wAUxSXTUpqTmZZapG+XQJXRselY+wFl34xVUzdt4OtgXHBPqYu
	Rg4OCQETiTnrzbsYOYFMMYkL99azgdhCAtMZJWZtiOpi5AKyW5gkvna/ZwJJsAlYSUxsX8UI
	YosIyEpcmfYQzGYWsJbY2jqNHcQWFkiU6DlygxnEZhFQlZjyewcriM0roCnxc00T2BxRAU+J
	HdtXskHEBSV+TL7HAjFHXmLf/qmsELaWxPqdx5kmMPLNQlI2C0nZLCRlCxiZVzGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEB9wz6R2MqxosDjEKcDAq8fBmOGcFC7EmlhVX5h5ilOBgVhLh
	jfQCCvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamA0+5be
	bMGVmfjz2tvlotJLUi/Yqx4ymyUnphVTav36btvqrG0mj5cyyZx+VNyXsoeh+da8W+zl382W
	2Ekcr40pePsl6km7ZPJaztBjP47MKjWZW5T0e9WuRSrZTrtrOD/pyLk39GvP2MHw7lnp8hDn
	0PiDjOZqIQ3rlRepffpwUP3zn/SChI1KLMUZiYZazEXFiQDotXajNAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes host drivers to use CONFIG_PM_SLEEP instead of CONFIG_PM
where applicable.  Benefits of this change:

* unused code is not being compiled in for CONFIG_PM=y, CONFIG_PM_SLEEP=n
  and CONFIG_PM_RUNTIME=y configurations

* easier transition to use struct dev_pm_ops and SIMPLE_DEV_PM_OPS() in
  the future

* more consistent code (there are host drivers which are using the correct
  CONFIG_PM_SLEEP checks already)

The patch leaves alone the core libata code and ->port_[suspend,resume]
support (in sata_[inic162x,nv,sil24].c) alone for now.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
I'll split this patch on smaller per-host-driver ones if desired..

 drivers/ata/acard-ahci.c        |    6 +++---
 drivers/ata/ata_generic.c       |    2 +-
 drivers/ata/ata_piix.c          |    4 ++--
 drivers/ata/pata_acpi.c         |    2 +-
 drivers/ata/pata_ali.c          |    4 ++--
 drivers/ata/pata_amd.c          |    4 ++--
 drivers/ata/pata_artop.c        |    4 ++--
 drivers/ata/pata_atiixp.c       |    2 +-
 drivers/ata/pata_atp867x.c      |    4 ++--
 drivers/ata/pata_bf54x.c        |    2 +-
 drivers/ata/pata_cmd640.c       |    4 ++--
 drivers/ata/pata_cmd64x.c       |    4 ++--
 drivers/ata/pata_cs5520.c       |    6 +++---
 drivers/ata/pata_cs5530.c       |    6 +++---
 drivers/ata/pata_cs5535.c       |    2 +-
 drivers/ata/pata_cs5536.c       |    2 +-
 drivers/ata/pata_cypress.c      |    2 +-
 drivers/ata/pata_efar.c         |    2 +-
 drivers/ata/pata_hpt366.c       |    4 ++--
 drivers/ata/pata_hpt3x3.c       |    4 ++--
 drivers/ata/pata_imx.c          |    4 ++--
 drivers/ata/pata_it8213.c       |    2 +-
 drivers/ata/pata_it821x.c       |    4 ++--
 drivers/ata/pata_jmicron.c      |    2 +-
 drivers/ata/pata_macio.c        |   22 ++++++++--------------
 drivers/ata/pata_marvell.c      |    2 +-
 drivers/ata/pata_mpc52xx.c      |    8 ++------
 drivers/ata/pata_mpiix.c        |    2 +-
 drivers/ata/pata_netcell.c      |    2 +-
 drivers/ata/pata_ninja32.c      |    5 ++---
 drivers/ata/pata_ns87410.c      |    2 +-
 drivers/ata/pata_ns87415.c      |    4 ++--
 drivers/ata/pata_oldpiix.c      |    2 +-
 drivers/ata/pata_opti.c         |    2 +-
 drivers/ata/pata_optidma.c      |    2 +-
 drivers/ata/pata_pdc2027x.c     |    6 +++---
 drivers/ata/pata_pdc202xx_old.c |    2 +-
 drivers/ata/pata_piccolo.c      |    2 +-
 drivers/ata/pata_radisys.c      |    2 +-
 drivers/ata/pata_rdc.c          |    2 +-
 drivers/ata/pata_rz1000.c       |    4 ++--
 drivers/ata/pata_samsung_cf.c   |    4 ++--
 drivers/ata/pata_sc1200.c       |    2 +-
 drivers/ata/pata_scc.c          |    2 +-
 drivers/ata/pata_sch.c          |    2 +-
 drivers/ata/pata_serverworks.c  |    4 ++--
 drivers/ata/pata_sil680.c       |    4 ++--
 drivers/ata/pata_sis.c          |    4 ++--
 drivers/ata/pata_sl82c105.c     |    4 ++--
 drivers/ata/pata_triflex.c      |    4 ++--
 drivers/ata/pata_via.c          |    4 ++--
 drivers/ata/sata_fsl.c          |    4 ++--
 drivers/ata/sata_inic162x.c     |    4 ++--
 drivers/ata/sata_mv.c           |    8 ++++----
 drivers/ata/sata_nv.c           |    6 +++---
 drivers/ata/sata_rcar.c         |    4 ++--
 drivers/ata/sata_sil.c          |    6 +++---
 drivers/ata/sata_sil24.c        |   10 +++++++---
 drivers/ata/sata_sis.c          |    2 +-
 drivers/ata/sata_via.c          |    2 +-
 60 files changed, 113 insertions(+), 120 deletions(-)

Index: b/drivers/ata/acard-ahci.c
===================================================================
--- a/drivers/ata/acard-ahci.c	2014-04-17 14:36:05.256968458 +0200
+++ b/drivers/ata/acard-ahci.c	2014-04-30 18:06:05.506291518 +0200
@@ -77,7 +77,7 @@ static bool acard_ahci_qc_fill_rtf(struc
 static int acard_ahci_port_start(struct ata_port *ap);
 static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int acard_ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int acard_ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
@@ -118,13 +118,13 @@ static struct pci_driver acard_ahci_pci_
 	.id_table		= acard_ahci_pci_tbl,
 	.probe			= acard_ahci_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= acard_ahci_pci_device_suspend,
 	.resume			= acard_ahci_pci_device_resume,
 #endif
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int acard_ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
Index: b/drivers/ata/ata_generic.c
===================================================================
--- a/drivers/ata/ata_generic.c	2014-04-17 14:36:07.076968492 +0200
+++ b/drivers/ata/ata_generic.c	2014-04-30 18:46:17.398336797 +0200
@@ -241,7 +241,7 @@ static struct pci_driver ata_generic_pci
 	.id_table	= ata_generic,
 	.probe 		= ata_generic_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c	2014-04-17 14:36:07.076968492 +0200
+++ b/drivers/ata/ata_piix.c	2014-04-30 18:46:58.786337574 +0200
@@ -830,7 +830,7 @@ static bool piix_irq_check(struct ata_po
 	return ap->ops->bmdma_status(ap) & ATA_DMA_INTR;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int piix_broken_suspend(void)
 {
 	static const struct dmi_system_id sysids[] = {
@@ -1767,7 +1767,7 @@ static struct pci_driver piix_pci_driver
 	.id_table		= piix_pci_tbl,
 	.probe			= piix_init_one,
 	.remove			= piix_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= piix_pci_device_suspend,
 	.resume			= piix_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_acpi.c
===================================================================
--- a/drivers/ata/pata_acpi.c	2014-04-17 14:36:09.960968544 +0200
+++ b/drivers/ata/pata_acpi.c	2014-04-30 18:47:19.922337971 +0200
@@ -265,7 +265,7 @@ static struct pci_driver pacpi_pci_drive
 	.id_table		= pacpi_pci_tbl,
 	.probe			= pacpi_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c	2014-04-17 14:36:09.960968544 +0200
+++ b/drivers/ata/pata_ali.c	2014-04-30 18:47:42.326338392 +0200
@@ -589,7 +589,7 @@ static int ali_init_one(struct pci_dev *
 		return ata_pci_bmdma_init_one(pdev, ppi, &ali_sht, NULL, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ali_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -616,7 +616,7 @@ static struct pci_driver ali_pci_driver
 	.id_table	= ali,
 	.probe 		= ali_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ali_reinit_one,
 #endif
Index: b/drivers/ata/pata_amd.c
===================================================================
--- a/drivers/ata/pata_amd.c	2014-04-17 14:36:09.960968544 +0200
+++ b/drivers/ata/pata_amd.c	2014-04-30 18:48:02.858338778 +0200
@@ -574,7 +574,7 @@ static int amd_init_one(struct pci_dev *
 	return ata_pci_bmdma_init_one(pdev, ppi, &amd_sht, hpriv, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int amd_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -625,7 +625,7 @@ static struct pci_driver amd_pci_driver
 	.id_table	= amd,
 	.probe 		= amd_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= amd_reinit_one,
 #endif
Index: b/drivers/ata/pata_artop.c
===================================================================
--- a/drivers/ata/pata_artop.c	2014-04-17 14:36:09.960968544 +0200
+++ b/drivers/ata/pata_artop.c	2014-04-30 18:48:20.966339118 +0200
@@ -422,7 +422,7 @@ static const struct pci_device_id artop_
 	{ }	/* terminate list */
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int atp8xx_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -444,7 +444,7 @@ static struct pci_driver artop_pci_drive
 	.id_table		= artop_pci_tbl,
 	.probe			= artop_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= atp8xx_reinit_one,
 #endif
Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_atiixp.c	2014-04-30 18:48:33.694339356 +0200
@@ -298,7 +298,7 @@ static struct pci_driver atiixp_pci_driv
 	.id_table	= atiixp,
 	.probe 		= atiixp_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.resume		= ata_pci_device_resume,
 	.suspend	= ata_pci_device_suspend,
 #endif
Index: b/drivers/ata/pata_atp867x.c
===================================================================
--- a/drivers/ata/pata_atp867x.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_atp867x.c	2014-04-30 18:48:50.474339671 +0200
@@ -530,7 +530,7 @@ err_out:
 	return rc;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int atp867x_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -558,7 +558,7 @@ static struct pci_driver atp867x_driver
 	.id_table 	= atp867x_pci_tbl,
 	.probe 		= atp867x_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= atp867x_reinit_one,
 #endif
Index: b/drivers/ata/pata_bf54x.c
===================================================================
--- a/drivers/ata/pata_bf54x.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_bf54x.c	2014-04-30 18:49:38.990340582 +0200
@@ -1619,7 +1619,7 @@ static int bfin_atapi_remove(struct plat
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int bfin_atapi_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct ata_host *host = platform_get_drvdata(pdev);
Index: b/drivers/ata/pata_cmd640.c
===================================================================
--- a/drivers/ata/pata_cmd640.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_cmd640.c	2014-04-30 18:50:02.158341018 +0200
@@ -231,7 +231,7 @@ static int cmd640_init_one(struct pci_de
 	return ata_pci_sff_init_one(pdev, ppi, &cmd640_sht, NULL, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int cmd640_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -256,7 +256,7 @@ static struct pci_driver cmd640_pci_driv
 	.id_table	= cmd640,
 	.probe 		= cmd640_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= cmd640_reinit_one,
 #endif
Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_cmd64x.c	2014-04-30 18:50:19.494341342 +0200
@@ -487,7 +487,7 @@ static int cmd64x_init_one(struct pci_de
 	return ata_pci_bmdma_init_one(pdev, ppi, &cmd64x_sht, NULL, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int cmd64x_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -518,7 +518,7 @@ static struct pci_driver cmd64x_pci_driv
 	.id_table	= cmd64x,
 	.probe 		= cmd64x_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= cmd64x_reinit_one,
 #endif
Index: b/drivers/ata/pata_cs5520.c
===================================================================
--- a/drivers/ata/pata_cs5520.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_cs5520.c	2014-04-30 18:50:47.554341869 +0200
@@ -229,7 +229,7 @@ static int cs5520_init_one(struct pci_de
 	return ata_host_register(host, &cs5520_sht);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 /**
  *	cs5520_reinit_one	-	device resume
  *	@pdev: PCI device
@@ -278,7 +278,7 @@ static int cs5520_pci_device_suspend(str
 	pci_save_state(pdev);
 	return 0;
 }
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 /* For now keep DMA off. We can set it for all but A rev CS5510 once the
    core ATA code can handle it */
@@ -295,7 +295,7 @@ static struct pci_driver cs5520_pci_driv
 	.id_table	= pata_cs5520,
 	.probe 		= cs5520_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= cs5520_pci_device_suspend,
 	.resume		= cs5520_reinit_one,
 #endif
Index: b/drivers/ata/pata_cs5530.c
===================================================================
--- a/drivers/ata/pata_cs5530.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_cs5530.c	2014-04-30 18:51:10.846342306 +0200
@@ -326,7 +326,7 @@ static int cs5530_init_one(struct pci_de
 	return ata_pci_bmdma_init_one(pdev, ppi, &cs5530_sht, NULL, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int cs5530_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -343,7 +343,7 @@ static int cs5530_reinit_one(struct pci_
 	ata_host_resume(host);
 	return 0;
 }
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static const struct pci_device_id cs5530[] = {
 	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5530_IDE), },
@@ -356,7 +356,7 @@ static struct pci_driver cs5530_pci_driv
 	.id_table	= cs5530,
 	.probe 		= cs5530_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= cs5530_reinit_one,
 #endif
Index: b/drivers/ata/pata_cs5535.c
===================================================================
--- a/drivers/ata/pata_cs5535.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_cs5535.c	2014-04-30 18:51:25.298342578 +0200
@@ -200,7 +200,7 @@ static struct pci_driver cs5535_pci_driv
 	.id_table	= cs5535,
 	.probe 		= cs5535_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_cs5536.c
===================================================================
--- a/drivers/ata/pata_cs5536.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_cs5536.c	2014-04-30 18:51:34.510342751 +0200
@@ -297,7 +297,7 @@ static struct pci_driver cs5536_pci_driv
 	.id_table	= cs5536,
 	.probe		= cs5536_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_cypress.c
===================================================================
--- a/drivers/ata/pata_cypress.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_cypress.c	2014-04-30 18:51:48.046343005 +0200
@@ -151,7 +151,7 @@ static struct pci_driver cy82c693_pci_dr
 	.id_table	= cy82c693,
 	.probe 		= cy82c693_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_efar.c
===================================================================
--- a/drivers/ata/pata_efar.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_efar.c	2014-04-30 18:51:59.910343228 +0200
@@ -288,7 +288,7 @@ static struct pci_driver efar_pci_driver
 	.id_table		= efar_pci_tbl,
 	.probe			= efar_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_hpt366.c
===================================================================
--- a/drivers/ata/pata_hpt366.c	2014-04-17 14:36:10.468968555 +0200
+++ b/drivers/ata/pata_hpt366.c	2014-04-30 18:52:26.710343731 +0200
@@ -386,7 +386,7 @@ static int hpt36x_init_one(struct pci_de
 	return ata_pci_bmdma_init_one(dev, ppi, &hpt36x_sht, hpriv, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int hpt36x_reinit_one(struct pci_dev *dev)
 {
 	struct ata_host *host = pci_get_drvdata(dev);
@@ -411,7 +411,7 @@ static struct pci_driver hpt36x_pci_driv
 	.id_table	= hpt36x,
 	.probe		= hpt36x_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= hpt36x_reinit_one,
 #endif
Index: b/drivers/ata/pata_hpt3x3.c
===================================================================
--- a/drivers/ata/pata_hpt3x3.c	2014-04-17 14:36:10.472968553 +0200
+++ b/drivers/ata/pata_hpt3x3.c	2014-04-30 18:52:42.594344029 +0200
@@ -249,7 +249,7 @@ static int hpt3x3_init_one(struct pci_de
 				 IRQF_SHARED, &hpt3x3_sht);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int hpt3x3_reinit_one(struct pci_dev *dev)
 {
 	struct ata_host *host = pci_get_drvdata(dev);
@@ -277,7 +277,7 @@ static struct pci_driver hpt3x3_pci_driv
 	.id_table	= hpt3x3,
 	.probe 		= hpt3x3_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= hpt3x3_reinit_one,
 #endif
Index: b/drivers/ata/pata_imx.c
===================================================================
--- a/drivers/ata/pata_imx.c	2014-04-17 14:36:10.472968553 +0200
+++ b/drivers/ata/pata_imx.c	2014-04-30 18:53:13.502344609 +0200
@@ -185,7 +185,7 @@ static int pata_imx_remove(struct platfo
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int pata_imx_suspend(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
@@ -244,7 +244,7 @@ static struct platform_driver pata_imx_d
 		.name		= DRV_NAME,
 		.of_match_table	= imx_pata_dt_ids,
 		.owner		= THIS_MODULE,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 		.pm		= &pata_imx_pm_ops,
 #endif
 	},
Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c	2014-04-17 14:36:10.480968554 +0200
+++ b/drivers/ata/pata_it8213.c	2014-04-30 18:53:36.086345033 +0200
@@ -283,7 +283,7 @@ static struct pci_driver it8213_pci_driv
 	.id_table		= it8213_pci_tbl,
 	.probe			= it8213_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_it821x.c
===================================================================
--- a/drivers/ata/pata_it821x.c	2014-04-17 14:36:10.480968554 +0200
+++ b/drivers/ata/pata_it821x.c	2014-04-30 18:53:50.510345304 +0200
@@ -935,7 +935,7 @@ static int it821x_init_one(struct pci_de
 	return ata_pci_bmdma_init_one(pdev, ppi, &it821x_sht, NULL, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int it821x_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -965,7 +965,7 @@ static struct pci_driver it821x_pci_driv
 	.id_table	= it821x,
 	.probe 		= it821x_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= it821x_reinit_one,
 #endif
Index: b/drivers/ata/pata_jmicron.c
===================================================================
--- a/drivers/ata/pata_jmicron.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_jmicron.c	2014-04-30 19:24:14.226379542 +0200
@@ -157,7 +157,7 @@ static struct pci_driver jmicron_pci_dri
 	.id_table		= jmicron_pci_tbl,
 	.probe			= jmicron_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_macio.c
===================================================================
--- a/drivers/ata/pata_macio.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_macio.c	2014-04-30 19:25:22.202380818 +0200
@@ -845,8 +845,7 @@ static int pata_macio_slave_config(struc
 	return 0;
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static int pata_macio_do_suspend(struct pata_macio_priv *priv, pm_message_t mesg)
 {
 	int rc;
@@ -907,8 +906,7 @@ static int pata_macio_do_resume(struct p
 
 	return 0;
 }
-
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static struct scsi_host_template pata_macio_sht = {
 	ATA_BASE_SHT(DRV_NAME),
@@ -1208,8 +1206,7 @@ static int pata_macio_detach(struct maci
 	return 0;
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static int pata_macio_suspend(struct macio_dev *mdev, pm_message_t mesg)
 {
 	struct ata_host *host = macio_get_drvdata(mdev);
@@ -1223,8 +1220,7 @@ static int pata_macio_resume(struct maci
 
 	return pata_macio_do_resume(host->private_data);
 }
-
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PMAC_MEDIABAY
 static void pata_macio_mb_event(struct macio_dev* mdev, int mb_state)
@@ -1316,8 +1312,7 @@ static void pata_macio_pci_detach(struct
 	ata_host_detach(host);
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static int pata_macio_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -1331,8 +1326,7 @@ static int pata_macio_pci_resume(struct
 
 	return pata_macio_do_resume(host->private_data);
 }
-
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static struct of_device_id pata_macio_match[] =
 {
@@ -1360,7 +1354,7 @@ static struct macio_driver pata_macio_dr
 	},
 	.probe		= pata_macio_attach,
 	.remove		= pata_macio_detach,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= pata_macio_suspend,
 	.resume		= pata_macio_resume,
 #endif
@@ -1383,7 +1377,7 @@ static struct pci_driver pata_macio_pci_
 	.id_table	= pata_macio_pci_match,
 	.probe		= pata_macio_pci_attach,
 	.remove		= pata_macio_pci_detach,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= pata_macio_pci_suspend,
 	.resume		= pata_macio_pci_resume,
 #endif
Index: b/drivers/ata/pata_marvell.c
===================================================================
--- a/drivers/ata/pata_marvell.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_marvell.c	2014-04-30 19:25:43.338381215 +0200
@@ -171,7 +171,7 @@ static struct pci_driver marvell_pci_dri
 	.id_table		= marvell_pci_tbl,
 	.probe			= marvell_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_mpc52xx.c
===================================================================
--- a/drivers/ata/pata_mpc52xx.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_mpc52xx.c	2014-04-30 20:05:43.558426276 +0200
@@ -819,9 +819,7 @@ mpc52xx_ata_remove(struct platform_devic
 	return 0;
 }
 
-
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static int
 mpc52xx_ata_suspend(struct platform_device *op, pm_message_t state)
 {
@@ -847,10 +845,8 @@ mpc52xx_ata_resume(struct platform_devic
 
 	return 0;
 }
-
 #endif
 
-
 static struct of_device_id mpc52xx_ata_of_match[] = {
 	{ .compatible = "fsl,mpc5200-ata", },
 	{ .compatible = "mpc5200-ata", },
@@ -861,7 +857,7 @@ static struct of_device_id mpc52xx_ata_o
 static struct platform_driver mpc52xx_ata_of_platform_driver = {
 	.probe		= mpc52xx_ata_probe,
 	.remove		= mpc52xx_ata_remove,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= mpc52xx_ata_suspend,
 	.resume		= mpc52xx_ata_resume,
 #endif
Index: b/drivers/ata/pata_mpiix.c
===================================================================
--- a/drivers/ata/pata_mpiix.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_mpiix.c	2014-04-30 19:44:16.774402118 +0200
@@ -223,7 +223,7 @@ static struct pci_driver mpiix_pci_drive
 	.id_table	= mpiix,
 	.probe 		= mpiix_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_netcell.c
===================================================================
--- a/drivers/ata/pata_netcell.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_netcell.c	2014-04-30 19:44:27.238402315 +0200
@@ -92,7 +92,7 @@ static struct pci_driver netcell_pci_dri
 	.id_table		= netcell_pci_tbl,
 	.probe			= netcell_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_ninja32.c
===================================================================
--- a/drivers/ata/pata_ninja32.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_ninja32.c	2014-04-30 19:44:45.098402650 +0200
@@ -152,8 +152,7 @@ static int ninja32_init_one(struct pci_d
 				 IRQF_SHARED, &ninja32_sht);
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static int ninja32_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -183,7 +182,7 @@ static struct pci_driver ninja32_pci_dri
 	.id_table	= ninja32,
 	.probe 		= ninja32_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ninja32_reinit_one,
 #endif
Index: b/drivers/ata/pata_ns87410.c
===================================================================
--- a/drivers/ata/pata_ns87410.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_ns87410.c	2014-04-30 19:44:56.546402865 +0200
@@ -161,7 +161,7 @@ static struct pci_driver ns87410_pci_dri
 	.id_table	= ns87410,
 	.probe 		= ns87410_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_ns87415.c
===================================================================
--- a/drivers/ata/pata_ns87415.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_ns87415.c	2014-04-30 19:45:11.830403152 +0200
@@ -385,7 +385,7 @@ static const struct pci_device_id ns8741
 	{ }	/* terminate list */
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ns87415_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -407,7 +407,7 @@ static struct pci_driver ns87415_pci_dri
 	.id_table		= ns87415_pci_tbl,
 	.probe			= ns87415_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ns87415_reinit_one,
 #endif
Index: b/drivers/ata/pata_oldpiix.c
===================================================================
--- a/drivers/ata/pata_oldpiix.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_oldpiix.c	2014-04-30 19:46:28.482404591 +0200
@@ -258,7 +258,7 @@ static struct pci_driver oldpiix_pci_dri
 	.id_table		= oldpiix_pci_tbl,
 	.probe			= oldpiix_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_opti.c
===================================================================
--- a/drivers/ata/pata_opti.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_opti.c	2014-04-30 19:46:41.006404826 +0200
@@ -184,7 +184,7 @@ static struct pci_driver opti_pci_driver
 	.id_table	= opti,
 	.probe 		= opti_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_optidma.c
===================================================================
--- a/drivers/ata/pata_optidma.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_optidma.c	2014-04-30 19:46:52.046405033 +0200
@@ -440,7 +440,7 @@ static struct pci_driver optidma_pci_dri
 	.id_table	= optidma,
 	.probe 		= optidma_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_pdc2027x.c
===================================================================
--- a/drivers/ata/pata_pdc2027x.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_pdc2027x.c	2014-04-30 19:47:37.874405893 +0200
@@ -62,7 +62,7 @@ enum {
 };
 
 static int pdc2027x_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int pdc2027x_reinit_one(struct pci_dev *pdev);
 #endif
 static int pdc2027x_prereset(struct ata_link *link, unsigned long deadline);
@@ -128,7 +128,7 @@ static struct pci_driver pdc2027x_pci_dr
 	.id_table		= pdc2027x_pci_tbl,
 	.probe			= pdc2027x_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= pdc2027x_reinit_one,
 #endif
@@ -761,7 +761,7 @@ static int pdc2027x_init_one(struct pci_
 				 IRQF_SHARED, &pdc2027x_sht);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int pdc2027x_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
Index: b/drivers/ata/pata_pdc202xx_old.c
===================================================================
--- a/drivers/ata/pata_pdc202xx_old.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_pdc202xx_old.c	2014-04-30 19:47:53.718406191 +0200
@@ -377,7 +377,7 @@ static struct pci_driver pdc202xx_pci_dr
 	.id_table	= pdc202xx,
 	.probe 		= pdc202xx_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_piccolo.c
===================================================================
--- a/drivers/ata/pata_piccolo.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_piccolo.c	2014-04-30 19:48:05.034406403 +0200
@@ -110,7 +110,7 @@ static struct pci_driver ata_tosh_pci_dr
 	.id_table	= ata_tosh,
 	.probe 		= ata_tosh_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_radisys.c
===================================================================
--- a/drivers/ata/pata_radisys.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_radisys.c	2014-04-30 19:48:14.954406590 +0200
@@ -237,7 +237,7 @@ static struct pci_driver radisys_pci_dri
 	.id_table		= radisys_pci_tbl,
 	.probe			= radisys_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_rdc.c
===================================================================
--- a/drivers/ata/pata_rdc.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_rdc.c	2014-04-30 19:48:24.950406777 +0200
@@ -382,7 +382,7 @@ static struct pci_driver rdc_pci_driver
 	.id_table		= rdc_pci_tbl,
 	.probe			= rdc_init_one,
 	.remove			= rdc_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_rz1000.c
===================================================================
--- a/drivers/ata/pata_rz1000.c	2014-04-17 14:36:10.484968556 +0200
+++ b/drivers/ata/pata_rz1000.c	2014-04-30 19:48:38.462407031 +0200
@@ -101,7 +101,7 @@ static int rz1000_init_one (struct pci_d
 	return -ENODEV;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int rz1000_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -133,7 +133,7 @@ static struct pci_driver rz1000_pci_driv
 	.id_table	= pata_rz1000,
 	.probe 		= rz1000_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= rz1000_reinit_one,
 #endif
Index: b/drivers/ata/pata_samsung_cf.c
===================================================================
--- a/drivers/ata/pata_samsung_cf.c	2014-04-28 15:53:30.754898102 +0200
+++ b/drivers/ata/pata_samsung_cf.c	2014-04-30 19:49:03.006407492 +0200
@@ -619,7 +619,7 @@ static int __exit pata_s3c_remove(struct
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int pata_s3c_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -670,7 +670,7 @@ static struct platform_driver pata_s3c_d
 	.driver		= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 		.pm	= &pata_s3c_pm_ops,
 #endif
 	},
Index: b/drivers/ata/pata_sc1200.c
===================================================================
--- a/drivers/ata/pata_sc1200.c	2014-04-17 14:36:10.656968562 +0200
+++ b/drivers/ata/pata_sc1200.c	2014-04-30 19:49:15.718407730 +0200
@@ -254,7 +254,7 @@ static struct pci_driver sc1200_pci_driv
 	.id_table	= sc1200,
 	.probe 		= sc1200_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_scc.c
===================================================================
--- a/drivers/ata/pata_scc.c	2014-04-17 14:36:11.448968572 +0200
+++ b/drivers/ata/pata_scc.c	2014-04-30 19:49:27.546407953 +0200
@@ -1096,7 +1096,7 @@ static struct pci_driver scc_pci_driver
 	.id_table		= scc_pci_tbl,
 	.probe			= scc_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_sch.c
===================================================================
--- a/drivers/ata/pata_sch.c	2014-04-17 14:36:11.448968572 +0200
+++ b/drivers/ata/pata_sch.c	2014-04-30 19:49:55.734408481 +0200
@@ -64,7 +64,7 @@ static struct pci_driver sch_pci_driver
 	.id_table		= sch_pci_tbl,
 	.probe			= sch_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_serverworks.c
===================================================================
--- a/drivers/ata/pata_serverworks.c	2014-04-17 14:36:11.448968572 +0200
+++ b/drivers/ata/pata_serverworks.c	2014-04-30 19:50:18.950408917 +0200
@@ -436,7 +436,7 @@ static int serverworks_init_one(struct p
 	return ata_pci_bmdma_init_one(pdev, ppi, &serverworks_sht, NULL, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int serverworks_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -468,7 +468,7 @@ static struct pci_driver serverworks_pci
 	.id_table	= serverworks,
 	.probe 		= serverworks_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= serverworks_reinit_one,
 #endif
Index: b/drivers/ata/pata_sil680.c
===================================================================
--- a/drivers/ata/pata_sil680.c	2014-04-17 14:36:11.448968572 +0200
+++ b/drivers/ata/pata_sil680.c	2014-04-30 19:50:36.974409256 +0200
@@ -403,7 +403,7 @@ use_ioports:
 	return ata_pci_bmdma_init_one(pdev, ppi, &sil680_sht, NULL, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sil680_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -429,7 +429,7 @@ static struct pci_driver sil680_pci_driv
 	.id_table	= sil680,
 	.probe 		= sil680_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= sil680_reinit_one,
 #endif
Index: b/drivers/ata/pata_sis.c
===================================================================
--- a/drivers/ata/pata_sis.c	2014-04-17 14:36:11.452968574 +0200
+++ b/drivers/ata/pata_sis.c	2014-04-30 19:50:53.070409558 +0200
@@ -869,7 +869,7 @@ static int sis_init_one (struct pci_dev
 	return ata_pci_bmdma_init_one(pdev, ppi, &sis_sht, chipset, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sis_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -899,7 +899,7 @@ static struct pci_driver sis_pci_driver
 	.id_table		= sis_pci_tbl,
 	.probe			= sis_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= sis_reinit_one,
 #endif
Index: b/drivers/ata/pata_sl82c105.c
===================================================================
--- a/drivers/ata/pata_sl82c105.c	2014-04-17 14:36:11.452968574 +0200
+++ b/drivers/ata/pata_sl82c105.c	2014-04-30 19:52:08.718410978 +0200
@@ -337,7 +337,7 @@ static int sl82c105_init_one(struct pci_
 	return ata_pci_bmdma_init_one(dev, ppi, &sl82c105_sht, NULL, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sl82c105_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -365,7 +365,7 @@ static struct pci_driver sl82c105_pci_dr
 	.id_table	= sl82c105,
 	.probe 		= sl82c105_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= sl82c105_reinit_one,
 #endif
Index: b/drivers/ata/pata_triflex.c
===================================================================
--- a/drivers/ata/pata_triflex.c	2014-04-17 14:36:11.452968574 +0200
+++ b/drivers/ata/pata_triflex.c	2014-04-30 19:52:27.426411330 +0200
@@ -207,7 +207,7 @@ static const struct pci_device_id trifle
 	{ },
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int triflex_ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -233,7 +233,7 @@ static struct pci_driver triflex_pci_dri
 	.id_table	= triflex,
 	.probe 		= triflex_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= triflex_ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c	2014-04-17 14:36:11.452968574 +0200
+++ b/drivers/ata/pata_via.c	2014-04-30 19:52:43.918411639 +0200
@@ -659,7 +659,7 @@ static int via_init_one(struct pci_dev *
 	return ata_pci_bmdma_init_one(pdev, ppi, &via_sht, (void *)config, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 /**
  *	via_reinit_one		-	reinit after resume
  *	@pdev; PCI device
@@ -704,7 +704,7 @@ static struct pci_driver via_pci_driver
 	.id_table	= via,
 	.probe 		= via_init_one,
 	.remove		= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= via_reinit_one,
 #endif
Index: b/drivers/ata/sata_fsl.c
===================================================================
--- a/drivers/ata/sata_fsl.c	2014-04-17 14:36:11.836968583 +0200
+++ b/drivers/ata/sata_fsl.c	2014-04-30 19:53:04.058412017 +0200
@@ -1588,7 +1588,7 @@ static int sata_fsl_remove(struct platfo
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sata_fsl_suspend(struct platform_device *op, pm_message_t state)
 {
 	struct ata_host *host = platform_get_drvdata(op);
@@ -1644,7 +1644,7 @@ static struct platform_driver fsl_sata_d
 	},
 	.probe		= sata_fsl_probe,
 	.remove		= sata_fsl_remove,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= sata_fsl_suspend,
 	.resume		= sata_fsl_resume,
 #endif
Index: b/drivers/ata/sata_inic162x.c
===================================================================
--- a/drivers/ata/sata_inic162x.c	2014-04-17 14:36:12.564968595 +0200
+++ b/drivers/ata/sata_inic162x.c	2014-04-30 19:53:36.678412629 +0200
@@ -785,7 +785,7 @@ static int init_controller(void __iomem
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int inic_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -898,7 +898,7 @@ static const struct pci_device_id inic_p
 static struct pci_driver inic_pci_driver = {
 	.name 		= DRV_NAME,
 	.id_table	= inic_pci_tbl,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= ata_pci_device_suspend,
 	.resume		= inic_pci_device_resume,
 #endif
Index: b/drivers/ata/sata_mv.c
===================================================================
--- a/drivers/ata/sata_mv.c	2014-04-17 14:36:12.564968595 +0200
+++ b/drivers/ata/sata_mv.c	2014-04-30 19:54:35.390413731 +0200
@@ -4222,7 +4222,7 @@ static int mv_platform_remove(struct pla
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int mv_platform_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct ata_host *host = platform_get_drvdata(pdev);
@@ -4289,7 +4289,7 @@ static struct platform_driver mv_platfor
 #ifdef CONFIG_PCI
 static int mv_pci_init_one(struct pci_dev *pdev,
 			   const struct pci_device_id *ent);
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int mv_pci_device_resume(struct pci_dev *pdev);
 #endif
 
@@ -4299,7 +4299,7 @@ static struct pci_driver mv_pci_driver =
 	.id_table		= mv_pci_tbl,
 	.probe			= mv_pci_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= mv_pci_device_resume,
 #endif
@@ -4457,7 +4457,7 @@ static int mv_pci_init_one(struct pci_de
 				 IS_GEN_I(hpriv) ? &mv5_sht : &mv6_sht);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int mv_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
Index: b/drivers/ata/sata_nv.c
===================================================================
--- a/drivers/ata/sata_nv.c	2014-04-17 14:36:12.564968595 +0200
+++ b/drivers/ata/sata_nv.c	2014-04-30 19:56:43.594416139 +0200
@@ -295,7 +295,7 @@ struct nv_swncq_port_priv {
 #define NV_ADMA_CHECK_INTR(GCTL, PORT) ((GCTL) & (1 << (19 + (12 * (PORT)))))
 
 static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int nv_pci_device_resume(struct pci_dev *pdev);
 #endif
 static void nv_ck804_host_stop(struct ata_host *host);
@@ -379,7 +379,7 @@ static struct pci_driver nv_pci_driver =
 	.name			= DRV_NAME,
 	.id_table		= nv_pci_tbl,
 	.probe			= nv_init_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= nv_pci_device_resume,
 #endif
@@ -2431,7 +2431,7 @@ static int nv_init_one(struct pci_dev *p
 	return ata_pci_sff_activate_host(host, ipriv->irq_handler, ipriv->sht);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int nv_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
Index: b/drivers/ata/sata_rcar.c
===================================================================
--- a/drivers/ata/sata_rcar.c	2014-04-17 14:36:12.564968595 +0200
+++ b/drivers/ata/sata_rcar.c	2014-04-30 19:57:06.922416576 +0200
@@ -937,7 +937,7 @@ static int sata_rcar_remove(struct platf
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sata_rcar_suspend(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
@@ -991,7 +991,7 @@ static struct platform_driver sata_rcar_
 		.name		= DRV_NAME,
 		.owner		= THIS_MODULE,
 		.of_match_table	= sata_rcar_match,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 		.pm		= &sata_rcar_pm_ops,
 #endif
 	},
Index: b/drivers/ata/sata_sil.c
===================================================================
--- a/drivers/ata/sata_sil.c	2014-04-17 14:36:12.564968595 +0200
+++ b/drivers/ata/sata_sil.c	2014-04-30 19:57:44.934417290 +0200
@@ -112,7 +112,7 @@ enum {
 };
 
 static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sil_pci_device_resume(struct pci_dev *pdev);
 #endif
 static void sil_dev_config(struct ata_device *dev);
@@ -166,7 +166,7 @@ static struct pci_driver sil_pci_driver
 	.id_table		= sil_pci_tbl,
 	.probe			= sil_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= sil_pci_device_resume,
 #endif
@@ -802,7 +802,7 @@ static int sil_init_one(struct pci_dev *
 				 &sil_sht);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sil_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
Index: b/drivers/ata/sata_sil24.c
===================================================================
--- a/drivers/ata/sata_sil24.c	2014-04-17 14:36:12.568968596 +0200
+++ b/drivers/ata/sata_sil24.c	2014-04-30 19:59:47.498419591 +0200
@@ -353,8 +353,10 @@ static void sil24_error_handler(struct a
 static void sil24_post_internal_cmd(struct ata_queued_cmd *qc);
 static int sil24_port_start(struct ata_port *ap);
 static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sil24_pci_device_resume(struct pci_dev *pdev);
+#endif
+#ifdef CONFIG_PM
 static int sil24_port_resume(struct ata_port *ap);
 #endif
 
@@ -375,7 +377,7 @@ static struct pci_driver sil24_pci_drive
 	.id_table		= sil24_pci_tbl,
 	.probe			= sil24_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= sil24_pci_device_resume,
 #endif
@@ -1350,7 +1352,7 @@ static int sil24_init_one(struct pci_dev
 				 &sil24_sht);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sil24_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
@@ -1370,7 +1372,9 @@ static int sil24_pci_device_resume(struc
 
 	return 0;
 }
+#endif
 
+#ifdef CONFIG_PM
 static int sil24_port_resume(struct ata_port *ap)
 {
 	sil24_config_pmp(ap, ap->nr_pmp_links);
Index: b/drivers/ata/sata_sis.c
===================================================================
--- a/drivers/ata/sata_sis.c	2014-04-17 14:36:12.568968596 +0200
+++ b/drivers/ata/sata_sis.c	2014-04-30 20:00:19.146420185 +0200
@@ -82,7 +82,7 @@ static struct pci_driver sis_pci_driver
 	.id_table		= sis_pci_tbl,
 	.probe			= sis_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif
Index: b/drivers/ata/sata_via.c
===================================================================
--- a/drivers/ata/sata_via.c	2014-04-17 14:36:13.136968606 +0200
+++ b/drivers/ata/sata_via.c	2014-04-30 20:00:46.662420701 +0200
@@ -103,7 +103,7 @@ static struct pci_driver svia_pci_driver
 	.name			= DRV_NAME,
 	.id_table		= svia_pci_tbl,
 	.probe			= svia_init_one,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
 #endif

