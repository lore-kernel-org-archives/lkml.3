Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaKGFaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:30:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaKGFa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:30:28 -0500
Date: Thu, 6 Nov 2014 21:30:09 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e92ce12ed6a46302f64269d2d406cf04525f0a8f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, jolsa@redhat.com,
        adrian.hunter@intel.com, tglx@linutronix.de, namhyung@kernel.org,
        paulus@samba.org, acme@redhat.com, eranian@google.com,
        namhyung.kim@lge.com, dsahern@gmail.com, hpa@zytor.com,
        a.p.zijlstra@chello.nl
Reply-To: linux-kernel@vger.kernel.org, mingo@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, adrian.hunter@intel.com, jolsa@redhat.com,
        paulus@samba.org, namhyung.kim@lge.com, hpa@zytor.com,
        dsahern@gmail.com, eranian@google.com, a.p.zijlstra@chello.nl,
        acme@redhat.com
In-Reply-To: <87h9yexshi.fsf@sejong.aot.lge.com>
References: <87h9yexshi.fsf@sejong.aot.lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add gzip decompression support for kernel module
Git-Commit-ID: e92ce12ed6a46302f64269d2d406cf04525f0a8f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e92ce12ed6a46302f64269d2d406cf04525f0a8f
Gitweb:     http://git.kernel.org/tip/e92ce12ed6a46302f64269d2d406cf04525f0a8f
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 31 Oct 2014 16:51:38 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Nov 2014 10:11:26 -0300

perf tools: Add gzip decompression support for kernel module

Now my Archlinux box shows module symbols correctly.

Before:
  $ perf report --stdio
  Failed to open /tmp/perf-3477.map, continuing without symbols
  no symbols found in /usr/bin/date, maybe install a debug package?
  No kallsyms or vmlinux with build-id 7b4ea0a49ae2111925857099aaf05c3246ff33e0 was found
  [drm] with build id 7b4ea0a49ae2111925857099aaf05c3246ff33e0 not found, continuing without symbols
  No kallsyms or vmlinux with build-id edd931629094b660ca9dec09a1b635c8d87aa2ee was found
  [jbd2] with build id edd931629094b660ca9dec09a1b635c8d87aa2ee not found, continuing without symbols
  No kallsyms or vmlinux with build-id a7b1eada671c34933e5610bb920b2ca4945a82c3 was found
  [ext4] with build id a7b1eada671c34933e5610bb920b2ca4945a82c3 not found, continuing without symbols
  No kallsyms or vmlinux with build-id d69511fa3e5840e770336ef45b06c83fef8d74e3 was found
  [scsi_mod] with build id d69511fa3e5840e770336ef45b06c83fef8d74e3 not found, continuing without symbols
  No kallsyms or vmlinux with build-id af0430af13461af058770ee9b87afc07922c2e77 was found
  [libata] with build id af0430af13461af058770ee9b87afc07922c2e77 not found, continuing without symbols
  No kallsyms or vmlinux with build-id aaeedff8160ce631a5f0333591c6ff291201d29f was found
  [libahci] with build id aaeedff8160ce631a5f0333591c6ff291201d29f not found, continuing without symbols
  No kallsyms or vmlinux with build-id c57907712becaf662dc4981824bb372c0441d605 was found
  [mac80211] with build id c57907712becaf662dc4981824bb372c0441d605 not found, continuing without symbols
  No kallsyms or vmlinux with build-id e0589077cc0ec8c3e4c40eb9f2d9e69d236bee8f was found
  [iwldvm] with build id e0589077cc0ec8c3e4c40eb9f2d9e69d236bee8f not found, continuing without symbols
  No kallsyms or vmlinux with build-id 2d86086bf136bf374a2f029cf85a48194f9b950b was found
  [cfg80211] with build id 2d86086bf136bf374a2f029cf85a48194f9b950b not found, continuing without symbols
  No kallsyms or vmlinux with build-id 4493c48599bdb3d91d0f8db5150e0be33fdd9221 was found
  [iwlwifi] with build id 4493c48599bdb3d91d0f8db5150e0be33fdd9221 not found, continuing without symbols
  ...
  #
  # Overhead  Command          Shared Object            Symbol
  # ........  ...............  .......................  ........................................................
  #
       0.03%  swapper          [ext4]                   [k] 0x000000000000fe2e
       0.03%  swapper          [kernel.kallsyms]        [k] account_entity_enqueue
       0.03%  swapper          [ext4]                   [k] 0x000000000000fc2b
       0.03%  irq/50-iwlwifi   [iwlwifi]                [k] 0x000000000000200b
       0.03%  swapper          [kernel.kallsyms]        [k] ktime_add_safe
       0.03%  swapper          [kernel.kallsyms]        [k] elv_completed_request
       0.03%  swapper          [libata]                 [k] 0x0000000000003997
       0.03%  swapper          [libahci]                [k] 0x0000000000001f25
       0.03%  swapper          [kernel.kallsyms]        [k] rb_next
       0.03%  swapper          [kernel.kallsyms]        [k] blk_finish_request
       0.03%  swapper          [ext4]                   [k] 0x0000000000010248
       0.00%  perf             [kernel.kallsyms]        [k] native_write_msr_safe

