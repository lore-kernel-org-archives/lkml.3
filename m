Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaDQONU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:13:20 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34470 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaDQOMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:12:17 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH 3/4] Documentation: make functions static to avoid prototype warnings
Date: Thu, 17 Apr 2014 10:11:49 -0400
Message-Id: <1397743910-18391-3-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 Documentation/arm/SH-Mobile/vrl4.c                    |  6 +++---
 Documentation/laptops/hpfall.c                        | 16 ++++++++--------
 Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c | 11 ++++++-----
 Documentation/prctl/disable-tsc-on-off-stress-test.c  |  7 ++++---
 Documentation/prctl/disable-tsc-test.c                |  5 +++--
 5 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/Documentation/arm/SH-Mobile/vrl4.c b/Documentation/arm/SH-Mobile/vrl4.c
index e8a1913..4cbbba5 100644
--- a/Documentation/arm/SH-Mobile/vrl4.c
+++ b/Documentation/arm/SH-Mobile/vrl4.c
@@ -77,7 +77,7 @@ struct hdr {
 
 #define ROUND_UP(x)	((x + ALIGN - 1) & ~(ALIGN - 1))
 
-ssize_t do_read(int fd, void *buf, size_t count)
+static ssize_t do_read(int fd, void *buf, size_t count)
 {
 	size_t offset = 0;
 	ssize_t l;
@@ -98,7 +98,7 @@ ssize_t do_read(int fd, void *buf, size_t count)
 	return offset;
 }
 
-ssize_t do_write(int fd, const void *buf, size_t count)
+static ssize_t do_write(int fd, const void *buf, size_t count)
 {
 	size_t offset = 0;
 	ssize_t l;
@@ -117,7 +117,7 @@ ssize_t do_write(int fd, const void *buf, size_t count)
 	return offset;
 }
 
-ssize_t write_zero(int fd, size_t len)
+static ssize_t write_zero(int fd, size_t len)
 {
 	size_t i = len;
 
diff --git a/Documentation/laptops/hpfall.c b/Documentation/laptops/hpfall.c
index b85dbba..d4e1380 100644
--- a/Documentation/laptops/hpfall.c
+++ b/Documentation/laptops/hpfall.c
@@ -21,7 +21,7 @@
 
 char unload_heads_path[64];
 
-int set_unload_heads_path(char *device)
+static int set_unload_heads_path(char *device)
 {
 	char devname[64];
 
@@ -33,7 +33,7 @@ int set_unload_heads_path(char *device)
 				"/sys/block/%s/device/unload_heads", devname);
 	return 0;
 }
-int valid_disk(void)
+static int valid_disk(void)
 {
 	int fd = open(unload_heads_path, O_RDONLY);
 	if (fd < 0) {
@@ -45,7 +45,7 @@ int valid_disk(void)
 	return 1;
 }
 
-void write_int(char *path, int i)
+static void write_int(char *path, int i)
 {
 	char buf[1024];
 	int fd = open(path, O_RDWR);
@@ -61,27 +61,27 @@ void write_int(char *path, int i)
 	close(fd);
 }
 
-void set_led(int on)
+static void set_led(int on)
 {
 	write_int("/sys/class/leds/hp::hddprotect/brightness", on);
 }
 
-void protect(int seconds)
+static void protect(int seconds)
 {
 	write_int(unload_heads_path, seconds*1000);
 }
 
-int on_ac(void)
+static int on_ac(void)
 {
 //	/sys/class/power_supply/AC0/online
 }
 
-int lid_open(void)
+static int lid_open(void)
 {
 //	/proc/acpi/button/lid/LID/state
 }
 
-void ignore_me(void)
+static void ignore_me(void)
 {
 	protect(0);
 	set_led(0);
diff --git a/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c b/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c
index f8e8e95..81fdd42 100644
--- a/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c
+++ b/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c
@@ -27,19 +27,20 @@
 # define PR_TSC_SIGSEGV		2   /* throw a SIGSEGV instead of reading the TSC */
 #endif
 
-uint64_t rdtsc() {
+static uint64_t rdtsc(void)
+{
 uint32_t lo, hi;
 /* We cannot use "=A", since this would use %rax on x86_64 */
 __asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
 return (uint64_t)hi << 32 | lo;
 }
 
-void sigsegv_expect(int sig)
+static void sigsegv_expect(int sig)
 {
 	/* */
 }
 
-void segvtask(void)
+static void segvtask(void)
 {
 	if (prctl(PR_SET_TSC, PR_TSC_SIGSEGV) < 0)
 	{
@@ -54,13 +55,13 @@ void segvtask(void)
 }
 
 
-void sigsegv_fail(int sig)
+static void sigsegv_fail(int sig)
 {
 	fprintf(stderr, "FATAL ERROR, rdtsc() failed while enabled\n");
 	exit(0);
 }
 
-void rdtsctask(void)
+static void rdtsctask(void)
 {
 	if (prctl(PR_SET_TSC, PR_TSC_ENABLE) < 0)
 	{
diff --git a/Documentation/prctl/disable-tsc-on-off-stress-test.c b/Documentation/prctl/disable-tsc-on-off-stress-test.c
index 1fcd9144..4d83a27 100644
--- a/Documentation/prctl/disable-tsc-on-off-stress-test.c
+++ b/Documentation/prctl/disable-tsc-on-off-stress-test.c
@@ -29,7 +29,8 @@
 
 /* snippet from wikipedia :-) */
 
-uint64_t rdtsc() {
+static uint64_t rdtsc(void)
+{
 uint32_t lo, hi;
 /* We cannot use "=A", since this would use %rax on x86_64 */
 __asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
@@ -38,7 +39,7 @@ return (uint64_t)hi << 32 | lo;
 
 int should_segv = 0;
 
-void sigsegv_cb(int sig)
+static void sigsegv_cb(int sig)
 {
 	if (!should_segv)
 	{
@@ -55,7 +56,7 @@ void sigsegv_cb(int sig)
 	rdtsc();
 }
 
-void task(void)
+static void task(void)
 {
 	signal(SIGSEGV, sigsegv_cb);
 	alarm(10);
diff --git a/Documentation/prctl/disable-tsc-test.c b/Documentation/prctl/disable-tsc-test.c
index 843c81e..2541e65 100644
--- a/Documentation/prctl/disable-tsc-test.c
+++ b/Documentation/prctl/disable-tsc-test.c
@@ -29,14 +29,15 @@ const char *tsc_names[] =
 	[PR_TSC_SIGSEGV] = "PR_TSC_SIGSEGV",
 };
 
-uint64_t rdtsc() {
+static uint64_t rdtsc(void)
+{
 uint32_t lo, hi;
 /* We cannot use "=A", since this would use %rax on x86_64 */
 __asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
 return (uint64_t)hi << 32 | lo;
 }
 
-void sigsegv_cb(int sig)
+static void sigsegv_cb(int sig)
 {
 	int tsc_val = 0;
 
-- 
1.9.2

