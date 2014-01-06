Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbaAFXNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:13:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbaAFWlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Michael Neuling <michael@neuling.org>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 052/129] auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE
Date: Mon,  6 Jan 2014 14:38:01 -0800
Message-Id: <20140106223901.093641239@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit f60900f2609e893c7f8d0bccc7ada4947dac4cd5 upstream.

Commit 2171364d1a92 ("powerpc: Add HWCAP2 aux entry") introduced a new
AT_ auxv entry type AT_HWCAP2 but failed to update AT_VECTOR_SIZE_BASE
accordingly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 2171364d1a92 (powerpc: Add HWCAP2 aux entry)
Acked-by: Michael Neuling <michael@neuling.org>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/auxvec.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -3,6 +3,6 @@
 
 #include <uapi/linux/auxvec.h>
 
-#define AT_VECTOR_SIZE_BASE 19 /* NEW_AUX_ENT entries in auxiliary table */
+#define AT_VECTOR_SIZE_BASE 20 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
 #endif /* _LINUX_AUXVEC_H */


