Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab3APAAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:00:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:43615 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547Ab3AOWfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Graf <agraf@suse.de>, CAI Qian <caiqian@redhat.com>
Subject: [ 189/221] KVM: PPC: 44x: fix DCR read/write
Date: Tue, 15 Jan 2013 10:51:56 -0800
Message-Id: <20130115185011.658108784@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Graf <agraf@suse.de>

commit e43a028752fed049e4bd94ef895542f96d79fa74 upstream.

When remembering the direction of a DCR transaction, we should write
to the same variable that we interpret on later when doing vcpu_run
again.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/44x_emulate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kvm/44x_emulate.c
+++ b/arch/powerpc/kvm/44x_emulate.c
@@ -76,6 +76,7 @@ int kvmppc_core_emulate_op(struct kvm_ru
 				run->dcr.dcrn = dcrn;
 				run->dcr.data =  0;
 				run->dcr.is_write = 0;
+				vcpu->arch.dcr_is_write = 0;
 				vcpu->arch.io_gpr = rt;
 				vcpu->arch.dcr_needed = 1;
 				kvmppc_account_exit(vcpu, DCR_EXITS);
@@ -94,6 +95,7 @@ int kvmppc_core_emulate_op(struct kvm_ru
 				run->dcr.dcrn = dcrn;
 				run->dcr.data = kvmppc_get_gpr(vcpu, rs);
 				run->dcr.is_write = 1;
+				vcpu->arch.dcr_is_write = 1;
 				vcpu->arch.dcr_needed = 1;
 				kvmppc_account_exit(vcpu, DCR_EXITS);
 				emulated = EMULATE_DO_DCR;


