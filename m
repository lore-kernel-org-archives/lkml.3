Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbbA1CFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:05:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820AbbA1B21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.18 43/61] KVM: x86: Fix of previously incomplete fix for CVE-2014-8480
Date: Tue, 27 Jan 2015 17:26:55 -0800
Message-Id: <20150128012641.599394402@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <nadav.amit@gmail.com>

commit 63ea0a49ae0b145b91ff2b070c01b66fc75854b9 upstream.

STR and SLDT with rip-relative operand can cause a host kernel oops.
Mark them as DstMem as well.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3777,8 +3777,8 @@ static const struct opcode group5[] = {
 };
 
 static const struct opcode group6[] = {
-	DI(Prot,	sldt),
-	DI(Prot,	str),
+	DI(Prot | DstMem,	sldt),
+	DI(Prot | DstMem,	str),
 	II(Prot | Priv | SrcMem16, em_lldt, lldt),
 	II(Prot | Priv | SrcMem16, em_ltr, ltr),
 	N, N, N, N,


