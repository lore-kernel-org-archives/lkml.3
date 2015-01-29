Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbbA2BZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:47 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:61973 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbbA2BZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:43 -0500
From: Ruslan Bilovol <ruslan.bilovol@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gregkh@linuxfoundation.org
Cc: andrzej.p@samsung.com
Subject: [PATCH 2/2] usb: gadget: legacy: don't use __init/__exit attributes for bind/unbind path
Date: Thu, 29 Jan 2015 03:25:34 +0200
Message-Id: <1422494734-9499-3-git-send-email-ruslan.bilovol@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422494734-9499-1-git-send-email-ruslan.bilovol@gmail.com>
References: <1422494734-9499-1-git-send-email-ruslan.bilovol@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it's possible now to do independent gadget and
gadget driver registration in udc-core, some of the
functions can't have __init/__exit attributes (almost
bind/unbind callbacks are affected)

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
---
 drivers/usb/gadget/legacy/acm_ms.c       |  6 +++---
 drivers/usb/gadget/legacy/audio.c        |  6 +++---
 drivers/usb/gadget/legacy/cdc2.c         |  6 +++---
 drivers/usb/gadget/legacy/dbgp.c         |  2 +-
 drivers/usb/gadget/legacy/ether.c        |  8 ++++----
 drivers/usb/gadget/legacy/gmidi.c        |  6 +++---
 drivers/usb/gadget/legacy/hid.c          |  6 +++---
 drivers/usb/gadget/legacy/mass_storage.c |  4 ++--
 drivers/usb/gadget/legacy/multi.c        | 16 ++++++++--------
 drivers/usb/gadget/legacy/ncm.c          |  6 +++---
 drivers/usb/gadget/legacy/nokia.c        |  6 +++---
 drivers/usb/gadget/legacy/printer.c      |  6 +++---
 drivers/usb/gadget/legacy/serial.c       |  2 +-
 drivers/usb/gadget/legacy/webcam.c       |  4 ++--
 drivers/usb/gadget/legacy/zero.c         |  2 +-
 15 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/usb/gadget/legacy/acm_ms.c b/drivers/usb/gadget/legacy/acm_ms.c
index c30b7b5..3a48aab 100644
--- a/drivers/usb/gadget/legacy/acm_ms.c
+++ b/drivers/usb/gadget/legacy/acm_ms.c
@@ -121,7 +121,7 @@ static struct usb_function *f_msg;
 /*
  * We _always_ have both ACM and mass storage functions.
  */
-static int __init acm_ms_do_config(struct usb_configuration *c)
+static int acm_ms_do_config(struct usb_configuration *c)
 {
 	struct fsg_opts *opts;
 	int	status;
@@ -174,7 +174,7 @@ static struct usb_configuration acm_ms_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __init acm_ms_bind(struct usb_composite_dev *cdev)
+static int acm_ms_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget	*gadget = cdev->gadget;
 	struct fsg_opts		*opts;
@@ -249,7 +249,7 @@ fail_get_msg:
 	return status;
 }
 
