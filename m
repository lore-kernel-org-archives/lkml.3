Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaEOV0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:26:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaEOV0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:26:02 -0400
Message-ID: <1400189158.11178.157.camel@smoke>
Subject: [RFC 1/1] vmlinux.lds.h: Add new SECTION() macro
From: Geoff Levand <geoff@infradead.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 14:25:58 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new preprocessor macro SECTION() to vmlinux.lds.h that defines a
linker script output section with the section attributes commonly used,
and replace all occurrences of equivalent descriptions in vmlinux.lds.h
with the new macro.

Based on linker script fixes in the commit log, creating or maintaining
linker script output section descriptions seems to be error prone, often
not having the correct section attributes.  This new macro should help
to reduce these errors.

Signed-off-by: Geoff Levand <geoff@infradead.org>
---
Hi,

I thought I'd send this out to see if this is of interest.  If so, I can
go through and apply the SECTION() macro to all the linker scripts in the
kernel.  I think there are just under 100 possible replacements.

The name OUTPUT_SECTION() could also be used.  It is a little more
descriptive.

Comments welcome.

-Geoff

 include/asm-generic/vmlinux.lds.h | 66 ++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 146e4ff..f9e3dce 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -64,6 +64,8 @@
 #define STRUCT_ALIGNMENT 32
 #define STRUCT_ALIGN() . = ALIGN(STRUCT_ALIGNMENT)
 
+#define SECTION(_x) _x : AT(ADDR(_x) - LOAD_OFFSET)
+
 /* The actual configuration determine if the init/exit sections
  * are handled as text/data or they can be discarded (which
  * often happens at runtime)
@@ -248,7 +250,7 @@
  */
 #define RO_DATA_SECTION(align)						\
 	. = ALIGN((align));						\
-	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
+	SECTION(.rodata) {						\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
@@ -259,14 +261,14 @@
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
 	}								\
 									\
-	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
+	SECTION(.rodata1) {						\
 		*(.rodata1)						\
 	}								\
 									\
 	BUG_TABLE							\
 									\
 	/* PCI quirks */						\
-	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
+	SECTION(.pci_fixup) {						\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
 		*(.pci_fixup_early)					\
 		VMLINUX_SYMBOL(__end_pci_fixups_early) = .;		\
@@ -291,7 +293,7 @@
 	}								\
 									\
 	/* Built-in firmware blobs */					\
