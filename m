Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab3FAJkQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:40:16 -0400
Received: from www17.your-server.de ([213.133.104.17]:58771 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab3FAJkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:40:14 -0400
Message-ID: <1370079602.29224.8.camel@localhost.localdomain>
Subject: [PATCH] efi, pstore: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:40:02 +0200
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

diff -u -p a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -79,10 +79,9 @@ static int efi_pstore_read_func(struct e
 			   &entry->var.DataSize, entry->var.Data);
 	size = entry->var.DataSize;
 
-	*cb_data->buf = kmalloc(size, GFP_KERNEL);
+	*cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
 	if (*cb_data->buf == NULL)
 		return -ENOMEM;
-	memcpy(*cb_data->buf, entry->var.Data, size);
 	return size;
 }
 



