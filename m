Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab3LBUqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:46:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3LBTNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 106/173] HID: uhid: fix leak for 64/32 UHID_CREATE
Date: Mon,  2 Dec 2013 11:11:29 -0800
Message-Id: <20131202191156.127390781@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Herrmann <dh.herrmann@gmail.com>

commit 80897aa787ecd58eabb29deab7cbec9249c9b7e6 upstream.

UHID allows short writes so user-space can omit unused fields. We
automatically set them to 0 in the kernel. However, the 64/32 bit
compat-handler didn't do that in the UHID_CREATE fallback. This will
reveal random kernel heap data (of random size, even) to user-space.

Fixes: befde0226a59 ('HID: uhid: make creating devices work on 64/32 systems')

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/uhid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -312,7 +312,7 @@ static int uhid_event_from_user(const ch
 			 */
 			struct uhid_create_req_compat *compat;
 
-			compat = kmalloc(sizeof(*compat), GFP_KERNEL);
+			compat = kzalloc(sizeof(*compat), GFP_KERNEL);
 			if (!compat)
 				return -ENOMEM;
 


