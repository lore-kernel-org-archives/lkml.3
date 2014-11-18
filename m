Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaKRASF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:18:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50176 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751464AbaKRASC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:18:02 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kevin Hilman <khilman@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is selected (was: Re: [PATCH] PM / domains: Kconfig: always enable PM_RUNTIME when genpd enabled)
Date: Tue, 18 Nov 2014 01:39:06 +0100
Message-ID: <1452958.d0yJE5gVgq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7hioid3cqx.fsf@deeprootsystems.com>
References: <1415917702-6742-1-git-send-email-khilman@kernel.org> <6465990.KKns6W8hQE@vostro.rjw.lan> <7hioid3cqx.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The number of and dependencies between high-level power management
Kconfig options make life much harder than necessary.  Several
conbinations of them have to be tested and supported, even though
some of those combinations are very rarely used in practice (it
they are used in practice at all).  Moreover, the fact that we
have separate independent Kconfig options for runtime PM and
system suspend is a serious obscacle for integration between
the two frameworks.

To overcome these difficulties, always select PM_RUNTIME if PM_SLEEP
is set.  Among other things, this will allow system suspend callbacks
provided by bus types and device drivers to rely on the runtime PM
framework regardless of the kernel configuration.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

As a follow up.

Note that we won't need the patch making genpd select PM_RUNTIME with this,
because genpd already depends on PM.

Thoughts, comments?

Rafael

---
 kernel/power/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-pm/kernel/power/Kconfig
===================================================================
--- linux-pm.orig/kernel/power/Kconfig
+++ linux-pm/kernel/power/Kconfig
@@ -94,6 +94,7 @@ config PM_STD_PARTITION
 config PM_SLEEP
 	def_bool y
 	depends on SUSPEND || HIBERNATE_CALLBACKS
+	select PM_RUNTIME
 
 config PM_SLEEP_SMP
 	def_bool y

