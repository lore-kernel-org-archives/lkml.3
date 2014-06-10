Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaFJWnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:43:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38341 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFJWnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:43:32 -0400
Date: Tue, 10 Jun 2014 15:43:10 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-15ea1a528e08c6bc322f10686ec8d73ba413b941@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20140610135051.c3c34165f73d67d218b62bd9@linux-foundation.org>
References: <20140610135051.c3c34165f73d67d218b62bd9@linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Remove one final use of htole16()
Git-Commit-ID: 15ea1a528e08c6bc322f10686ec8d73ba413b941
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15ea1a528e08c6bc322f10686ec8d73ba413b941
Gitweb:     http://git.kernel.org/tip/15ea1a528e08c6bc322f10686ec8d73ba413b941
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 10 Jun 2014 14:25:26 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 10 Jun 2014 14:25:26 -0700

x86, vdso: Remove one final use of htole16()

One final use of the macros from <endian.h> which are not available on
older system.  In this case we had one sole case of *writing* a
littleendian number, but the number is SHN_UNDEF which is the constant
zero, so rather than dealing with the general case of littleendian
puts here, just document that the constant is zero and be done with
it.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/20140610135051.c3c34165f73d67d218b62bd9@linux-foundation.org
---
 arch/x86/vdso/vdso2c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index 8a07463..d9f6f61 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -116,7 +116,7 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	hdr->e_shoff = 0;
 	hdr->e_shentsize = 0;
 	hdr->e_shnum = 0;
-	hdr->e_shstrndx = htole16(SHN_UNDEF);
+	hdr->e_shstrndx = SHN_UNDEF; /* SHN_UNDEF == 0 */
 
 	if (!name) {
 		fwrite(addr, load_size, 1, outfile);
