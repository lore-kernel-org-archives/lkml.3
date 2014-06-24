Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaFXWu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:50:59 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:48479 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaFXWu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:50:27 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz,
        namhyung@kernel.org
Subject: [PATCH 12/13] perf kbuild: final cosmetic changes
Date: Wed, 25 Jun 2014 00:47:59 +0200
Message-Id: <1403650080-3130-13-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403650080-3130-1-git-send-email-alexis.berlemont@gmail.com>
References: <1403650080-3130-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR4175wXt-Pov8Yu-ke7KG4FRaBCTYouCs=jK3n0CWi3zw@mail.gmail.com>
References: <CAMesUR4175wXt-Pov8Yu-ke7KG4FRaBCTYouCs=jK3n0CWi3zw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Correctly rename internal makefile variables
* Remove makefiles in tools/perf/config which became empty and useless
* Remove builtin-cmds.h
---
 tools/perf/Makefile.kbuild            |  1 -
 tools/perf/arch/x86/Makefile          |  2 +-
 tools/perf/builtin-cmds.h             |  6 -----
 tools/perf/builtin-help.c             |  2 +-
 tools/perf/builtin-lock.c             |  2 +-
 tools/perf/builtin-sched.c            |  2 +-
 tools/perf/config/Makefile            | 46 +++++++++++++++++------------------
 tools/perf/config/Makefile.fix-config |  6 -----
 tools/perf/config/Makefile.fix-legacy |  2 --
 tools/perf/perf.c                     |  2 +-
 10 files changed, 28 insertions(+), 43 deletions(-)
 delete mode 100644 tools/perf/builtin-cmds.h
 delete mode 100644 tools/perf/config/Makefile.fix-config
 delete mode 100644 tools/perf/config/Makefile.fix-legacy

diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
index 7b7641c..127c090 100644
--- a/tools/perf/Makefile.kbuild
+++ b/tools/perf/Makefile.kbuild
@@ -155,7 +155,6 @@ $(CONFIG_DETECTED): $(KCONFIG_CONFIG)
 # no need to include auto.conf.cmd, because .config
 # is the only dependency here
 $(KCONFIG_AUTOCONFIG): $(KCONFIG_CONFIG) $(CONFIG_DETECTED)
-	$(Q)$(MAKE) -f $(src-perf)/config/Makefile.fix-config
 	$(Q)mkdir -p $(obj-perf)/include/config
 	$(Q)mkdir -p $(obj-perf)/include/generated
 	$(Q)$(MAKE) -s $(build)=scripts/kconfig silentoldconfig
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index d37e641..f95187e 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -1,4 +1,4 @@
-ifeq ($(LIBDWARF), 1)
+ifeq ($(config-libdwarf), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/builtin-cmds.h b/tools/perf/builtin-cmds.h
deleted file mode 100644
index 863727f..0000000
--- a/tools/perf/builtin-cmds.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef BUILTIN_CMDS_H
-#define BUILTIN_CMDS_H
-
-#include "generated/autoconf.h"
-
-#endif /* BUILTIN_CMDS_H */
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index b6c78a6..29bce52 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -3,11 +3,11 @@
  *
  * Builtin help command
  */
+#include "generated/autoconf.h"
 #include "perf.h"
 #include "util/cache.h"
 #include "builtin.h"
 #include "util/exec_cmd.h"
-#include "builtin-cmds.h"
 #include "common-cmds.h"
 #include "util/parse-options.h"
 #include "util/run-command.h"
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index f5404dc..faba219 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1,5 +1,5 @@
+#include "generated/autoconf.h"
 #include "builtin.h"
-#include "builtin-cmds.h"
 #include "perf.h"
 
 #include "util/evlist.h"
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 80515e0..9a74b7ab3 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1,5 +1,5 @@
+#include "generated/autoconf.h"
 #include "builtin.h"
-#include "builtin-cmds.h"
 #include "perf.h"
 
 #include "util/util.h"
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 0f8fa99..8c0439d 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -41,10 +41,14 @@ ifeq ($(ARCH),arm64)
   LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
 endif
 
+ifdef KCONFIG_CONFIG
+include $(KCONFIG_CONFIG)
+endif
+
 ifeq ($(LIBUNWIND_LIBS),)
   $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBUNWIND)
 else
-  LIBUNWIND = 1
+  config-libunwind = 1
   #
   # For linking with debug library, run like:
   #
@@ -76,10 +80,6 @@ ifdef CONFIG_LIBELF
   FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
 endif
 
-ifdef KCONFIG_CONFIG
-include $(src-perf)/config/Makefile.fix-legacy
-endif
-
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
 
@@ -279,12 +279,12 @@ endif
 ifdef CONFIG_LIBELF
   ifeq ($(feature-libelf), 0)
     ifeq ($(feature-glibc), 1)
-      LIBC_SUPPORT := 1
+      config-libc := 1
     endif
     ifeq ($(BIONIC),1)
-      LIBC_SUPPORT := 1
+      config-libc := 1
     endif
-    ifeq ($(LIBC_SUPPORT),1)
+    ifeq ($(config-libc),1)
       msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
       $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBELF)
       $(shell $(KCONFIG_SCRIPT) -E CONFIG_LIBELF_MINIMAL)
@@ -296,13 +296,13 @@ ifdef CONFIG_LIBELF
       endif
     endif
   else
-    LIBELF = 1
+    config-libelf = 1
     ifdef CONFIG_LIBDWARF
       ifneq ($(feature-dwarf), 1)
         msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
         $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF)
       else
