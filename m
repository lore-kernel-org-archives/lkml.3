Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaEERgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:36:51 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:13496 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbaEERgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:36:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEJAOLKZ1NbsEtU/2dsb2JhbABZgwarUQcBAgUBmgyBFxd0gmYcIxiBAiQTiEUBzAuFVoh8hEYBA48aihkBknSDNjs
Date: Mon, 5 May 2014 19:36:47 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/compat.c: use sizeof() instead of sizeof
Message-Id: <20140505193647.f593a799e94e87263d18202d@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 4 checkpatch warnings
WARNING: sizeof *tv should be sizeof(*tv)

Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/compat.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index e40b043..633394f 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -157,7 +157,7 @@ static int __compat_put_timespec(const struct timespec *ts, struct compat_timesp
 int compat_get_timeval(struct timeval *tv, const void __user *utv)
 {
 	if (COMPAT_USE_64BIT_TIME)
-		return copy_from_user(tv, utv, sizeof *tv) ? -EFAULT : 0;
+		return copy_from_user(tv, utv, sizeof(*tv)) ? -EFAULT : 0;
 	else
 		return __compat_get_timeval(tv, utv);
 }
@@ -166,7 +166,7 @@ EXPORT_SYMBOL_GPL(compat_get_timeval);
 int compat_put_timeval(const struct timeval *tv, void __user *utv)
 {
 	if (COMPAT_USE_64BIT_TIME)
-		return copy_to_user(utv, tv, sizeof *tv) ? -EFAULT : 0;
+		return copy_to_user(utv, tv, sizeof(*tv)) ? -EFAULT : 0;
 	else
 		return __compat_put_timeval(tv, utv);
 }
@@ -175,7 +175,7 @@ EXPORT_SYMBOL_GPL(compat_put_timeval);
 int compat_get_timespec(struct timespec *ts, const void __user *uts)
 {
 	if (COMPAT_USE_64BIT_TIME)
-		return copy_from_user(ts, uts, sizeof *ts) ? -EFAULT : 0;
+		return copy_from_user(ts, uts, sizeof(*ts)) ? -EFAULT : 0;
 	else
 		return __compat_get_timespec(ts, uts);
 }
@@ -184,7 +184,7 @@ EXPORT_SYMBOL_GPL(compat_get_timespec);
 int compat_put_timespec(const struct timespec *ts, void __user *uts)
 {
 	if (COMPAT_USE_64BIT_TIME)
-		return copy_to_user(uts, ts, sizeof *ts) ? -EFAULT : 0;
+		return copy_to_user(uts, ts, sizeof(*ts)) ? -EFAULT : 0;
 	else
 		return __compat_put_timespec(ts, uts);
 }
-- 
1.9.1
