Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaGHALk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:11:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbaGHADU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Valentine Sinitsyn <valentine.sinitsyn@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.4 23/44] KVM: x86: preserve the high 32-bits of the PAT register
Date: Mon,  7 Jul 2014 17:07:13 -0700
Message-Id: <20140707235859.343430186@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 7cb060a91c0efc5ff94f83c6df3ed705e143cdb9 upstream.

KVM does not really do much with the PAT, so this went unnoticed for a
long time.  It is exposed however if you try to do rdmsr on the PAT
register.

Reported-by: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -436,7 +436,7 @@ struct kvm_vcpu_arch {
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 
 	struct mtrr_state_type mtrr_state;
-	u32 pat;
+	u64 pat;
 
 	int switch_db_regs;
 	unsigned long db[KVM_NR_DB_REGS];


