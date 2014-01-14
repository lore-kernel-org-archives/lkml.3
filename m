Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbaANBLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:11:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaANA0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:26:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.4 21/27] ARM: fix "bad mode in ... handler" message for undefined instructions
Date: Mon, 13 Jan 2014 16:26:35 -0800
Message-Id: <20140114002623.982748098@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002623.356220317@linuxfoundation.org>
References: <20140114002623.356220317@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -37,7 +37,13 @@
 
 #include "signal.h"
 
-static const char *handler[]= { "prefetch abort", "data abort", "address exception", "interrupt" };
+static const char *handler[]= {
+	"prefetch abort",
+	"data abort",
+	"address exception",
+	"interrupt",
+	"undefined instruction",
+};
 
 void *vectors_page;
 


