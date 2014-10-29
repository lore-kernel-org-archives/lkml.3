Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbaJ2TZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:25:50 -0400
Received: from mx02.posteo.de ([89.146.194.165]:51662 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700AbaJ2TZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:25:08 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 3/3] char: misc: document behaviour of open()
Date: Wed, 29 Oct 2014 20:22:58 +0100
Message-Id: <1414610578-22779-4-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414610578-22779-1-git-send-email-martink@posteo.de>
References: <1414610578-22779-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

an open syscall now assignes file->private_data to a pointer to the
miscdevice structure. This reminds driver developers not to duplicate
code if they need this.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/char/misc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 205ad4c..69a08a6 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -169,7 +169,9 @@ static const struct file_operations misc_fops = {
  *	the minor number requested is used.
  *
  *	The structure passed is linked into the kernel and may not be
- *	destroyed until it has been unregistered.
+ *	destroyed until it has been unregistered. By default, an open()
+ *	syscall to the device sets file->private_data to point to the
+ *	structure.
  *
  *	A zero is returned on success and a negative errno code for
  *	failure.
-- 
1.7.10.4

