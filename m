Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaLNUnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:43:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaLNUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Casteyde <casteyde.christian@free.fr>,
        Henrik Rydberg <rydberg@euromail.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 03/47] drivers/input/evdev.c: dont kfree() a vmalloc address
Date: Sun, 14 Dec 2014 12:20:38 -0800
Message-Id: <20141214201818.654240503@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 92788ac1eb06e69a822de45e2a8a63fa45eb5be2 upstream.

If kzalloc() failed and then evdev_open_device() fails, evdev_open()
will pass a vmalloc'ed pointer to kfree.

This might fix https://bugzilla.kernel.org/show_bug.cgi?id=88401, where
there was a crash in kfree().

Reported-by: Christian Casteyde <casteyde.christian@free.fr>
Belatedly-Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/evdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -421,7 +421,7 @@ static int evdev_open(struct inode *inod
 
  err_free_client:
 	evdev_detach_client(evdev, client);
-	kfree(client);
+	kvfree(client);
 	return error;
 }
 


