Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaFXTus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:50:48 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54667 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaFXTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:50:26 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] x86,vdso2c: Error out if DT_RELA is present
Date: Tue, 24 Jun 2014 12:50:09 -0700
Message-Id: <15462da56ba08baeecfdcb34bd2d491caae8327d.1403639279.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1403639279.git.luto@amacapital.net>
References: <53A9C6EB.50900@zytor.com>
 <cover.1403639279.git.luto@amacapital.net>
In-Reply-To: <cover.1403639279.git.luto@amacapital.net>
References: <cover.1403639279.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was missing from the list of inappropriate dynamic entries.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vdso2c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index f42e2dd..df95a2f 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -164,7 +164,7 @@ static void BITSFUNC(go)(void *addr, size_t len,
 	for (i = 0; dyn + i < dyn_end &&
 		     GET_LE(&dyn[i].d_tag) != DT_NULL; i++) {
 		typeof(dyn[i].d_tag) tag = GET_LE(&dyn[i].d_tag);
-		if (tag == DT_REL || tag == DT_RELSZ ||
+		if (tag == DT_REL || tag == DT_RELSZ || tag == DT_RELA ||
 		    tag == DT_RELENT || tag == DT_TEXTREL)
 			fail("vdso image contains dynamic relocations\n");
 	}
-- 
1.9.3