-static int __exit acm_ms_unbind(struct usb_composite_dev *cdev)
+static int acm_ms_unbind(struct usb_composite_dev *cdev)
 {
 	usb_put_function(f_msg);
 	usb_put_function_instance(fi_msg);
diff --git a/drivers/usb/gadget/legacy/audio.c b/drivers/usb/gadget/legacy/audio.c
index f46a395..ba95518 100644
--- a/drivers/usb/gadget/legacy/audio.c
+++ b/drivers/usb/gadget/legacy/audio.c
@@ -167,7 +167,7 @@ static const struct usb_descriptor_header *otg_desc[] = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __init audio_do_config(struct usb_configuration *c)
+static int audio_do_config(struct usb_configuration *c)
 {
 	int status;
 
@@ -216,7 +216,7 @@ static struct usb_configuration audio_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __init audio_bind(struct usb_composite_dev *cdev)
+static int audio_bind(struct usb_composite_dev *cdev)
 {
 #ifndef CONFIG_GADGET_UAC1
 	struct f_uac2_opts	*uac2_opts;
@@ -276,7 +276,7 @@ fail:
 	return status;
 }
 
-static int __exit audio_unbind(struct usb_composite_dev *cdev)
+static int audio_unbind(struct usb_composite_dev *cdev)
 {
 #ifdef CONFIG_GADGET_UAC1
 	if (!IS_ERR_OR_NULL(f_uac1))
diff --git a/drivers/usb/gadget/legacy/cdc2.c b/drivers/usb/gadget/legacy/cdc2.c
index 2e85d94..8d1985c 100644
--- a/drivers/usb/gadget/legacy/cdc2.c
+++ b/drivers/usb/gadget/legacy/cdc2.c
@@ -104,7 +104,7 @@ static struct usb_function_instance *fi_ecm;
 /*
  * We _always_ have both CDC ECM and CDC ACM functions.
  */
-static int __init cdc_do_config(struct usb_configuration *c)
+static int cdc_do_config(struct usb_configuration *c)
 {
 	int	status;
 
@@ -153,7 +153,7 @@ static struct usb_configuration cdc_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __init cdc_bind(struct usb_composite_dev *cdev)
+static int cdc_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget	*gadget = cdev->gadget;
 	struct f_ecm_opts	*ecm_opts;
@@ -211,7 +211,7 @@ fail:
 	return status;
 }
 
-static int __exit cdc_unbind(struct usb_composite_dev *cdev)
+static int cdc_unbind(struct usb_composite_dev *cdev)
 {
 	usb_put_function(f_acm);
 	usb_put_function_instance(fi_serial);
diff --git a/drivers/usb/gadget/legacy/dbgp.c b/drivers/usb/gadget/legacy/dbgp.c
index 633683a..7c42b01 100644
--- a/drivers/usb/gadget/legacy/dbgp.c
+++ b/drivers/usb/gadget/legacy/dbgp.c
@@ -284,7 +284,7 @@ fail_1:
 	return -ENODEV;
 }
 
-static int __init dbgp_bind(struct usb_gadget *gadget,
+static int dbgp_bind(struct usb_gadget *gadget,
 		struct usb_gadget_driver *driver)
 {
 	int err, stp;
diff --git a/drivers/usb/gadget/legacy/ether.c b/drivers/usb/gadget/legacy/ether.c
index c5fdc61..4283969 100644
--- a/drivers/usb/gadget/legacy/ether.c
+++ b/drivers/usb/gadget/legacy/ether.c
@@ -222,7 +222,7 @@ static struct usb_function *f_rndis;
  * the first one present.  That's to make Microsoft's drivers happy,
  * and to follow DOCSIS 1.0 (cable modem standard).
  */
-static int __init rndis_do_config(struct usb_configuration *c)
+static int rndis_do_config(struct usb_configuration *c)
 {
 	int status;
 
@@ -264,7 +264,7 @@ MODULE_PARM_DESC(use_eem, "use CDC EEM mode");
 /*
  * We _always_ have an ECM, CDC Subset, or EEM configuration.
  */
-static int __init eth_do_config(struct usb_configuration *c)
+static int eth_do_config(struct usb_configuration *c)
 {
 	int status = 0;
 
@@ -318,7 +318,7 @@ static struct usb_configuration eth_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __init eth_bind(struct usb_composite_dev *cdev)
+static int eth_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget	*gadget = cdev->gadget;
 	struct f_eem_opts	*eem_opts = NULL;
@@ -447,7 +447,7 @@ fail:
 	return status;
 }
 
-static int __exit eth_unbind(struct usb_composite_dev *cdev)
+static int eth_unbind(struct usb_composite_dev *cdev)
 {
 	if (has_rndis()) {
 		usb_put_function(f_rndis);
diff --git a/drivers/usb/gadget/legacy/gmidi.c b/drivers/usb/gadget/legacy/gmidi.c
index e02a095..c098281 100644
--- a/drivers/usb/gadget/legacy/gmidi.c
+++ b/drivers/usb/gadget/legacy/gmidi.c
@@ -118,7 +118,7 @@ static struct usb_gadget_strings *dev_strings[] = {
 static struct usb_function_instance *fi_midi;
 static struct usb_function *f_midi;
 
-static int __exit midi_unbind(struct usb_composite_dev *dev)
+static int midi_unbind(struct usb_composite_dev *dev)
 {
 	usb_put_function(f_midi);
 	usb_put_function_instance(fi_midi);
@@ -133,7 +133,7 @@ static struct usb_configuration midi_config = {
 	.MaxPower	= CONFIG_USB_GADGET_VBUS_DRAW,
 };
 
-static int __init midi_bind_config(struct usb_configuration *c)
+static int midi_bind_config(struct usb_configuration *c)
 {
 	int status;
 
@@ -150,7 +150,7 @@ static int __init midi_bind_config(struct usb_configuration *c)
 	return 0;
 }
 
-static int __init midi_bind(struct usb_composite_dev *cdev)
+static int midi_bind(struct usb_composite_dev *cdev)
 {
 	struct f_midi_opts *midi_opts;
 	int status;
diff --git a/drivers/usb/gadget/legacy/hid.c b/drivers/usb/gadget/legacy/hid.c
index 614b06d..11de01b 100644
--- a/drivers/usb/gadget/legacy/hid.c
+++ b/drivers/usb/gadget/legacy/hid.c
@@ -106,7 +106,7 @@ static struct usb_gadget_strings *dev_strings[] = {
 
 /****************************** Configurations ******************************/
 
-static int __init do_config(struct usb_configuration *c)
+static int do_config(struct usb_configuration *c)
 {
 	struct hidg_func_node *e, *n;
 	int status = 0;
@@ -147,7 +147,7 @@ static struct usb_configuration config_driver = {
 
 /****************************** Gadget Bind ******************************/
 
-static int __init hid_bind(struct usb_composite_dev *cdev)
+static int hid_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget *gadget = cdev->gadget;
 	struct list_head *tmp;
@@ -205,7 +205,7 @@ put:
 	return status;
 }
 
-static int __exit hid_unbind(struct usb_composite_dev *cdev)
+static int hid_unbind(struct usb_composite_dev *cdev)
 {
 	struct hidg_func_node *n;
 
diff --git a/drivers/usb/gadget/legacy/mass_storage.c b/drivers/usb/gadget/legacy/mass_storage.c
index 8e27a8c..d169d43 100644
--- a/drivers/usb/gadget/legacy/mass_storage.c
+++ b/drivers/usb/gadget/legacy/mass_storage.c
@@ -130,7 +130,7 @@ static int msg_thread_exits(struct fsg_common *common)
 	return 0;
 }
 
-static int __init msg_do_config(struct usb_configuration *c)
+static int msg_do_config(struct usb_configuration *c)
 {
 	struct fsg_opts *opts;
 	int ret;
@@ -170,7 +170,7 @@ static struct usb_configuration msg_config_driver = {
 
 /****************************** Gadget Bind ******************************/
 
-static int __init msg_bind(struct usb_composite_dev *cdev)
+static int msg_bind(struct usb_composite_dev *cdev)
 {
 	static const struct fsg_operations ops = {
 		.thread_exits = msg_thread_exits,
diff --git a/drivers/usb/gadget/legacy/multi.c b/drivers/usb/gadget/legacy/multi.c
index 39d27bb..4a4a1a1 100644
--- a/drivers/usb/gadget/legacy/multi.c
+++ b/drivers/usb/gadget/legacy/multi.c
@@ -149,7 +149,7 @@ static struct usb_function *f_acm_rndis;
 static struct usb_function *f_rndis;
 static struct usb_function *f_msg_rndis;
 
-static __init int rndis_do_config(struct usb_configuration *c)
+static int rndis_do_config(struct usb_configuration *c)
 {
 	struct fsg_opts *fsg_opts;
 	int ret;
@@ -206,7 +206,7 @@ err_func_rndis:
 	return ret;
 }
 
-static __ref int rndis_config_register(struct usb_composite_dev *cdev)
+static int rndis_config_register(struct usb_composite_dev *cdev)
 {
 	static struct usb_configuration config = {
 		.bConfigurationValue	= MULTI_RNDIS_CONFIG_NUM,
@@ -221,7 +221,7 @@ static __ref int rndis_config_register(struct usb_composite_dev *cdev)
 
 #else
 
-static __ref int rndis_config_register(struct usb_composite_dev *cdev)
+static int rndis_config_register(struct usb_composite_dev *cdev)
 {
 	return 0;
 }
@@ -237,7 +237,7 @@ static struct usb_function *f_acm_multi;
 static struct usb_function *f_ecm;
 static struct usb_function *f_msg_multi;
 
-static __init int cdc_do_config(struct usb_configuration *c)
+static int cdc_do_config(struct usb_configuration *c)
 {
 	struct fsg_opts *fsg_opts;
 	int ret;
@@ -295,7 +295,7 @@ err_func_ecm:
 	return ret;
 }
 
-static __ref int cdc_config_register(struct usb_composite_dev *cdev)
+static int cdc_config_register(struct usb_composite_dev *cdev)
 {
 	static struct usb_configuration config = {
 		.bConfigurationValue	= MULTI_CDC_CONFIG_NUM,
@@ -310,7 +310,7 @@ static __ref int cdc_config_register(struct usb_composite_dev *cdev)
 
 #else
 
-static __ref int cdc_config_register(struct usb_composite_dev *cdev)
+static int cdc_config_register(struct usb_composite_dev *cdev)
 {
 	return 0;
 }
@@ -321,7 +321,7 @@ static __ref int cdc_config_register(struct usb_composite_dev *cdev)
 
 /****************************** Gadget Bind ******************************/
 
-static int __ref multi_bind(struct usb_composite_dev *cdev)
+static int multi_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget *gadget = cdev->gadget;
 #ifdef CONFIG_USB_G_MULTI_CDC
@@ -466,7 +466,7 @@ fail:
 	return status;
 }
 
-static int __exit multi_unbind(struct usb_composite_dev *cdev)
+static int multi_unbind(struct usb_composite_dev *cdev)
 {
 #ifdef CONFIG_USB_G_MULTI_CDC
 	usb_put_function(f_msg_multi);
diff --git a/drivers/usb/gadget/legacy/ncm.c b/drivers/usb/gadget/legacy/ncm.c
index e90e23d..fb14e0c 100644
--- a/drivers/usb/gadget/legacy/ncm.c
+++ b/drivers/usb/gadget/legacy/ncm.c
@@ -107,7 +107,7 @@ static struct usb_function *f_ncm;
 
 /*-------------------------------------------------------------------------*/
 
-static int __init ncm_do_config(struct usb_configuration *c)
+static int ncm_do_config(struct usb_configuration *c)
 {
 	int status;
 
@@ -143,7 +143,7 @@ static struct usb_configuration ncm_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __init gncm_bind(struct usb_composite_dev *cdev)
+static int gncm_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget	*gadget = cdev->gadget;
 	struct f_ncm_opts	*ncm_opts;
@@ -186,7 +186,7 @@ fail:
 	return status;
 }
 
-static int __exit gncm_unbind(struct usb_composite_dev *cdev)
+static int gncm_unbind(struct usb_composite_dev *cdev)
 {
 	if (!IS_ERR_OR_NULL(f_ncm))
 		usb_put_function(f_ncm);
diff --git a/drivers/usb/gadget/legacy/nokia.c b/drivers/usb/gadget/legacy/nokia.c
index 9b8fd70..7ad8398 100644
--- a/drivers/usb/gadget/legacy/nokia.c
+++ b/drivers/usb/gadget/legacy/nokia.c
@@ -118,7 +118,7 @@ static struct usb_function_instance *fi_obex1;
 static struct usb_function_instance *fi_obex2;
 static struct usb_function_instance *fi_phonet;
 
-static int __init nokia_bind_config(struct usb_configuration *c)
+static int nokia_bind_config(struct usb_configuration *c)
 {
 	struct usb_function *f_acm;
 	struct usb_function *f_phonet = NULL;
@@ -224,7 +224,7 @@ err_get_acm:
 	return status;
 }
 
-static int __init nokia_bind(struct usb_composite_dev *cdev)
+static int nokia_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget	*gadget = cdev->gadget;
 	int			status;
@@ -307,7 +307,7 @@ err_usb:
 	return status;
 }
 
-static int __exit nokia_unbind(struct usb_composite_dev *cdev)
+static int nokia_unbind(struct usb_composite_dev *cdev)
 {
 	if (!IS_ERR_OR_NULL(f_obex1_cfg2))
 		usb_put_function(f_obex1_cfg2);
diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/legacy/printer.c
index 9054598..da2a89b 100644
--- a/drivers/usb/gadget/legacy/printer.c
+++ b/drivers/usb/gadget/legacy/printer.c
@@ -1034,7 +1034,7 @@ unknown:
 	return value;
 }
 
-static int __init printer_func_bind(struct usb_configuration *c,
+static int printer_func_bind(struct usb_configuration *c,
 		struct usb_function *f)
 {
 	struct printer_dev *dev = container_of(f, struct printer_dev, function);
@@ -1162,7 +1162,7 @@ static struct usb_configuration printer_cfg_driver = {
 	.bmAttributes		= USB_CONFIG_ATT_ONE | USB_CONFIG_ATT_SELFPOWER,
 };
 
-static int __init printer_bind_config(struct usb_configuration *c)
+static int printer_bind_config(struct usb_configuration *c)
 {
 	struct usb_gadget	*gadget = c->cdev->gadget;
 	struct printer_dev	*dev;
@@ -1284,7 +1284,7 @@ static int printer_unbind(struct usb_composite_dev *cdev)
 	return 0;
 }
 
-static int __init printer_bind(struct usb_composite_dev *cdev)
+static int printer_bind(struct usb_composite_dev *cdev)
 {
 	int ret;
 
diff --git a/drivers/usb/gadget/legacy/serial.c b/drivers/usb/gadget/legacy/serial.c
index 1f5f978..812780f 100644
--- a/drivers/usb/gadget/legacy/serial.c
+++ b/drivers/usb/gadget/legacy/serial.c
@@ -174,7 +174,7 @@ out:
 	return ret;
 }
 
-static int __init gs_bind(struct usb_composite_dev *cdev)
+static int gs_bind(struct usb_composite_dev *cdev)
 {
 	int			status;
 
diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget/legacy/webcam.c
index 04a3da2..d200ab4 100644
--- a/drivers/usb/gadget/legacy/webcam.c
+++ b/drivers/usb/gadget/legacy/webcam.c
@@ -334,7 +334,7 @@ static const struct uvc_descriptor_header * const uvc_ss_streaming_cls[] = {
  * USB configuration
  */
 
-static int __init
+static int
 webcam_config_bind(struct usb_configuration *c)
 {
 	int status = 0;
@@ -368,7 +368,7 @@ webcam_unbind(struct usb_composite_dev *cdev)
 	return 0;
 }
 
-static int __init
+static int
 webcam_bind(struct usb_composite_dev *cdev)
 {
 	struct f_uvc_opts *uvc_opts;
diff --git a/drivers/usb/gadget/legacy/zero.c b/drivers/usb/gadget/legacy/zero.c
index ff97ac9..f805bc2 100644
--- a/drivers/usb/gadget/legacy/zero.c
+++ b/drivers/usb/gadget/legacy/zero.c
@@ -289,7 +289,7 @@ static struct usb_function_instance *func_inst_lb;
 module_param_named(qlen, gzero_options.qlen, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(qlen, "depth of loopback queue");
 
-static int __init zero_bind(struct usb_composite_dev *cdev)
+static int zero_bind(struct usb_composite_dev *cdev)
 {
 	struct f_ss_opts	*ss_opts;
 	struct f_lb_opts	*lb_opts;
-- 
1.9.1

