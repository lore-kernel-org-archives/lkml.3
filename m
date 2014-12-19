Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaLSBmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:42:20 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55892 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751645AbaLSBmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:42:18 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>, Mark Brown <broonie@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 2/4] sound: sst-haswell-pcm: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Fri, 19 Dec 2014 02:51:38 +0100
Message-ID: <26780431.Uk4uOmhdgG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <472992175.g1ArEYGFPo@vostro.rjw.lan>
References: <472992175.g1ArEYGFPo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The sst-haswell-pcm driver is a new user of CONFIG_PM_RUNTIME.

However, after commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) PM_RUNTIME is always set if PM is set, so
#ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
depend on CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM in
sound/soc/intel/sst-haswell-pcm.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Please let me know if there are any objections against pushing this through
the linux-pm tree.

---
 sound/soc/intel/sst-haswell-pcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-pm/sound/soc/intel/sst-haswell-pcm.c
===================================================================
--- linux-pm.orig/sound/soc/intel/sst-haswell-pcm.c
+++ linux-pm/sound/soc/intel/sst-haswell-pcm.c
@@ -998,7 +998,7 @@ static int hsw_pcm_dev_remove(struct pla
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 
 static int hsw_pcm_runtime_idle(struct device *dev)
 {
@@ -1057,7 +1057,7 @@ static int hsw_pcm_runtime_resume(struct
 #define hsw_pcm_runtime_resume		NULL
 #endif
 
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PM_RUNTIME)
+#ifdef CONFIG_PM
 
 static void hsw_pcm_complete(struct device *dev)
 {

