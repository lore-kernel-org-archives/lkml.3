Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaANA1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:27:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaANA1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.10 39/62] ARM: fix "bad mode in ... handler" message for undefined instructions
Date: Mon, 13 Jan 2014 16:27:04 -0800
Message-Id: <20140114002711.573380581@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 29c350bf28da333e41e30497b649fe335712a2ab upstream.

The array was missing the final entry for the undefined instruction
exception handler; this commit adds it.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/traps.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -35,7 +35,13 @@
 #include <asm/tls.h>
 #include <asm/system_misc.h>
 
-static const char *handler[]= { "prefetch abort", "data abort", "address exception", "interrupt" };
+static const char *handler[]= {
+	"prefetch abort",
+	"data abort",
+	"address exception",
+	"interrupt",
+	"undefined instruction",
+};
 
 void *vectors_page;
 


