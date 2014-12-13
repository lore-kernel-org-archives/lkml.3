Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbaLMBOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 20:14:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54315 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932591AbaLMBOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 20:14:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [Resend][PATCH] NFC / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Sat, 13 Dec 2014 02:36:19 +0100
Message-ID: <2345337.9Neq3LLH1l@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1783661.J0PllbRLKd@vostro.rjw.lan>
References: <1783661.J0PllbRLKd@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: NFC / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM

After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
depending on CONFIG_PM_RUNTIME may now be changed to depend on
CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM in drivers/nfc/trf7970a.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Please let me know if there are any objections against this.  If not, I'll
take it through the linux-pm tree, as I'm going to remove CONFIG_PM_RUNTIME
entirely shortly.

---
 drivers/nfc/trf7970a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/nfc/trf7970a.c
===================================================================
--- linux-pm.orig/drivers/nfc/trf7970a.c
+++ linux-pm/drivers/nfc/trf7970a.c
@@ -2154,7 +2154,7 @@ static int trf7970a_resume(struct device
 }
 #endif
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int trf7970a_pm_runtime_suspend(struct device *dev)
 {
 	struct spi_device *spi = container_of(dev, struct spi_device, dev);

