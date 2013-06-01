Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab3FAKI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:08:58 -0400
Received: from www17.your-server.de ([213.133.104.17]:34422 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758681Ab3FAKIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 06:08:48 -0400
Message-ID: <1370081325.29224.42.camel@localhost.localdomain>
Subject: [PATCH] usb: gadget: Cocci spatch "err_cast.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 12:08:45 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1138,7 +1138,7 @@ struct usb_string *usb_gstrings_attach(s
 
 	uc = copy_gadget_strings(sp, n_gstrings, n_strings);
 	if (IS_ERR(uc))
-		return ERR_PTR(PTR_ERR(uc));
+		return ERR_CAST(uc);
 
 	n_gs = get_containers_gs(uc);
 	ret = usb_string_ids_tab(cdev, n_gs[0]->strings);

diff -u -p a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -557,7 +557,7 @@ static struct config_group *function_mak
 
 	fi = usb_get_function_instance(func_name);
 	if (IS_ERR(fi))
-		return ERR_PTR(PTR_ERR(fi));
+		return ERR_CAST(fi);
 
 	ret = config_item_set_name(&fi->group.cg_item, name);
 	if (ret) {


