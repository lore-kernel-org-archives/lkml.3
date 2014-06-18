Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaFRXAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:00:11 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:44403 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaFRXAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:00:06 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Josh Boyer <jwboyer@fedoraproject.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/5] x86,vdso: Discard the __bug_table section
Date: Wed, 18 Jun 2014 15:59:46 -0700
Message-Id: <2a5bebff42defd8a5e81d96f7dc00f21143c80e8.1403129369.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
References: <cover.1403129369.git.luto@amacapital.net>
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
References: <cover.1403129369.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It serves no purpose in user code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vdso-layout.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 2ec72f6..c84166c 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -75,6 +75,7 @@ SECTIONS
 	/DISCARD/ : {
 		*(.discard)
 		*(.discard.*)
+		*(__bug_table)
 	}
 }
 
-- 
1.9.3