After:
  $ perf report --stdio
  Failed to open /tmp/perf-3477.map, continuing without symbols
  no symbols found in /usr/bin/tr, maybe install a debug package?
  ...
  #
  # Overhead  Command          Shared Object                Symbol
  # ........  ...............  ...........................  ......................................................
  #

       0.04%  kworker/u16:3    [ext4]                       [k] ext4_read_block_bitmap
       0.03%  kworker/u16:0    [mac80211]                   [k] ieee80211_sta_reset_beacon_monitor
       0.02%  irq/50-iwlwifi   [mac80211]                   [k] ieee80211_get_bssid
       0.02%  firefox          [e1000e]                     [k] __ew32_prepare
       0.02%  swapper          [libahci]                    [k] ahci_handle_port_interrupt
       0.02%  emacs            libglib-2.0.so.0.4000.0      [.] g_mutex_unlock
       0.02%  swapper          [e1000e]                     [k] e1000_clean_tx_irq
       0.02%  dwm              [kernel.kallsyms]            [k] __schedule
       0.02%  gnome-terminal-  [vdso]                       [.] __vdso_clock_gettime
       0.02%  swapper          [e1000e]                     [k] e1000_alloc_rx_buffers
       0.02%  irq/50-iwlwifi   [mac80211]                   [k] ieee80211_rx
       0.01%  firefox          [vdso]                       [.] __vdso_gettimeofday
       0.01%  irq/50-iwlwifi   [iwlwifi]                    [k] iwl_pcie_rxq_restock.part.13

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/87h9yexshi.fsf@sejong.aot.lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf                     |  7 +++
 tools/perf/config/Makefile                   | 15 +++++-
 tools/perf/config/feature-checks/Makefile    |  8 ++-
 tools/perf/config/feature-checks/test-all.c  |  5 ++
 tools/perf/config/feature-checks/test-zlib.c |  9 ++++
 tools/perf/util/dso.c                        | 12 ++---
 tools/perf/util/util.h                       |  5 ++
 tools/perf/util/zlib.c                       | 78 ++++++++++++++++++++++++++++
 8 files changed, 127 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 0ebcc4a..aecf61dc 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -66,6 +66,9 @@ include config/utilities.mak
 #
 # Define NO_PERF_READ_VDSOX32 if you do not want to build perf-read-vdsox32
 # for reading the x32 mode 32-bit compatibility VDSO in 64-bit mode
+#
+# Define NO_ZLIB if you do not want to support compressed kernel modules
+
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(shell pwd)))
@@ -584,6 +587,10 @@ ifndef NO_LIBNUMA
   BUILTIN_OBJS += $(OUTPUT)bench/numa.o
 endif
 
+ifndef NO_ZLIB
+  LIB_OBJS += $(OUTPUT)util/zlib.o
+endif
+
 ifdef ASCIIDOC8
   export ASCIIDOC8
 endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 71264e4..79f906c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -200,7 +200,8 @@ CORE_FEATURE_TESTS =			\
 	libunwind			\
 	stackprotector-all		\
 	timerfd				\
-	libdw-dwarf-unwind
+	libdw-dwarf-unwind		\
+	zlib
 
 LIB_FEATURE_TESTS =			\
 	dwarf				\
@@ -214,7 +215,8 @@ LIB_FEATURE_TESTS =			\
 	libpython			\
 	libslang			\
 	libunwind			\
-	libdw-dwarf-unwind
+	libdw-dwarf-unwind		\
+	zlib
 
 VF_FEATURE_TESTS =			\
 	backtrace			\
@@ -604,6 +606,15 @@ ifneq ($(filter -lbfd,$(EXTLIBS)),)
   CFLAGS += -DHAVE_LIBBFD_SUPPORT
 endif
 
+ifndef NO_ZLIB
+  ifeq ($(feature-zlib), 1)
+    CFLAGS += -DHAVE_ZLIB_SUPPORT
+    EXTLIBS += -lz
+  else
+    NO_ZLIB := 1
+  endif
+endif
+
 ifndef NO_BACKTRACE
   ifeq ($(feature-backtrace), 1)
     CFLAGS += -DHAVE_BACKTRACE_SUPPORT
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 7c68ec7..53f19b5 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -29,7 +29,8 @@ FILES=					\
 	test-timerfd.bin		\
 	test-libdw-dwarf-unwind.bin	\
 	test-compile-32.bin		\
-	test-compile-x32.bin
+	test-compile-x32.bin		\
+	test-zlib.bin
 
 CC := $(CROSS_COMPILE)gcc -MD
 PKG_CONFIG := $(CROSS_COMPILE)pkg-config
