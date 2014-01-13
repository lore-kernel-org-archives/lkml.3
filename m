Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaAMT0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:26:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:11347 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaAMTXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:23:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="458081228"
Subject: [PATCH 10/12] x86 Kconfig: MCE menu
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 11:22:58 -0800
References: <20140113192245.3F682C7F@viggo.jf.intel.com>
In-Reply-To: <20140113192245.3F682C7F@viggo.jf.intel.com>
Message-Id: <20140113192258.7CA1737B@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This is a fairly small one, but it still saves 3 lines in the
top-level menu.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86/Kconfig~x86-mce-menu arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-mce-menu	2014-01-13 11:11:36.408246405 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 11:11:36.412246586 -0800
@@ -1234,7 +1234,7 @@ config X86_VISWS_APIC
 	def_bool y
 	depends on X86_32 && X86_VISWS
 
-config X86_MCE
+menuconfig X86_MCE
 	bool "Machine Check / overheating reporting"
 	default y
 	---help---
@@ -1267,10 +1267,6 @@ config X86_ANCIENT_MCE
 	  systems. These typically need to be enabled explicitely on the command
 	  line.
 
-config X86_MCE_THRESHOLD
-	depends on X86_MCE_AMD || X86_MCE_INTEL
-	def_bool y
-
 config X86_MCE_INJECT
 	depends on X86_MCE
 	tristate "Machine check injector support"
@@ -1279,6 +1275,10 @@ config X86_MCE_INJECT
 	  If you don't know what a machine check is and you don't do kernel
 	  QA it is safe to say n.
 
+config X86_MCE_THRESHOLD
+	depends on X86_MCE_AMD || X86_MCE_INTEL
+	def_bool y
+
 config X86_THERMAL_VECTOR
 	def_bool y
 	depends on X86_MCE_INTEL
_
