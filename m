Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3AROd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:33:59 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42630 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3AROd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:33:58 -0500
MIME-Version: 1.0
From: Sunil Beta Baskar <betasam@gmail.com>
Date: Fri, 18 Jan 2013 20:03:42 +0530
Message-ID: <CAK2BWApu9PjkmDdV4HoFXcq9KTh4e57iEdwYn9muVmYRwRNXgw@mail.gmail.com>
Subject: [PATCH] fix: build aborts if SPACE characters are found in path.
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sunil Beta <betasam@gmail.com>
---
 Makefile |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 07bc925..48bfd8e 100644
--- a/Makefile
+++ b/Makefile
@@ -10,6 +10,8 @@ NAME = "Divemaster Edition"
 # Comments in this file are targeted only to the developer, do not
 # expect to learn how to build the kernel reading this file.

+CURDIRSPC := $(echo $(CURDIR) | sed "s/ /\\\ /g" )
+$(ifneq $(CURDIR),$(CURDIRSPC), $(error directory $(CURDIR) contains spaces.))
 # Do not:
 # o  use make's built-in rules and variables
 #    (this increases performance and avoids hard-to-debug behaviour);
@@ -118,6 +120,8 @@ ifneq ($(KBUILD_OUTPUT),)
 # check that the output directory actually exists
 saved-output := $(KBUILD_OUTPUT)
 KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
+KBUILD_OUTPUT_SPC := $(shell echo $(KBUILD_OUTPUT) | sed "s/ /\\\ /g")
+$(ifneq $(KBUILD_OUTPUT),$(KBUILD_OUTPUT_SPC), $(error output
directory $(KBUILD_OUTPUT) contains spaces.))
 $(if $(KBUILD_OUTPUT),, \
      $(error output directory "$(saved-output)" does not exist))

--
1.7.10.4
-----
This resolves issues with multiple spaces in the source or target path
of the kernel. Fixing this completely would require changes to
mkmakefile among several other files. This is just to leave newbies
comfortable with an error message as to the reason the build failed.

Sunil Beta Baskar
