Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab3BFWdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:33:54 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:47882 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439Ab3BFWdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:33:53 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1360189841!12881662!12
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/11] drivers/net: use module_pcmcia_driver() in pcmcia drivers
Date: Wed, 6 Feb 2013 15:30:56 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061530.56497.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Add a comment in drivers/net/wireless/b43/pcmcia.c about why that
driver does not use the new macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/net/arcnet/com20020_cs.c           | 14 +-------------
 drivers/net/can/sja1000/ems_pcmcia.c       | 13 +------------
 drivers/net/can/sja1000/peak_pcmcia.c      | 13 +------------
 drivers/net/ethernet/3com/3c574_cs.c       | 14 +-------------
 drivers/net/ethernet/3com/3c589_cs.c       | 14 +-------------
 drivers/net/ethernet/8390/axnet_cs.c       | 14 +-------------
 drivers/net/ethernet/8390/pcnet_cs.c       | 14 +-------------
 drivers/net/ethernet/amd/nmclan_cs.c       | 14 +-------------
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c  | 14 +-------------
 drivers/net/ethernet/smsc/smc91c92_cs.c    | 14 +-------------
 drivers/net/ethernet/xircom/xirc2ps_cs.c   | 16 +---------------
 drivers/net/wireless/airo_cs.c             | 14 +-------------
 drivers/net/wireless/atmel_cs.c            | 14 +-------------
 drivers/net/wireless/b43/pcmcia.c          |  4 ++++
 drivers/net/wireless/hostap/hostap_cs.c    | 15 +--------------
 drivers/net/wireless/libertas/if_cs.c      | 25 +------------------------
 drivers/net/wireless/orinoco/orinoco_cs.c  | 16 +---------------
 drivers/net/wireless/orinoco/spectrum_cs.c | 16 +---------------
 drivers/net/wireless/wl3501_cs.c           | 14 +-------------
 19 files changed, 22 insertions(+), 250 deletions(-)

diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020_cs.c
index 5bed4c4..74dc187 100644
--- a/drivers/net/arcnet/com20020_cs.c
+++ b/drivers/net/arcnet/com20020_cs.c
@@ -333,16 +333,4 @@ static struct pcmcia_driver com20020_cs_driver = {
 	.suspend	= com20020_suspend,
 	.resume		= com20020_resume,
 };
-
-static int __init init_com20020_cs(void)
-{
-	return pcmcia_register_driver(&com20020_cs_driver);
-}
-
-static void __exit exit_com20020_cs(void)
-{
-	pcmcia_unregister_driver(&com20020_cs_driver);
-}
-
-module_init(init_com20020_cs);
-module_exit(exit_com20020_cs);
+module_pcmcia_driver(com20020_cs_driver);
diff --git a/drivers/net/can/sja1000/ems_pcmcia.c b/drivers/net/can/sja1000/ems_pcmcia.c
index 5c2f3fb..321c27e 100644
--- a/drivers/net/can/sja1000/ems_pcmcia.c
+++ b/drivers/net/can/sja1000/ems_pcmcia.c
@@ -316,15 +316,4 @@ static struct pcmcia_driver ems_pcmcia_driver = {
 	.remove = ems_pcmcia_remove,
 	.id_table = ems_pcmcia_tbl,
 };
-
-static int __init ems_pcmcia_init(void)
-{
-	return pcmcia_register_driver(&ems_pcmcia_driver);
-}
-module_init(ems_pcmcia_init);
-
-static void __exit ems_pcmcia_exit(void)
-{
-	pcmcia_unregister_driver(&ems_pcmcia_driver);
-}
-module_exit(ems_pcmcia_exit);
+module_pcmcia_driver(ems_pcmcia_driver);
diff --git a/drivers/net/can/sja1000/peak_pcmcia.c b/drivers/net/can/sja1000/peak_pcmcia.c
index 1a7020b..0a707f7 100644
--- a/drivers/net/can/sja1000/peak_pcmcia.c
+++ b/drivers/net/can/sja1000/peak_pcmcia.c
@@ -740,15 +740,4 @@ static struct pcmcia_driver pcan_driver = {
 	.remove = pcan_remove,
 	.id_table = pcan_table,
 };