-	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
+	SECTION(.builtin_fw) {						\
 		VMLINUX_SYMBOL(__start_builtin_fw) = .;			\
 		*(.builtin_fw)						\
 		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
@@ -300,96 +302,96 @@
 	TRACEDATA							\
 									\
 	/* Kernel symbol table: Normal symbols */			\
-	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
+	SECTION(__ksymtab) {						\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
 		*(SORT(___ksymtab+*))					\
 		VMLINUX_SYMBOL(__stop___ksymtab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
-	__ksymtab_gpl     : AT(ADDR(__ksymtab_gpl) - LOAD_OFFSET) {	\
+	SECTION(__ksymtab_gpl) {					\
 		VMLINUX_SYMBOL(__start___ksymtab_gpl) = .;		\
 		*(SORT(___ksymtab_gpl+*))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
-	__ksymtab_unused  : AT(ADDR(__ksymtab_unused) - LOAD_OFFSET) {	\
+	SECTION(__ksymtab_unused) {					\
 		VMLINUX_SYMBOL(__start___ksymtab_unused) = .;		\
 		*(SORT(___ksymtab_unused+*))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
-	__ksymtab_unused_gpl : AT(ADDR(__ksymtab_unused_gpl) - LOAD_OFFSET) { \
+	SECTION(__ksymtab_unused_gpl) {					\
 		VMLINUX_SYMBOL(__start___ksymtab_unused_gpl) = .;	\
 		*(SORT(___ksymtab_unused_gpl+*))			\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
-	__ksymtab_gpl_future : AT(ADDR(__ksymtab_gpl_future) - LOAD_OFFSET) { \
+	SECTION(__ksymtab_gpl_future) {					\
 		VMLINUX_SYMBOL(__start___ksymtab_gpl_future) = .;	\
 		*(SORT(___ksymtab_gpl_future+*))			\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: Normal symbols */			\
-	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {		\
+	SECTION(__kcrctab) {						\
 		VMLINUX_SYMBOL(__start___kcrctab) = .;			\
 		*(SORT(___kcrctab+*))					\
 		VMLINUX_SYMBOL(__stop___kcrctab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
-	__kcrctab_gpl     : AT(ADDR(__kcrctab_gpl) - LOAD_OFFSET) {	\
+	SECTION(__kcrctab_gpl) {					\
 		VMLINUX_SYMBOL(__start___kcrctab_gpl) = .;		\
 		*(SORT(___kcrctab_gpl+*))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
-	__kcrctab_unused  : AT(ADDR(__kcrctab_unused) - LOAD_OFFSET) {	\
+	SECTION(__kcrctab_unused) {					\
 		VMLINUX_SYMBOL(__start___kcrctab_unused) = .;		\
 		*(SORT(___kcrctab_unused+*))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
-	__kcrctab_unused_gpl : AT(ADDR(__kcrctab_unused_gpl) - LOAD_OFFSET) { \
+	SECTION(__kcrctab_unused_gpl) { 				\
 		VMLINUX_SYMBOL(__start___kcrctab_unused_gpl) = .;	\
 		*(SORT(___kcrctab_unused_gpl+*))			\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
-	__kcrctab_gpl_future : AT(ADDR(__kcrctab_gpl_future) - LOAD_OFFSET) { \
+	SECTION(__kcrctab_gpl_future) { 				\
 		VMLINUX_SYMBOL(__start___kcrctab_gpl_future) = .;	\
 		*(SORT(___kcrctab_gpl_future+*))			\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: strings */				\
-        __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
+       SECTION( __ksymtab_strings) {					\
 		*(__ksymtab_strings)					\
 	}								\
 									\
 	/* __*init sections */						\
-	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
+	SECTION(__init_rodata) {					\
 		*(.ref.rodata)						\
 		MEM_KEEP(init.rodata)					\
 		MEM_KEEP(exit.rodata)					\
 	}								\
 									\
 	/* Built-in module parameters. */				\
-	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
+	SECTION(__param) {						\
 		VMLINUX_SYMBOL(__start___param) = .;			\
 		*(__param)						\
 		VMLINUX_SYMBOL(__stop___param) = .;			\
 	}								\
 									\
 	/* Built-in module versions. */					\
-	__modver : AT(ADDR(__modver) - LOAD_OFFSET) {			\
+	SECTION(__modver) {						\
 		VMLINUX_SYMBOL(__start___modver) = .;			\
 		*(__modver)						\
 		VMLINUX_SYMBOL(__stop___modver) = .;			\
@@ -404,7 +406,7 @@
 #define RO_DATA(align)  RO_DATA_SECTION(align)
 
 #define SECURITY_INIT							\
-	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
+	SECTION(.security_initcall.init) { 				\
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
 		*(.security_initcall.init) 				\
 		VMLINUX_SYMBOL(__security_initcall_end) = .;		\
@@ -463,8 +465,8 @@
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  *(.head.text)
 
-#define HEAD_TEXT_SECTION							\
-	.head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {		\
+#define HEAD_TEXT_SECTION						\
+	SECTION(.head.text) {						\
 		HEAD_TEXT						\
 	}
 
@@ -473,7 +475,7 @@
  */
 #define EXCEPTION_TABLE(align)						\
 	. = ALIGN(align);						\
-	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {		\
+	SECTION(__ex_table) {						\
 		VMLINUX_SYMBOL(__start___ex_table) = .;			\
 		*(__ex_table)						\
 		VMLINUX_SYMBOL(__stop___ex_table) = .;			\
@@ -484,7 +486,7 @@
  */
 #define INIT_TASK_DATA_SECTION(align)					\
 	. = ALIGN(align);						\
-	.data..init_task :  AT(ADDR(.data..init_task) - LOAD_OFFSET) {	\
+	SECTION(.data..init_task) {					\
 		INIT_TASK_DATA(align)					\
 	}
 
@@ -537,7 +539,7 @@
  */
 #define SBSS(sbss_align)						\
 	. = ALIGN(sbss_align);						\
-	.sbss : AT(ADDR(.sbss) - LOAD_OFFSET) {				\
+	SECTION(.sbss) {						\
 		*(.sbss)						\
 		*(.scommon)						\
 	}
@@ -552,7 +554,7 @@
 
 #define BSS(bss_align)							\
 	. = ALIGN(bss_align);						\
-	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {				\
+	SECTION(.bss) {							\
 		BSS_FIRST_SECTIONS					\
 		*(.bss..page_aligned)					\
 		*(.dynbss)						\
@@ -603,7 +605,7 @@
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
 	. = ALIGN(8);							\
-	__bug_table : AT(ADDR(__bug_table) - LOAD_OFFSET) {		\
+	SECTION(__bug_table) {						\
 		VMLINUX_SYMBOL(__start___bug_table) = .;		\
 		*(__bug_table)						\
 		VMLINUX_SYMBOL(__stop___bug_table) = .;			\
@@ -615,7 +617,7 @@
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
 	. = ALIGN(4);							\
-	.tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {		\
+	SECTION(.tracedata) {						\
 		VMLINUX_SYMBOL(__tracedata_start) = .;			\
 		*(.tracedata)						\
 		VMLINUX_SYMBOL(__tracedata_end) = .;			\
@@ -625,7 +627,7 @@
 #endif
 
 #define NOTES								\
-	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
+	SECTION(.notes) {						\
 		VMLINUX_SYMBOL(__start_notes) = .;			\
 		*(.note.*)						\
 		VMLINUX_SYMBOL(__stop_notes) = .;			\
@@ -763,7 +765,7 @@
  */
 #define PERCPU_SECTION(cacheline)					\
 	. = ALIGN(PAGE_SIZE);						\
-	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
+	SECTION(.data..percpu) {					\
 		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
 		PERCPU_INPUT(cacheline)					\
 	}
@@ -789,7 +791,7 @@
  * use 0 as page_align if page_aligned data is not used */
 #define RW_DATA_SECTION(cacheline, pagealigned, inittask)		\
 	. = ALIGN(PAGE_SIZE);						\
-	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
+	SECTION(.data) {						\
 		INIT_TASK_DATA(inittask)				\
 		NOSAVE_DATA						\
 		PAGE_ALIGNED_DATA(pagealigned)				\
@@ -801,14 +803,14 @@
 
 #define INIT_TEXT_SECTION(inittext_align)				\
 	. = ALIGN(inittext_align);					\
-	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {		\
+	SECTION(.init.text) {						\
 		VMLINUX_SYMBOL(_sinittext) = .;				\
 		INIT_TEXT						\
 		VMLINUX_SYMBOL(_einittext) = .;				\
 	}
 
 #define INIT_DATA_SECTION(initsetup_align)				\
-	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {		\
+	SECTION(.init.data) {						\
 		INIT_DATA						\
 		INIT_SETUP(initsetup_align)				\
 		INIT_CALLS						\
-- 
1.9.1