-        LIBDWARF = 1
+        config-libdwarf = 1
       endif # Dwarf support
       ifdef CONFIG_LIBDWARF_UNWIND
         # So far there's only x86 and arm libdw unwind support merged
@@ -314,7 +314,7 @@ ifdef CONFIG_LIBELF
             msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set CONFIG_LIBDWARF_DIR);
             $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF_UNWIND)
           else
-            LIBDWARF_UNWIND = 1
+            config-libdwarf-unwind = 1
           endif # Dwarf unwind support
         else
           $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF_UNWIND)
@@ -324,7 +324,7 @@ ifdef CONFIG_LIBELF
   endif # libelf support
 endif # CONFIG_LIBELF
 
-ifeq ($(LIBELF), 1)
+ifeq ($(config-libelf), 1)
 
   ifdef CONFIG_LIBELF_MMAP
     ifneq ($(feature-libelf-mmap), 1)
@@ -332,16 +332,16 @@ ifeq ($(LIBELF), 1)
     endif
   endif
 
-  ifdef CONFIG_LIBELF_MMAP
+  ifdef CONFIG_LIBELF_GETPHDRNUM
     ifneq ($(feature-libelf-getphdrnum), 1)
-      $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBELF_MMAP)
+      $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBELF_GETPHDRNUM)
     endif
   endif
 
   # include ARCH specific config
   -include $(src-perf)/arch/$(ARCH)/Makefile
 
-  ifeq ($(LIBDWARF), 1)
+  ifeq ($(config-libdwarf), 1)
     ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
       msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
       $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF)
@@ -357,17 +357,17 @@ ifdef CONFIG_UNWIND
   # CONFIG_LIBUNWIND is the default choice; so, if it is not
   # available, let's try another one
   ifdef CONFIG_LIBUNWIND
-    ifeq ($(LIBUNWIND), 1)
+    ifeq ($(config-libunwind), 1)
       ifneq ($(feature-libunwind), 1)
-        LIBUNWIND = 0
+        config-libunwind = 0
         $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBUNWIND)
-        ifeq ($(LIBDWARF_UNWIND), 1)
+        ifeq ($(config-libdwarf-unwind), 1)
           msg := $(warning No libunwind found, post unwind will rely on libdwarf-unwind. Please install libunwind-dev[el] >= 1.1);
           $(shell $(KCONFIG_SCRIPT) -e CONFIG_LIBDWARF_UNWIND)
         else
           msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
           $(shell $(KCONFIG_SCRIPT) -d CONFIG_UNWIND)
-        endif # LIBDWARF_UNWIND
+        endif # config-libdwarf-unwind
       else # feature-libunwind OK
         EXTLIBS += $(LIBUNWIND_LIBS)
         CFLAGS += $(LIBUNWIND_CFLAGS)
@@ -379,7 +379,7 @@ ifdef CONFIG_UNWIND
   # CONFIG_LIBDWARF_UNWIND is not the default choice (so the user's
   # choice); so, we disable CONFIG_UNWIND if it is not available
   ifdef CONFIG_LIBDWARF_UNWIND
-    ifneq ($(LIBDWARF_UNWIND), 1)
+    ifneq ($(config-libdwarf-unwind), 1)
       msg := $(warning Disabling post unwing because (libdwarf-unwind is not available));
       $(shell $(KCONFIG_SCRIPT) -d CONFIG_UNWIND)
     endif
@@ -387,7 +387,7 @@ ifdef CONFIG_UNWIND
 
   # if libunwind is OK, let's check the option DEBUG_FRAME
   ifdef CONFIG_LIBUNWIND
-    ifeq ($(LIBUNWIND), 1)
+    ifeq ($(config-libunwind), 1)
       ifeq ($(ARCH),$(filter $(ARCH),arm arm64))
         $(call feature_check,libunwind-debug-frame)
         ifneq ($(feature-libunwind-debug-frame), 1)
@@ -404,11 +404,11 @@ ifdef CONFIG_UNWIND
 dwarf-post-unwind = 0
 dwarf-post-unwind-text = BUG
 
-ifeq ($(LIBUNWIND), 1)
+ifeq ($(config-libunwind), 1)
   dwarf-post-unwind := 1
   dwarf-post-unwind-text := libunwind
 else
-  ifeq ($(LIBDWARF_UNWIND), 1)
+  ifeq ($(config-libdwarf-unwind), 1)
     dwarf-post-unwind := 1
     dwarf-post-unwind-text := libdw
   endif
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
deleted file mode 100644
index 3f0e33e..0000000
--- a/tools/perf/config/Makefile.fix-config
+++ /dev/null
@@ -1,6 +0,0 @@
-include $(CONFIG_DETECTED)
-include $(KCONFIG_CONFIG)
-
-CONFIG := $(srctree)/scripts/config --file $(KCONFIG_CONFIG)
-
-all:
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
deleted file mode 100644
index 431c9bf..0000000
--- a/tools/perf/config/Makefile.fix-legacy
+++ /dev/null
@@ -1,2 +0,0 @@
-
-include $(KCONFIG_CONFIG)
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 56cd4a2..e97d6fc 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -6,8 +6,8 @@
  * This is the main hub from which the sub-commands (perf stat,
  * perf top, perf record, perf report, etc.) are started.
  */
+#include "generated/autoconf.h"
 #include "builtin.h"
-#include "builtin-cmds.h"
 
 #include "util/exec_cmd.h"
 #include "util/cache.h"
-- 
1.9.3

