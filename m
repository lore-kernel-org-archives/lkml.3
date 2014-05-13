Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaEMCpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 22:45:22 -0400
Received: from ns.horizon.com ([71.41.210.147]:15361 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751906AbaEMCpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 22:45:21 -0400
Date: 12 May 2014 22:45:19 -0400
Message-ID: <20140513024519.31594.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: john.stultz@linaro.org, linux@horizon.com
Subject: [PATCH 1/2] timekeeping: Use unsigned int for seqlock sequence
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com
In-Reply-To: <537109AB.8010609@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_seqlock_begin returns an int, so using "unsigned long" to
hold the return value is harmless, but a waste.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 kernel/time/timekeeping.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f7df8ea217..14e703e5bd 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -300,7 +300,7 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 int __getnstimeofday(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned int seq;
 	s64 nsecs = 0;
 
 	do {
@@ -399,7 +399,7 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
 void timekeeping_clocktai(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned int seq;
 	u64 nsecs;
 
 	WARN_ON(timekeeping_suspended);
@@ -447,7 +447,7 @@ EXPORT_SYMBOL(ktime_get_clocktai);
 void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 {
 	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned int seq;
 	s64 nsecs_raw, nsecs_real;
 
 	WARN_ON_ONCE(timekeeping_suspended);
@@ -700,7 +700,7 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
 void getrawmonotonic(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned int seq;
 	s64 nsecs;
 
 	do {
@@ -720,7 +720,7 @@ EXPORT_SYMBOL(getrawmonotonic);
 int timekeeping_valid_for_hres(void)
 {
 	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned int seq;
 	int ret;
 
 	do {
@@ -739,7 +739,7 @@ int timekeeping_valid_for_hres(void)
 u64 timekeeping_max_deferment(void)
 {
 	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned int seq;
 	u64 ret;
 
 	do {
@@ -1546,7 +1546,7 @@ struct timespec current_kernel_time(void)
 {
 	struct timekeeper *tk = &timekeeper;
 	struct timespec now;
-	unsigned long seq;
+	unsigned int seq;
 
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
@@ -1562,7 +1562,7 @@ struct timespec get_monotonic_coarse(void)
 {
 	struct timekeeper *tk = &timekeeper;
 	struct timespec now, mono;
-	unsigned long seq;
+	unsigned int seq;
 
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
@@ -1596,7 +1596,7 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 				struct timespec *wtom, struct timespec *sleep)
 {
 	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned int seq;
 
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
@@ -1647,7 +1647,7 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
 ktime_t ktime_get_monotonic_offset(void)
 {
 	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned int seq;
 	struct timespec wtom;
 
 	do {
-- 
1.9.2

