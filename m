Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbaIOVML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:12:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaIOT0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.16 045/158] powerpc/thp: Use ACCESS_ONCE when loading pmdp
Date: Mon, 15 Sep 2014 12:24:44 -0700
Message-Id: <20140915192544.253424132@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit 7e467245bf5226db34c4b12d3cbacfa2f7a15a8b upstream.

We would get wrong results in compiler recomputed old_pmd. Avoid
that by using ACCESS_ONCE

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/hugepage-hash64.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/hugepage-hash64.c
+++ b/arch/powerpc/mm/hugepage-hash64.c
@@ -84,7 +84,9 @@ int __hash_page_thp(unsigned long ea, un
 	 * atomically mark the linux large page PMD busy and dirty
 	 */
 	do {
-		old_pmd = pmd_val(*pmdp);
+		pmd_t pmd = ACCESS_ONCE(*pmdp);
+
+		old_pmd = pmd_val(pmd);
 		/* If PMD busy, retry the access */
 		if (unlikely(old_pmd & _PAGE_BUSY))
 			return 0;


