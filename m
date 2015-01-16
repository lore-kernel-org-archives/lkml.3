Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbbAPWfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:35:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:46692 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbAPWfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:35:54 -0500
Message-ID: <54B99244.8080404@infradead.org>
Date: Fri, 16 Jan 2015 14:35:48 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, fengguang.wu@intel.com,
        Steven Miao <realmz6@gmail.com>
CC: adi-buildroot-devel@lists.sourceforge.net,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] Documentation: fix blackfin gptimers-example build errors
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Don't build the blackfin gptimers-example module when BFIN_GPTIMERS
is not enabled. Allow the build when BFIN_GPTIMERS is =y or =m.

I believe that this patch fixes these build errors, but I don't
have a build environment to test this.

ERROR: "disable_gptimers" [Documentation/blackfin/gptimers-example.ko] undefined!
ERROR: "enable_gptimers" [Documentation/blackfin/gptimers-example.ko] undefined!
ERROR: "set_gptimer_config" [Documentation/blackfin/gptimers-example.ko] undefined!
ERROR: "clear_gptimer_intr" [Documentation/blackfin/gptimers-example.ko] undefined!
ERROR: "get_gptimer_period" [Documentation/blackfin/gptimers-example.ko] undefined!
ERROR: "get_gptimer_pwidth" [Documentation/blackfin/gptimers-example.ko] undefined!
ERROR: "get_gptimer_intr" [Documentation/blackfin/gptimers-example.ko] undefined!

Reported-by: Fenggaung Wu <fengguang.wu@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/blackfin/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-319-rc4.orig/Documentation/blackfin/Makefile
+++ lnx-319-rc4/Documentation/blackfin/Makefile
@@ -1,3 +1,5 @@
 ifneq ($(CONFIG_BLACKFIN),)
+ifneq ($(CONFIG_BFIN_GPTIMERS,)
 obj-m := gptimers-example.o
 endif
+endif
