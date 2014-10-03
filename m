Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbaJCXZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:25:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760AbaJCWNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dann Frazier <dann.frazier@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.16 354/357] staging/lustre: disable virtual block device for 64K pages
Date: Fri,  3 Oct 2014 14:32:20 -0700
Message-Id: <20141003212944.091198559@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 0bf22be0da8ea74bc7ccc5b07d7855830be16eca upstream.

The lustre virtual block device cannot handle 64K pages and fails at compile
time. To avoid running into this error, let's disable the Kconfig option
for this driver in cases it doesn't support.

Reported-by: Dann Frazier <dann.frazier@canonical.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/lustre/lustre/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -57,4 +57,5 @@ config LUSTRE_TRANSLATE_ERRNOS
 config LUSTRE_LLITE_LLOOP
 	tristate "Lustre virtual block device"
 	depends on LUSTRE_FS && BLOCK
+	depends on !PPC_64K_PAGES && !ARM64_64K_PAGES
 	default m


