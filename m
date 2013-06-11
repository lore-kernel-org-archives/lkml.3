Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3FKUEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:04:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab3FKUEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "\"stable@vger.kernel.org, linux-s390@vger.kernel.org, Debian kernel
	maintainers\"" <debian-kernel@lists.debian.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 79/79] s390: Add pgste to ptep_modify_prot_start()
Date: Tue, 11 Jun 2013 13:03:45 -0700
Message-Id: <20130611195326.399612021@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Commit 52f36be0f4e2 's390/pgtable: Fix check for pgste/storage key
handling', which was commit b56433cb782d upstream, added a use of
pgste to ptep_modify_prot_start(), but this variable does not exist.
In mainline, pgste was added by commit d3383632d4e8 's390/mm: add pte
invalidation notifier for kvm' and initialised to the return value of
pgste_get_lock(ptep).  Initialise it similarly here.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/pgtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1063,11 +1063,12 @@ static inline pte_t ptep_modify_prot_sta
 					   unsigned long address,
 					   pte_t *ptep)
 {
+	pgste_t pgste;
 	pte_t pte;
 
 	mm->context.flush_mm = 1;
 	if (mm_has_pgste(mm))
-		pgste_get_lock(ptep);
+		pgste = pgste_get_lock(ptep);
 
 	pte = *ptep;
 	if (!mm_exclusive(mm))


