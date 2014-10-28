Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbaJ1G6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:58:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbaJ1DrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:47:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Bob Picco <bob.picco@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 3.16 125/127] sparc64: Increase size of boot string to 1024 bytes
Date: Tue, 28 Oct 2014 11:36:00 +0800
Message-Id: <20141028033426.313737784@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 1cef94c36bd4d79b5ae3a3df99ee0d76d6a4a6dc ]

This is the longest boot string that silo supports.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/prom/bootstr_64.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/sparc/prom/bootstr_64.c
+++ b/arch/sparc/prom/bootstr_64.c
@@ -14,7 +14,10 @@
  *          the .bss section or it will break things.
  */
 
-#define BARG_LEN  256
+/* We limit BARG_LEN to 1024 because this is the size of the
+ * 'barg_out' command line buffer in the SILO bootloader.
+ */
+#define BARG_LEN 1024
 struct {
 	int bootstr_len;
 	int bootstr_valid;


