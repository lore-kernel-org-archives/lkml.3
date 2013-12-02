Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3LBTrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:47:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3LBTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 149/212] HID: uhid: fix leak for 64/32 UHID_CREATE
Date: Mon,  2 Dec 2013 11:15:40 -0800
Message-Id: <20131202191303.968721793@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -287,7 +287,7 @@ static int uhid_event_from_user(const ch
 			 */
 			struct uhid_create_req_compat *compat;
 
-			compat = kmalloc(sizeof(*compat), GFP_KERNEL);
+			compat = kzalloc(sizeof(*compat), GFP_KERNEL);
 			if (!compat)
 				return -ENOMEM;
 