@@ -41,7 +42,7 @@ BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $(patsubst %.bin,%.c,$@) $(LDFLAGS)
 ###############################
 
 test-all.bin:
-	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl -lz
 
 test-hello.bin:
 	$(BUILD)
@@ -139,6 +140,9 @@ test-compile-32.bin:
 test-compile-x32.bin:
 	$(CC) -mx32 -o $(OUTPUT)$@ test-compile.c
 
+test-zlib.bin:
+	$(BUILD) -lz
+
 -include *.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index a7d022e..652e009 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -93,6 +93,10 @@
 # include "test-sync-compare-and-swap.c"
 #undef main
 
+#define main main_test_zlib
+# include "test-zlib.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -116,6 +120,7 @@ int main(int argc, char *argv[])
 	main_test_stackprotector_all();
 	main_test_libdw_dwarf_unwind();
 	main_test_sync_compare_and_swap(argc, argv);
+	main_test_zlib();
 
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-zlib.c b/tools/perf/config/feature-checks/test-zlib.c
new file mode 100644
index 0000000..e111fff
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-zlib.c
@@ -0,0 +1,9 @@
+#include <zlib.h>
+
+int main(void)
+{
+	z_stream zs;
+
+	inflateInit(&zs);
+	return 0;
+}
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 36a607c..45be944 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -141,18 +141,14 @@ int dso__read_binary_type_filename(const struct dso *dso,
 	return ret;
 }
 
-static int decompress_dummy(const char *input __maybe_unused,
-			    int output __maybe_unused)
-{
-	return -1;
-}
-
 static const struct {
 	const char *fmt;
 	int (*decompress)(const char *input, int output);
 } compressions[] = {
-	{ "gz", decompress_dummy },
-	{ NULL, },
+#ifdef HAVE_ZLIB_SUPPORT
+	{ "gz", gzip_decompress_to_file },
+#endif
+	{ NULL, NULL },
 };
 
 bool is_supported_compression(const char *ext)
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 80bfdaa..7dc44cf 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -351,4 +351,9 @@ void mem_bswap_32(void *src, int byte_size);
 
 const char *get_filename_for_perf_kvm(void);
 bool find_process(const char *name);
+
+#ifdef HAVE_ZLIB_SUPPORT
+int gzip_decompress_to_file(const char *input, int output_fd);
+#endif
+
 #endif /* GIT_COMPAT_UTIL_H */
diff --git a/tools/perf/util/zlib.c b/tools/perf/util/zlib.c
new file mode 100644
index 0000000..495a449
--- /dev/null
+++ b/tools/perf/util/zlib.c
@@ -0,0 +1,78 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <zlib.h>
+
+#include "util/util.h"
+#include "util/debug.h"
+
+
+#define CHUNK_SIZE  16384
+
+int gzip_decompress_to_file(const char *input, int output_fd)
+{
+	int ret = Z_STREAM_ERROR;
+	int input_fd;
+	void *ptr;
+	int len;
+	struct stat stbuf;
+	unsigned char buf[CHUNK_SIZE];
+	z_stream zs = {
+		.zalloc		= Z_NULL,
+		.zfree		= Z_NULL,
+		.opaque		= Z_NULL,
+		.avail_in	= 0,
+		.next_in	= Z_NULL,
+	};
+
+	input_fd = open(input, O_RDONLY);
+	if (input_fd < 0)
+		return -1;
+
+	if (fstat(input_fd, &stbuf) < 0)
+		goto out_close;
+
+	ptr = mmap(NULL, stbuf.st_size, PROT_READ, MAP_PRIVATE, input_fd, 0);
+	if (ptr == MAP_FAILED)
+		goto out_close;
+
+	if (inflateInit2(&zs, 16 + MAX_WBITS) != Z_OK)
+		goto out_unmap;
+
+	zs.next_in = ptr;
+	zs.avail_in = stbuf.st_size;
+
+	do {
+		zs.next_out = buf;
+		zs.avail_out = CHUNK_SIZE;
+
+		ret = inflate(&zs, Z_NO_FLUSH);
+		switch (ret) {
+		case Z_NEED_DICT:
+			ret = Z_DATA_ERROR;
+			/* fall through */
+		case Z_DATA_ERROR:
+		case Z_MEM_ERROR:
+			goto out;
+		default:
+			break;
+		}
+
+		len = CHUNK_SIZE - zs.avail_out;
+		if (writen(output_fd, buf, len) != len) {
+			ret = Z_DATA_ERROR;
+			goto out;
+		}
+
+	} while (ret != Z_STREAM_END);
+
+out:
+	inflateEnd(&zs);
+out_unmap:
+	munmap(ptr, stbuf.st_size);
+out_close:
+	close(input_fd);
+
+	return ret == Z_STREAM_END ? 0 : -1;
+}
