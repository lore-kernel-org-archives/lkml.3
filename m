Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3HADnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:43:33 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:40845 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3HADna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:43:30 -0400
MIME-Version: 1.0
In-Reply-To: <5948193.cosVqkRF9h@vostro.rjw.lan>
References: <be0fa53fe03550ec49b8bade1af7d4e1f6e06b39.1375284946.git.viresh.kumar@linaro.org>
	<5948193.cosVqkRF9h@vostro.rjw.lan>
Date: Thu, 1 Aug 2013 09:13:29 +0530
Message-ID: <CAKohponmbzNUqyXkuCXcPvLrUps_88-8RzLbDKe_+QahouumFw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Re-arrange header files
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a11c257823efb2204e2daa5ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c257823efb2204e2daa5ba
Content-Type: text/plain; charset=ISO-8859-1

On 1 August 2013 03:08, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Normally, I'd regard that as pointless churn, but why don't you actually
> remove direct #includes already included through cpufreq.h when you're at it?
>
> For example, what's the point of including cpumask.h directly from
> cpufreq_governor.c if it includes cpufreq.h too?
>
> Also it doesn't look like all of the includes are really necessary.

Okay, all cleaned up now.. (attached for applying):

--------------x-----------------x------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Wed, 31 Jul 2013 20:47:01 +0530
Subject: [PATCH V2] cpufreq: Cleanup header files included in core

This patch intends to cleanup following issues in the header files included in
cpufreq core layers:
- Include headers in ascending order, so that we don't add same multiple times
  by mistake.
- <asm/> must be included after <linux/>, so that they override whatever they
  need.
- Remove unnecessary header files
- Don't include files already included by cpufreq.h or cpufreq_governor.h

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Changes since V2
- Remove unnecessary header files.

 drivers/cpufreq/cpufreq.c              | 20 ++++++--------------
 drivers/cpufreq/cpufreq_conservative.c | 12 ------------
 drivers/cpufreq/cpufreq_governor.c     |  6 ------
 drivers/cpufreq/cpufreq_governor.h     |  5 ++---
 drivers/cpufreq/cpufreq_ondemand.c     | 12 +-----------
 drivers/cpufreq/cpufreq_performance.c  |  3 +--
 drivers/cpufreq/cpufreq_powersave.c    |  3 +--
 drivers/cpufreq/cpufreq_stats.c        |  9 +--------
 drivers/cpufreq/freq_table.c           |  4 +---
 include/linux/cpufreq.h                | 11 +++--------
 10 files changed, 16 insertions(+), 69 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 170d344..473f2ad 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -17,24 +17,16 @@

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

-#include <asm/cputime.h>
-#include <linux/kernel.h>
-#include <linux/kernel_stat.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/notifier.h>
+#include <linux/cpu.h>
 #include <linux/cpufreq.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/tick.h>
 #include <linux/device.h>
-#include <linux/slab.h>
-#include <linux/cpu.h>
-#include <linux/completion.h>
+#include <linux/init.h>
+#include <linux/kernel_stat.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/syscore_ops.h>
-
+#include <linux/tick.h>
 #include <trace/events/power.h>

 /**
diff --git a/drivers/cpufreq/cpufreq_conservative.c
b/drivers/cpufreq/cpufreq_conservative.c
index 0ceb2ef..841e256 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -11,19 +11,7 @@
  * published by the Free Software Foundation.
  */

-#include <linux/cpufreq.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/kernel_stat.h>
-#include <linux/kobject.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/notifier.h>
-#include <linux/percpu-defs.h>
 #include <linux/slab.h>
-#include <linux/sysfs.h>
-#include <linux/types.h>
-
 #include "cpufreq_governor.h"

 /* Conservative governor macros */
diff --git a/drivers/cpufreq/cpufreq_governor.c
b/drivers/cpufreq/cpufreq_governor.c
index 7409dbd..556064e 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -16,15 +16,9 @@

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

-#include <asm/cputime.h>
-#include <linux/cpufreq.h>
-#include <linux/cpumask.h>
 #include <linux/export.h>
 #include <linux/kernel_stat.h>
-#include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/types.h>
-#include <linux/workqueue.h>

 #include "cpufreq_governor.h"

diff --git a/drivers/cpufreq/cpufreq_governor.h
b/drivers/cpufreq/cpufreq_governor.h
index 0e0dd4c..cf0b7a4 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -18,10 +18,9 @@
 #define _CPUFREQ_GOVERNOR_H

 #include <linux/cpufreq.h>
