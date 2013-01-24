Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3AXTni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:43:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab3AXTna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:43:30 -0500
Date: Thu, 24 Jan 2013 14:43:25 -0500
From: Kyle McMartin <kyle@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] unhide CONFIG_PANIC_ON_OOPS
Message-ID: <20130124194325.GK6538@redacted.bos.redhat.com>
References: <20130122192102.GE6538@redacted.bos.redhat.com>
 <20130123140440.8a4b1e3f.akpm@linux-foundation.org>
 <20130124101854.GC27602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124101854.GC27602@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_EXPERT doesn't really make sense, and hides it unintentionally.
Remove superfluous "default n" pointed out by Ingo as well.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -243,8 +243,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
 config PANIC_ON_OOPS
-	bool "Panic on Oops" if EXPERT
-	default n
+	bool "Panic on Oops"
 	help
 	  Say Y here to enable the kernel to panic when it oopses. This
 	  has the same effect as setting oops=panic on the kernel command
