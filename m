Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbaCDVKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:10:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbaCDUDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3.13 083/172] export: declare ksymtab symbols
Date: Tue,  4 Mar 2014 12:02:47 -0800
Message-Id: <20140304200302.390996626@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 7b4ec8dd7d4ac467e9eee4d49f2c9574d773efbb upstream.

sparse complains about any __ksymtab symbols with the following:

 warning: symbol '__ksymtab_...' was not declared. Should it be static?

due to Andi's patch making it non-static.

Mollify sparse by declaring the symbol extern, otherwise we get
drowned in sparse warnings for anything that uses EXPORT_SYMBOL
in the sources, making it easy to miss real warnings.

Fixes: e0f244c63fc9 ("asmlinkage, module: Make ksymtab [...] __visible")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/export.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -59,6 +59,7 @@ extern struct module __this_module;
 	static const char __kstrtab_##sym[]			\
 	__attribute__((section("__ksymtab_strings"), aligned(1))) \
 	= VMLINUX_SYMBOL_STR(sym);				\
+	extern const struct kernel_symbol __ksymtab_##sym;	\
 	__visible const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
 	__attribute__((section("___ksymtab" sec "+" #sym), unused))	\