-
-static int __init pcan_init(void)
-{
-	return pcmcia_register_driver(&pcan_driver);
-}
-module_init(pcan_init);
-
-static void __exit pcan_exit(void)
-{
-	pcmcia_unregister_driver(&pcan_driver);
-}
-module_exit(pcan_exit);
+module_pcmcia_driver(pcan_driver);
diff --git a/drivers/net/ethernet/3com/3c574_cs.c b/drivers/net/ethernet/3com/3c574_cs.c
index ffd8de2..6fc994f 100644
--- a/drivers/net/ethernet/3com/3c574_cs.c
+++ b/drivers/net/ethernet/3com/3c574_cs.c
@@ -1165,16 +1165,4 @@ static struct pcmcia_driver tc574_driver = {
 	.suspend	= tc574_suspend,
 	.resume		= tc574_resume,
 };
-
-static int __init init_tc574(void)
-{
-	return pcmcia_register_driver(&tc574_driver);
-}
-
-static void __exit exit_tc574(void)
-{
-	pcmcia_unregister_driver(&tc574_driver);
-}
-
-module_init(init_tc574);
-module_exit(exit_tc574);
+module_pcmcia_driver(tc574_driver);
diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3com/3c589_cs.c
index a556c01..078480a 100644
--- a/drivers/net/ethernet/3com/3c589_cs.c
+++ b/drivers/net/ethernet/3com/3c589_cs.c
@@ -928,16 +928,4 @@ static struct pcmcia_driver tc589_driver = {
 	.suspend	= tc589_suspend,
 	.resume		= tc589_resume,
 };
-
-static int __init init_tc589(void)
-{
-	return pcmcia_register_driver(&tc589_driver);
-}
-
-static void __exit exit_tc589(void)
-{
-	pcmcia_unregister_driver(&tc589_driver);
-}
-
-module_init(init_tc589);
-module_exit(exit_tc589);
+module_pcmcia_driver(tc589_driver);
diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index e1b3941..d801c141 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -728,19 +728,7 @@ static struct pcmcia_driver axnet_cs_driver = {
 	.suspend	= axnet_suspend,
 	.resume		= axnet_resume,
 };
-
-static int __init init_axnet_cs(void)
-{
-	return pcmcia_register_driver(&axnet_cs_driver);
-}
-
-static void __exit exit_axnet_cs(void)
-{
-	pcmcia_unregister_driver(&axnet_cs_driver);
-}
-
-module_init(init_axnet_cs);
-module_exit(exit_axnet_cs);
+module_pcmcia_driver(axnet_cs_driver);
 
 /*====================================================================*/
 
diff --git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c
index de1af0b..46c5aad 100644
--- a/drivers/net/ethernet/8390/pcnet_cs.c
+++ b/drivers/net/ethernet/8390/pcnet_cs.c
@@ -1694,16 +1694,4 @@ static struct pcmcia_driver pcnet_driver = {
 	.suspend	= pcnet_suspend,
 	.resume		= pcnet_resume,
 };
-
-static int __init init_pcnet_cs(void)
-{
-    return pcmcia_register_driver(&pcnet_driver);
-}
-
-static void __exit exit_pcnet_cs(void)
-{
-    pcmcia_unregister_driver(&pcnet_driver);
-}
-
-module_init(init_pcnet_cs);
-module_exit(exit_pcnet_cs);
+module_pcmcia_driver(pcnet_driver);
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 9f59bf6..d4ed891 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -1508,16 +1508,4 @@ static struct pcmcia_driver nmclan_cs_driver = {
 	.suspend	= nmclan_suspend,
 	.resume		= nmclan_resume,
 };
-
-static int __init init_nmclan_cs(void)
-{
-	return pcmcia_register_driver(&nmclan_cs_driver);
-}
-
-static void __exit exit_nmclan_cs(void)
-{
-	pcmcia_unregister_driver(&nmclan_cs_driver);
-}
-
-module_init(init_nmclan_cs);
-module_exit(exit_nmclan_cs);
+module_pcmcia_driver(nmclan_cs_driver);
diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index 2418faf..ab98b77 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -705,19 +705,7 @@ static struct pcmcia_driver fmvj18x_cs_driver = {
 	.suspend	= fmvj18x_suspend,
 	.resume		= fmvj18x_resume,
 };