-#include <linux/kobject.h>
+#include <linux/kernel_stat.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/workqueue.h>
-#include <linux/sysfs.h>

 /*
  * The polling frequency depends on the capability of the processor. Default
diff --git a/drivers/cpufreq/cpufreq_ondemand.c
b/drivers/cpufreq/cpufreq_ondemand.c
index a3c5574..27c732e 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -12,20 +12,10 @@

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

-#include <linux/cpufreq.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/kernel_stat.h>
-#include <linux/kobject.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
+#include <linux/cpu.h>
 #include <linux/percpu-defs.h>
 #include <linux/slab.h>
-#include <linux/sysfs.h>
 #include <linux/tick.h>
-#include <linux/types.h>
-#include <linux/cpu.h>
-
 #include "cpufreq_governor.h"

 /* On-demand governor macros */
diff --git a/drivers/cpufreq/cpufreq_performance.c
b/drivers/cpufreq/cpufreq_performance.c
index 9fef7d6..cf117de 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -12,10 +12,9 @@

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
+#include <linux/module.h>

 static int cpufreq_governor_performance(struct cpufreq_policy *policy,
 					unsigned int event)
diff --git a/drivers/cpufreq/cpufreq_powersave.c
b/drivers/cpufreq/cpufreq_powersave.c
index 32109a1..e3b874c 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -12,10 +12,9 @@

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
+#include <linux/module.h>

 static int cpufreq_governor_powersave(struct cpufreq_policy *policy,
 					unsigned int event)
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index cb38413..a7143b0 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -9,17 +9,10 @@
  * published by the Free Software Foundation.
  */

-#include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/cpu.h>
-#include <linux/sysfs.h>
 #include <linux/cpufreq.h>
 #include <linux/module.h>
-#include <linux/jiffies.h>
-#include <linux/percpu.h>
-#include <linux/kobject.h>
-#include <linux/spinlock.h>
-#include <linux/notifier.h>
+#include <linux/slab.h>
 #include <asm/cputime.h>

 static spinlock_t cpufreq_stats_lock;
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index f0d8741..f111454a 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -11,10 +11,8 @@

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
 #include <linux/cpufreq.h>
+#include <linux/module.h>

 /*********************************************************************
  *                     FREQUENCY TABLE HELPERS                       *
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index e1fd215..97627bb 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -11,16 +11,11 @@
 #ifndef _LINUX_CPUFREQ_H
 #define _LINUX_CPUFREQ_H

-#include <asm/cputime.h>
-#include <linux/mutex.h>
-#include <linux/notifier.h>
-#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/completion.h>
 #include <linux/kobject.h>
+#include <linux/notifier.h>
 #include <linux/sysfs.h>
-#include <linux/completion.h>
-#include <linux/workqueue.h>
-#include <linux/cpumask.h>
-#include <asm/div64.h>

 #define CPUFREQ_NAME_LEN 16
 /* Print length for names. Extra 1 space for accomodating '\n' in prints */

--001a11c257823efb2204e2daa5ba
Content-Type: application/octet-stream; 
	name="0001-cpufreq-Cleanup-header-files-included-in-core.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-Cleanup-header-files-included-in-core.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjtf4vlz0

