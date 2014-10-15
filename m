Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaJOPeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:34:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaJOPd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:33:59 -0400
Date: Wed, 15 Oct 2014 08:33:40 -0700
From: tip-bot for WANG Chao <tipbot@zytor.com>
Message-ID: <tip-3ea4b8ee2419e21295cabab66c317612c5a55d26@git.kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, chaowang@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@kernel.org,
        chaowang@redhat.com, hpa@zytor.com
In-Reply-To: <1413262019-3759-1-git-send-email-chaowang@redhat.com>
References: <1413262019-3759-1-git-send-email-chaowang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86/purgatory, build:
  Suppress kexec-purgatory.c is up to date message
Git-Commit-ID: 3ea4b8ee2419e21295cabab66c317612c5a55d26
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

Commit-ID:  3ea4b8ee2419e21295cabab66c317612c5a55d26
Gitweb:     http://git.kernel.org/tip/3ea4b8ee2419e21295cabab66c317612c5a55d26
Author:     WANG Chao <chaowang@redhat.com>
AuthorDate: Tue, 14 Oct 2014 12:46:58 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 15 Oct 2014 08:31:21 -0700

x86/purgatory, build: Suppress kexec-purgatory.c is up to date message

Suppress this unnecessary message during kernel re-build
(CONFIG_KEXEC_FILE=y):

make[1]: `arch/x86/purgatory/kexec-purgatory.c' is up to date.

Signed-off-by: WANG Chao <chaowang@redhat.com>
Link: http://lkml.kernel.org/r/1413262019-3759-1-git-send-email-chaowang@redhat.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/purgatory/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 899dd24..2c41066 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -23,6 +23,7 @@ quiet_cmd_bin2c = BIN2C   $@
 
 $(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
 	$(call if_changed,bin2c)
+	@:
 
 
 obj-$(CONFIG_KEXEC_FILE)	+= kexec-purgatory.o