-
-static int __init init_fmvj18x_cs(void)
-{
-	return pcmcia_register_driver(&fmvj18x_cs_driver);
-}
-
-static void __exit exit_fmvj18x_cs(void)
-{
-	pcmcia_unregister_driver(&fmvj18x_cs_driver);
-}
-
-module_init(init_fmvj18x_cs);
-module_exit(exit_fmvj18x_cs);
+module_pcmcia_driver(fmvj18x_cs_driver);
 
 /*====================================================================*/
 
diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethernet/smsc/smc91c92_cs.c
index 04393b5..656d2e2 100644
--- a/drivers/net/ethernet/smsc/smc91c92_cs.c
+++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
@@ -2054,16 +2054,4 @@ static struct pcmcia_driver smc91c92_cs_driver = {
 	.suspend	= smc91c92_suspend,
 	.resume		= smc91c92_resume,
 };
-
-static int __init init_smc91c92_cs(void)
-{
-	return pcmcia_register_driver(&smc91c92_cs_driver);
-}
-
-static void __exit exit_smc91c92_cs(void)
-{
-	pcmcia_unregister_driver(&smc91c92_cs_driver);
-}
-
-module_init(init_smc91c92_cs);
-module_exit(exit_smc91c92_cs);
+module_pcmcia_driver(smc91c92_cs_driver);
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 98e09d0..1025b4e 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -1775,21 +1775,7 @@ static struct pcmcia_driver xirc2ps_cs_driver = {
 	.suspend	= xirc2ps_suspend,
 	.resume		= xirc2ps_resume,
 };
-
-static int __init
-init_xirc2ps_cs(void)
-{
-	return pcmcia_register_driver(&xirc2ps_cs_driver);
-}
-
-static void __exit
-exit_xirc2ps_cs(void)
-{
-	pcmcia_unregister_driver(&xirc2ps_cs_driver);
-}
-
-module_init(init_xirc2ps_cs);
-module_exit(exit_xirc2ps_cs);
+module_pcmcia_driver(xirc2ps_cs_driver);
 
 #ifndef MODULE
 static int __init setup_xirc2ps_cs(char *str)
diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
index 956024a..14128fd 100644
--- a/drivers/net/wireless/airo_cs.c
+++ b/drivers/net/wireless/airo_cs.c
@@ -180,16 +180,7 @@ static struct pcmcia_driver airo_driver = {
 	.suspend	= airo_suspend,
 	.resume		= airo_resume,
 };
-
-static int __init airo_cs_init(void)
-{
-	return pcmcia_register_driver(&airo_driver);
-}
-
-static void __exit airo_cs_cleanup(void)
-{
-	pcmcia_unregister_driver(&airo_driver);
-}
+module_pcmcia_driver(airo_driver);
 
 /*
     This program is free software; you can redistribute it and/or
@@ -229,6 +220,3 @@ static void __exit airo_cs_cleanup(void)
     IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
     POSSIBILITY OF SUCH DAMAGE.
 */
-
-module_init(airo_cs_init);
-module_exit(airo_cs_cleanup);
diff --git a/drivers/net/wireless/atmel_cs.c b/drivers/net/wireless/atmel_cs.c
index b42930f..5225722 100644
--- a/drivers/net/wireless/atmel_cs.c
+++ b/drivers/net/wireless/atmel_cs.c
@@ -245,16 +245,7 @@ static struct pcmcia_driver atmel_driver = {
 	.suspend	= atmel_suspend,
 	.resume		= atmel_resume,
 };
-
-static int __init atmel_cs_init(void)
-{
-        return pcmcia_register_driver(&atmel_driver);
-}
-
-static void __exit atmel_cs_cleanup(void)
-{
-        pcmcia_unregister_driver(&atmel_driver);
-}
+module_pcmcia_driver(atmel_driver);
 
 /*
     This program is free software; you can redistribute it and/or
@@ -294,6 +285,3 @@ static void __exit atmel_cs_cleanup(void)
     IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
     POSSIBILITY OF SUCH DAMAGE.
 */
-
-module_init(atmel_cs_init);
-module_exit(atmel_cs_cleanup);
diff --git a/drivers/net/wireless/b43/pcmcia.c b/drivers/net/wireless/b43/pcmcia.c
index f2ea2ce..55f2bd7 100644
--- a/drivers/net/wireless/b43/pcmcia.c
+++ b/drivers/net/wireless/b43/pcmcia.c
@@ -130,6 +130,10 @@ static struct pcmcia_driver b43_pcmcia_driver = {
 	.resume		= b43_pcmcia_resume,
 };
 
