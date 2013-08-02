Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3HBEIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:08:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:54820 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3HBEIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:08:16 -0400
X-Spam-Score: -100.8
Message-ID: <51FB3072.4070406@asianux.com>
Date: Fri, 02 Aug 2013 12:07:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] h8300: Makefile: remove the hard code CROSS_COMPILE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current Linux can set CROSS_CMPILE from command line or config file, so
need remove the hard code CROSS_COMPILE from Makefile, or can not work
with cross-compiler with additional prefix (e.g. "h8300-gchen-elf-").


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/Makefile b/arch/h8300/Makefile
index a556447..f333385 100644
--- a/arch/h8300/Makefile
+++ b/arch/h8300/Makefile
@@ -38,7 +38,6 @@ KBUILD_CFLAGS += -DUTS_SYSNAME=\"uClinux\"
 KBUILD_AFLAGS += -DPLATFORM=$(PLATFORM) -DMODEL=$(MODEL) $(cflags-y)
 LDFLAGS += $(ldflags-y)
 
-CROSS_COMPILE = h8300-elf-
 LIBGCC := $(shell $(CROSS-COMPILE)$(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
 head-y := arch/$(ARCH)/platform/$(PLATFORM)/$(BOARD)/crt0_$(MODEL).o
-- 
1.7.7.6
