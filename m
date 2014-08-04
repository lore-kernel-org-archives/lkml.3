Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaHDRRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:17:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56457 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paolo Bonzini" <pbonzini@redhat.com>,
        "Valentine Sinitsyn" <valentine.sinitsyn@gmail.com>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.704814241@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 05/94] KVM: x86: preserve the high 32-bits of the PAT
 register
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 7cb060a91c0efc5ff94f83c6df3ed705e143cdb9 upstream.

KVM does not really do much with the PAT, so this went unnoticed for a
long time.  It is exposed however if you try to do rdmsr on the PAT
register.

Reported-by: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -418,7 +418,7 @@ struct kvm_vcpu_arch {
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 
 	struct mtrr_state_type mtrr_state;
-	u32 pat;
+	u64 pat;
 
 	int switch_db_regs;
 	unsigned long db[KVM_NR_DB_REGS];