+/*
+ * These are not module init/exit functions!
+ * The module_pcmcia_driver() helper cannot be used here.
+ */
 int b43_pcmcia_init(void)
 {
 	return pcmcia_register_driver(&b43_pcmcia_driver);
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 89e9d3a..56cd01c 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -709,17 +709,4 @@ static struct pcmcia_driver hostap_driver = {
 	.suspend	= hostap_cs_suspend,
 	.resume		= hostap_cs_resume,
 };
-
-static int __init init_prism2_pccard(void)
-{
-	return pcmcia_register_driver(&hostap_driver);
-}
-
-static void __exit exit_prism2_pccard(void)
-{
-	pcmcia_unregister_driver(&hostap_driver);
-}
-
-
-module_init(init_prism2_pccard);
-module_exit(exit_prism2_pccard);
+module_pcmcia_driver(hostap_driver);
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 16beaf3..c94dd68 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -999,7 +999,6 @@ static const struct pcmcia_device_id if_cs_ids[] = {
 };
 MODULE_DEVICE_TABLE(pcmcia, if_cs_ids);
 
-
 static struct pcmcia_driver lbs_driver = {
 	.owner		= THIS_MODULE,
 	.name		= DRV_NAME,
@@ -1007,26 +1006,4 @@ static struct pcmcia_driver lbs_driver = {
 	.remove		= if_cs_detach,
 	.id_table       = if_cs_ids,
 };
-
-
-static int __init if_cs_init(void)
-{
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_CS);
-	ret = pcmcia_register_driver(&lbs_driver);
-	lbs_deb_leave(LBS_DEB_CS);
-	return ret;
-}
-
-
-static void __exit if_cs_exit(void)
-{
-	lbs_deb_enter(LBS_DEB_CS);
-	pcmcia_unregister_driver(&lbs_driver);
-	lbs_deb_leave(LBS_DEB_CS);
-}
-
-
-module_init(if_cs_init);
-module_exit(if_cs_exit);
+module_pcmcia_driver(lbs_driver);
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index d7dbc00..d21d959 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -338,18 +338,4 @@ static struct pcmcia_driver orinoco_driver = {
 	.suspend	= orinoco_cs_suspend,
 	.resume		= orinoco_cs_resume,
 };
-
-static int __init
-init_orinoco_cs(void)
-{
-	return pcmcia_register_driver(&orinoco_driver);
-}
-
-static void __exit
-exit_orinoco_cs(void)
-{
-	pcmcia_unregister_driver(&orinoco_driver);
-}
-
-module_init(init_orinoco_cs);
-module_exit(exit_orinoco_cs);
+module_pcmcia_driver(orinoco_driver);
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index 6e28ee4..e2264bc 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -318,18 +318,4 @@ static struct pcmcia_driver orinoco_driver = {
 	.resume		= spectrum_cs_resume,
 	.id_table       = spectrum_cs_ids,
 };
-
-static int __init
-init_spectrum_cs(void)
-{
-	return pcmcia_register_driver(&orinoco_driver);
-}
-
-static void __exit
-exit_spectrum_cs(void)
-{
-	pcmcia_unregister_driver(&orinoco_driver);
-}
-
-module_init(init_spectrum_cs);
-module_exit(exit_spectrum_cs);
+module_pcmcia_driver(orinoco_driver);
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 730186d..38d2089 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -2013,19 +2013,7 @@ static struct pcmcia_driver wl3501_driver = {
 	.suspend	= wl3501_suspend,
 	.resume		= wl3501_resume,
 };
-
-static int __init wl3501_init_module(void)
-{
-	return pcmcia_register_driver(&wl3501_driver);
-}
-
-static void __exit wl3501_exit_module(void)
-{
-	pcmcia_unregister_driver(&wl3501_driver);
-}
-
-module_init(wl3501_init_module);
-module_exit(wl3501_exit_module);
+module_pcmcia_driver(wl3501_driver);
 
 MODULE_AUTHOR("Fox Chen <mhchen@golf.ccl.itri.org.tw>, "
 	      "Arnaldo Carvalho de Melo <acme@conectiva.com.br>,"
-- 
1.8.1.1.293.gfe73786