RnJvbSBlYTZkMzExMzEyZjFiOGNmYzZlZmZiNGRkYjkzZjQyMGMxMDQ2YjIwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZWE2ZDMxMTMxMmYxYjhjZmM2ZWZmYjRkZGI5M2Y0
MjBjMTA0NmIyMC4xMzc1MzI4NDY5LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogV2VkLCAzMSBKdWwg
MjAxMyAyMDo0NzowMSArMDUzMApTdWJqZWN0OiBbUEFUQ0ggVjJdIGNwdWZyZXE6IENsZWFudXAg
aGVhZGVyIGZpbGVzIGluY2x1ZGVkIGluIGNvcmUKClRoaXMgcGF0Y2ggaW50ZW5kcyB0byBjbGVh
bnVwIGZvbGxvd2luZyBpc3N1ZXMgaW4gdGhlIGhlYWRlciBmaWxlcyBpbmNsdWRlZCBpbgpjcHVm
cmVxIGNvcmUgbGF5ZXJzOgotIEluY2x1ZGUgaGVhZGVycyBpbiBhc2NlbmRpbmcgb3JkZXIsIHNv
IHRoYXQgd2UgZG9uJ3QgYWRkIHNhbWUgbXVsdGlwbGUgdGltZXMKICBieSBtaXN0YWtlLgotIDxh
c20vPiBtdXN0IGJlIGluY2x1ZGVkIGFmdGVyIDxsaW51eC8+LCBzbyB0aGF0IHRoZXkgb3ZlcnJp
ZGUgd2hhdGV2ZXIgdGhleQogIG5lZWQuCi0gUmVtb3ZlIHVubmVjZXNzYXJ5IGhlYWRlciBmaWxl
cwotIERvbid0IGluY2x1ZGUgZmlsZXMgYWxyZWFkeSBpbmNsdWRlZCBieSBjcHVmcmVxLmggb3Ig
Y3B1ZnJlcV9nb3Zlcm5vci5oCgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5r
dW1hckBsaW5hcm8ub3JnPgotLS0KQ2hhbmdlcyBzaW5jZSBWMgotIFJlbW92ZSB1bm5lY2Vzc2Fy
eSBoZWFkZXIgZmlsZXMuCgogZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYyAgICAgICAgICAgICAg
fCAyMCArKysrKystLS0tLS0tLS0tLS0tLQogZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfY29uc2Vy
dmF0aXZlLmMgfCAxMiAtLS0tLS0tLS0tLS0KIGRyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX2dvdmVy
bm9yLmMgICAgIHwgIDYgLS0tLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5o
ICAgICB8ICA1ICsrLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9vbmRlbWFuZC5jICAgICB8
IDEyICstLS0tLS0tLS0tLQogZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfcGVyZm9ybWFuY2UuYyAg
fCAgMyArLS0KIGRyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX3Bvd2Vyc2F2ZS5jICAgIHwgIDMgKy0t
CiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9zdGF0cy5jICAgICAgICB8ICA5ICstLS0tLS0tLQog
ZHJpdmVycy9jcHVmcmVxL2ZyZXFfdGFibGUuYyAgICAgICAgICAgfCAgNCArLS0tCiBpbmNsdWRl
L2xpbnV4L2NwdWZyZXEuaCAgICAgICAgICAgICAgICB8IDExICsrKy0tLS0tLS0tCiAxMCBmaWxl
cyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCA2OSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwpp
bmRleCAxNzBkMzQ0Li40NzNmMmFkIDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJl
cS5jCisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKQEAgLTE3LDI0ICsxNywxNiBAQAog
CiAjZGVmaW5lIHByX2ZtdChmbXQpIEtCVUlMRF9NT0ROQU1FICI6ICIgZm10CiAKLSNpbmNsdWRl
IDxhc20vY3B1dGltZS5oPgotI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgotI2luY2x1ZGUgPGxp
bnV4L2tlcm5lbF9zdGF0Lmg+Ci0jaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+Ci0jaW5jbHVkZSA8
bGludXgvaW5pdC5oPgotI2luY2x1ZGUgPGxpbnV4L25vdGlmaWVyLmg+CisjaW5jbHVkZSA8bGlu
dXgvY3B1Lmg+CiAjaW5jbHVkZSA8bGludXgvY3B1ZnJlcS5oPgotI2luY2x1ZGUgPGxpbnV4L2Rl
bGF5Lmg+Ci0jaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+Ci0jaW5jbHVkZSA8bGludXgvc3Bp
bmxvY2suaD4KLSNpbmNsdWRlIDxsaW51eC90aWNrLmg+CiAjaW5jbHVkZSA8bGludXgvZGV2aWNl
Lmg+Ci0jaW5jbHVkZSA8bGludXgvc2xhYi5oPgotI2luY2x1ZGUgPGxpbnV4L2NwdS5oPgotI2lu
Y2x1ZGUgPGxpbnV4L2NvbXBsZXRpb24uaD4KKyNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CisjaW5j
bHVkZSA8bGludXgva2VybmVsX3N0YXQuaD4KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KICNp
bmNsdWRlIDxsaW51eC9tdXRleC5oPgorI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KICNpbmNsdWRl
IDxsaW51eC9zeXNjb3JlX29wcy5oPgotCisjaW5jbHVkZSA8bGludXgvdGljay5oPgogI2luY2x1
ZGUgPHRyYWNlL2V2ZW50cy9wb3dlci5oPgogCiAvKioKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1
ZnJlcS9jcHVmcmVxX2NvbnNlcnZhdGl2ZS5jIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfY29u
c2VydmF0aXZlLmMKaW5kZXggMGNlYjJlZi4uODQxZTI1NiAxMDA2NDQKLS0tIGEvZHJpdmVycy9j
cHVmcmVxL2NwdWZyZXFfY29uc2VydmF0aXZlLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZy
ZXFfY29uc2VydmF0aXZlLmMKQEAgLTExLDE5ICsxMSw3IEBACiAgKiBwdWJsaXNoZWQgYnkgdGhl
IEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbi4KICAqLwogCi0jaW5jbHVkZSA8bGludXgvY3B1ZnJl
cS5oPgotI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KLSNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4K
LSNpbmNsdWRlIDxsaW51eC9rZXJuZWxfc3RhdC5oPgotI2luY2x1ZGUgPGxpbnV4L2tvYmplY3Qu
aD4KLSNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KLSNpbmNsdWRlIDxsaW51eC9tdXRleC5oPgot
I2luY2x1ZGUgPGxpbnV4L25vdGlmaWVyLmg+Ci0jaW5jbHVkZSA8bGludXgvcGVyY3B1LWRlZnMu
aD4KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+Ci0jaW5jbHVkZSA8bGludXgvc3lzZnMuaD4KLSNp
bmNsdWRlIDxsaW51eC90eXBlcy5oPgotCiAjaW5jbHVkZSAiY3B1ZnJlcV9nb3Zlcm5vci5oIgog
CiAvKiBDb25zZXJ2YXRpdmUgZ292ZXJub3IgbWFjcm9zICovCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5jIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfZ292
ZXJub3IuYwppbmRleCA3NDA5ZGJkLi41NTYwNjRlIDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZy
ZXEvY3B1ZnJlcV9nb3Zlcm5vci5jCisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX2dvdmVy
bm9yLmMKQEAgLTE2LDE1ICsxNiw5IEBACiAKICNkZWZpbmUgcHJfZm10KGZtdCkgS0JVSUxEX01P
RE5BTUUgIjogIiBmbXQKIAotI2luY2x1ZGUgPGFzbS9jcHV0aW1lLmg+Ci0jaW5jbHVkZSA8bGlu
dXgvY3B1ZnJlcS5oPgotI2luY2x1ZGUgPGxpbnV4L2NwdW1hc2suaD4KICNpbmNsdWRlIDxsaW51
eC9leHBvcnQuaD4KICNpbmNsdWRlIDxsaW51eC9rZXJuZWxfc3RhdC5oPgotI2luY2x1ZGUgPGxp
bnV4L211dGV4Lmg+CiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgotI2luY2x1ZGUgPGxpbnV4L3R5
cGVzLmg+Ci0jaW5jbHVkZSA8bGludXgvd29ya3F1ZXVlLmg+CiAKICNpbmNsdWRlICJjcHVmcmVx
X2dvdmVybm9yLmgiCiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX2dvdmVy
bm9yLmggYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5oCmluZGV4IDBlMGRkNGMu
LmNmMGI3YTQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX2dvdmVybm9yLmgK
KysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfZ292ZXJub3IuaApAQCAtMTgsMTAgKzE4LDkg
QEAKICNkZWZpbmUgX0NQVUZSRVFfR09WRVJOT1JfSAogCiAjaW5jbHVkZSA8bGludXgvY3B1ZnJl
cS5oPgotI2luY2x1ZGUgPGxpbnV4L2tvYmplY3QuaD4KKyNpbmNsdWRlIDxsaW51eC9rZXJuZWxf
c3RhdC5oPgorI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgogI2luY2x1ZGUgPGxpbnV4L211dGV4
Lmg+Ci0jaW5jbHVkZSA8bGludXgvd29ya3F1ZXVlLmg+Ci0jaW5jbHVkZSA8bGludXgvc3lzZnMu
aD4KIAogLyoKICAqIFRoZSBwb2xsaW5nIGZyZXF1ZW5jeSBkZXBlbmRzIG9uIHRoZSBjYXBhYmls
aXR5IG9mIHRoZSBwcm9jZXNzb3IuIERlZmF1bHQKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJl
cS9jcHVmcmVxX29uZGVtYW5kLmMgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9vbmRlbWFuZC5j
CmluZGV4IGEzYzU1NzQuLjI3YzczMmUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVm
cmVxX29uZGVtYW5kLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfb25kZW1hbmQuYwpA
QCAtMTIsMjAgKzEyLDEwIEBACiAKICNkZWZpbmUgcHJfZm10KGZtdCkgS0JVSUxEX01PRE5BTUUg
IjogIiBmbXQKIAotI2luY2x1ZGUgPGxpbnV4L2NwdWZyZXEuaD4KLSNpbmNsdWRlIDxsaW51eC9p
bml0Lmg+Ci0jaW5jbHVkZSA8bGludXgva2VybmVsLmg+Ci0jaW5jbHVkZSA8bGludXgva2VybmVs
X3N0YXQuaD4KLSNpbmNsdWRlIDxsaW51eC9rb2JqZWN0Lmg+Ci0jaW5jbHVkZSA8bGludXgvbW9k
dWxlLmg+Ci0jaW5jbHVkZSA8bGludXgvbXV0ZXguaD4KKyNpbmNsdWRlIDxsaW51eC9jcHUuaD4K
ICNpbmNsdWRlIDxsaW51eC9wZXJjcHUtZGVmcy5oPgogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4K
LSNpbmNsdWRlIDxsaW51eC9zeXNmcy5oPgogI2luY2x1ZGUgPGxpbnV4L3RpY2suaD4KLSNpbmNs
dWRlIDxsaW51eC90eXBlcy5oPgotI2luY2x1ZGUgPGxpbnV4L2NwdS5oPgotCiAjaW5jbHVkZSAi
Y3B1ZnJlcV9nb3Zlcm5vci5oIgogCiAvKiBPbi1kZW1hbmQgZ292ZXJub3IgbWFjcm9zICovCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9wZXJmb3JtYW5jZS5jIGIvZHJpdmVy
cy9jcHVmcmVxL2NwdWZyZXFfcGVyZm9ybWFuY2UuYwppbmRleCA5ZmVmN2Q2Li5jZjExN2RlIDEw
MDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9wZXJmb3JtYW5jZS5jCisrKyBiL2Ry
aXZlcnMvY3B1ZnJlcS9jcHVmcmVxX3BlcmZvcm1hbmNlLmMKQEAgLTEyLDEwICsxMiw5IEBACiAK
ICNkZWZpbmUgcHJfZm10KGZtdCkgS0JVSUxEX01PRE5BTUUgIjogIiBmbXQKIAotI2luY2x1ZGUg
PGxpbnV4L2tlcm5lbC5oPgotI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgogI2luY2x1ZGUgPGxp
bnV4L2NwdWZyZXEuaD4KICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CisjaW5jbHVkZSA8bGludXgv
bW9kdWxlLmg+CiAKIHN0YXRpYyBpbnQgY3B1ZnJlcV9nb3Zlcm5vcl9wZXJmb3JtYW5jZShzdHJ1
Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJCQkJdW5zaWduZWQgaW50IGV2ZW50KQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfcG93ZXJzYXZlLmMgYi9kcml2ZXJzL2Nw
dWZyZXEvY3B1ZnJlcV9wb3dlcnNhdmUuYwppbmRleCAzMjEwOWExLi5lM2I4NzRjIDEwMDY0NAot
LS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9wb3dlcnNhdmUuYworKysgYi9kcml2ZXJzL2Nw
dWZyZXEvY3B1ZnJlcV9wb3dlcnNhdmUuYwpAQCAtMTIsMTAgKzEyLDkgQEAKIAogI2RlZmluZSBw
cl9mbXQoZm10KSBLQlVJTERfTU9ETkFNRSAiOiAiIGZtdAogCi0jaW5jbHVkZSA8bGludXgva2Vy
bmVsLmg+Ci0jaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CiAjaW5jbHVkZSA8bGludXgvY3B1ZnJl
cS5oPgogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4K
IAogc3RhdGljIGludCBjcHVmcmVxX2dvdmVybm9yX3Bvd2Vyc2F2ZShzdHJ1Y3QgY3B1ZnJlcV9w
b2xpY3kgKnBvbGljeSwKIAkJCQkJdW5zaWduZWQgaW50IGV2ZW50KQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9jcHVmcmVxL2NwdWZyZXFfc3RhdHMuYyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX3N0
YXRzLmMKaW5kZXggY2IzODQxMy4uYTcxNDNiMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVx
L2NwdWZyZXFfc3RhdHMuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9zdGF0cy5jCkBA
IC05LDE3ICs5LDEwIEBACiAgKiBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRh
dGlvbi4KICAqLwogCi0jaW5jbHVkZSA8bGludXgva2VybmVsLmg+Ci0jaW5jbHVkZSA8bGludXgv
c2xhYi5oPgogI2luY2x1ZGUgPGxpbnV4L2NwdS5oPgotI2luY2x1ZGUgPGxpbnV4L3N5c2ZzLmg+
CiAjaW5jbHVkZSA8bGludXgvY3B1ZnJlcS5oPgogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgot
I2luY2x1ZGUgPGxpbnV4L2ppZmZpZXMuaD4KLSNpbmNsdWRlIDxsaW51eC9wZXJjcHUuaD4KLSNp
bmNsdWRlIDxsaW51eC9rb2JqZWN0Lmg+Ci0jaW5jbHVkZSA8bGludXgvc3BpbmxvY2suaD4KLSNp
bmNsdWRlIDxsaW51eC9ub3RpZmllci5oPgorI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KICNpbmNs
dWRlIDxhc20vY3B1dGltZS5oPgogCiBzdGF0aWMgc3BpbmxvY2tfdCBjcHVmcmVxX3N0YXRzX2xv
Y2s7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvZnJlcV90YWJsZS5jIGIvZHJpdmVycy9j
cHVmcmVxL2ZyZXFfdGFibGUuYwppbmRleCBmMGQ4NzQxLi5mMTExNDU0YSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9jcHVmcmVxL2ZyZXFfdGFibGUuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvZnJlcV90
YWJsZS5jCkBAIC0xMSwxMCArMTEsOCBAQAogCiAjZGVmaW5lIHByX2ZtdChmbXQpIEtCVUlMRF9N
T0ROQU1FICI6ICIgZm10CiAKLSNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KLSNpbmNsdWRlIDxs
aW51eC9tb2R1bGUuaD4KLSNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CiAjaW5jbHVkZSA8bGludXgv
Y3B1ZnJlcS5oPgorI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgogCiAvKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAg
KiAgICAgICAgICAgICAgICAgICAgIEZSRVFVRU5DWSBUQUJMRSBIRUxQRVJTICAgICAgICAgICAg
ICAgICAgICAgICAqCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2NwdWZyZXEuaCBiL2luY2x1
ZGUvbGludXgvY3B1ZnJlcS5oCmluZGV4IGUxZmQyMTUuLjk3NjI3YmIgMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvbGludXgvY3B1ZnJlcS5oCisrKyBiL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5oCkBAIC0x
MSwxNiArMTEsMTEgQEAKICNpZm5kZWYgX0xJTlVYX0NQVUZSRVFfSAogI2RlZmluZSBfTElOVVhf
Q1BVRlJFUV9ICiAKLSNpbmNsdWRlIDxhc20vY3B1dGltZS5oPgotI2luY2x1ZGUgPGxpbnV4L211
dGV4Lmg+Ci0jaW5jbHVkZSA8bGludXgvbm90aWZpZXIuaD4KLSNpbmNsdWRlIDxsaW51eC90aHJl
YWRzLmg+CisjaW5jbHVkZSA8bGludXgvY3B1bWFzay5oPgorI2luY2x1ZGUgPGxpbnV4L2NvbXBs
ZXRpb24uaD4KICNpbmNsdWRlIDxsaW51eC9rb2JqZWN0Lmg+CisjaW5jbHVkZSA8bGludXgvbm90
aWZpZXIuaD4KICNpbmNsdWRlIDxsaW51eC9zeXNmcy5oPgotI2luY2x1ZGUgPGxpbnV4L2NvbXBs
ZXRpb24uaD4KLSNpbmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4KLSNpbmNsdWRlIDxsaW51eC9j
cHVtYXNrLmg+Ci0jaW5jbHVkZSA8YXNtL2RpdjY0Lmg+CiAKICNkZWZpbmUgQ1BVRlJFUV9OQU1F
X0xFTiAxNgogLyogUHJpbnQgbGVuZ3RoIGZvciBuYW1lcy4gRXh0cmEgMSBzcGFjZSBmb3IgYWNj
b21vZGF0aW5nICdcbicgaW4gcHJpbnRzICovCi0tIAoxLjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--001a11c257823efb2204e2daa5ba--
