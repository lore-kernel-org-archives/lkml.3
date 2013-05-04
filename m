Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3EDGjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 02:39:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47878 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3EDGjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 02:39:41 -0400
MIME-Version: 1.0
In-Reply-To: <1367507786-505303-3-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
	<1367507786-505303-3-git-send-email-arnd@arndb.de>
Date: Sat, 4 May 2013 12:09:40 +0530
Message-ID: <CAKohponuYRm+D-FU5_7Ny1PPmwUhFLm9DkAR9iHURur+GFq_kA@mail.gmail.com>
Subject: Re: [PATCH, RFC 02/22] cpufreq: ARM_DT_BL_CPUFREQ needs ARM_CPU_TOPOLOGY
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: multipart/mixed; boundary=089e012297626b60a904dbdebbbe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e012297626b60a904dbdebbbe
Content-Type: text/plain; charset=ISO-8859-1

On 2 May 2013 20:46, Arnd Bergmann <arnd@arndb.de> wrote:
> The big.LITTLE cpufreq driver uses the CPU topology API, which
> needs to be reflected in Kconfig to prevent broken configurations.
>
> warning: (ARM_DT_BL_CPUFREQ) selects ARM_BIG_LITTLE_CPUFREQ which
> has unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && ARM && ARM_CPU_TOPOLOGY)
>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/cpufreq/Kconfig.arm | 1 +
>  1 file changed, 1 insertion(+)

With all the discussions we had, please see if you can replace your
patch with this one (Attached too for applying, copy/paste in gmail
will break it):

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Sat, 4 May 2013 12:03:54 +0530
Subject: [PATCH] cpufreq: ARM big LITTLE: Fix Kconfig entries

This fixes usage of "depends on" and "select" options in Kconfig for ARM big
LITTLE cpufreq driver. Otherwise we get these warnings:

warning: (ARM_DT_BL_CPUFREQ) selects ARM_BIG_LITTLE_CPUFREQ which
has unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && ARM &&
ARM_CPU_TOPOLOGY)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig.arm | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 634e992..a924408 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -3,17 +3,17 @@
 #

 config ARM_BIG_LITTLE_CPUFREQ
-	tristate
-	depends on ARM_CPU_TOPOLOGY
-	select PM_OPP
+	tristate "Generic ARM big LITTLE CPUfreq driver"
+	depends on ARM_CPU_TOPOLOGY && PM_OPP && HAVE_CLK
+	help
+	  This enables the Generic CPUfreq driver for ARM big.LITTLE platforms.

 config ARM_DT_BL_CPUFREQ
-	tristate "Generic ARM big LITTLE CPUfreq driver probed via DT"
-	select ARM_BIG_LITTLE_CPUFREQ
-	depends on OF && HAVE_CLK
+	tristate "Generic probing via DT for ARM big LITTLE CPUfreq driver"
+	depends on ARM_BIG_LITTLE_CPUFREQ && OF
 	help
-	  This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
-	  This gets frequency tables from DT.
+	  This enables probing via DT for Generic CPUfreq driver for ARM
+	  big.LITTLE platform. This gets frequency tables from DT.

 config ARM_EXYNOS_CPUFREQ
 	bool "SAMSUNG EXYNOS SoCs"

--089e012297626b60a904dbdebbbe
Content-Type: application/octet-stream; 
	name="0001-cpufreq-ARM-big-LITTLE-Fix-Kconfig-entries.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-ARM-big-LITTLE-Fix-Kconfig-entries.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgaf8es90

RnJvbSBiMzFkNDBhZWYxOGRhOTFjNWY5MzNkYjZkNjhmOGIzMmIyMDAzM2EyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8YjMxZDQwYWVmMThkYTkxYzVmOTMzZGI2ZDY4Zjhi
MzJiMjAwMzNhMi4xMzY3NjQ5NDczLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogU2F0LCA0IE1heSAy
MDEzIDEyOjAzOjU0ICswNTMwClN1YmplY3Q6IFtQQVRDSF0gY3B1ZnJlcTogQVJNIGJpZyBMSVRU
TEU6IEZpeCBLY29uZmlnIGVudHJpZXMKClRoaXMgZml4ZXMgdXNhZ2Ugb2YgImRlcGVuZHMgb24i
IGFuZCAic2VsZWN0IiBvcHRpb25zIGluIEtjb25maWcgZm9yIEFSTSBiaWcKTElUVExFIGNwdWZy
ZXEgZHJpdmVyLiBPdGhlcndpc2Ugd2UgZ2V0IHRoZXNlIHdhcm5pbmdzOgoKd2FybmluZzogKEFS
TV9EVF9CTF9DUFVGUkVRKSBzZWxlY3RzIEFSTV9CSUdfTElUVExFX0NQVUZSRVEgd2hpY2gKaGFz
IHVubWV0IGRpcmVjdCBkZXBlbmRlbmNpZXMgKEFSQ0hfSEFTX0NQVUZSRVEgJiYgQ1BVX0ZSRVEg
JiYgQVJNICYmIEFSTV9DUFVfVE9QT0xPR1kpCgpTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5u
IDxhcm5kQGFybmRiLmRlPgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1h
ckBsaW5hcm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJlcS9LY29uZmlnLmFybSB8IDE2ICsrKysr
KysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVmcmVxL0tjb25maWcuYXJtIGIvZHJpdmVycy9j
cHVmcmVxL0tjb25maWcuYXJtCmluZGV4IDYzNGU5OTIuLmE5MjQ0MDggMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvY3B1ZnJlcS9LY29uZmlnLmFybQorKysgYi9kcml2ZXJzL2NwdWZyZXEvS2NvbmZpZy5h
cm0KQEAgLTMsMTcgKzMsMTcgQEAKICMKIAogY29uZmlnIEFSTV9CSUdfTElUVExFX0NQVUZSRVEK
LQl0cmlzdGF0ZQotCWRlcGVuZHMgb24gQVJNX0NQVV9UT1BPTE9HWQotCXNlbGVjdCBQTV9PUFAK
Kwl0cmlzdGF0ZSAiR2VuZXJpYyBBUk0gYmlnIExJVFRMRSBDUFVmcmVxIGRyaXZlciIKKwlkZXBl
bmRzIG9uIEFSTV9DUFVfVE9QT0xPR1kgJiYgUE1fT1BQICYmIEhBVkVfQ0xLCisJaGVscAorCSAg
VGhpcyBlbmFibGVzIHRoZSBHZW5lcmljIENQVWZyZXEgZHJpdmVyIGZvciBBUk0gYmlnLkxJVFRM
RSBwbGF0Zm9ybXMuCiAKIGNvbmZpZyBBUk1fRFRfQkxfQ1BVRlJFUQotCXRyaXN0YXRlICJHZW5l
cmljIEFSTSBiaWcgTElUVExFIENQVWZyZXEgZHJpdmVyIHByb2JlZCB2aWEgRFQiCi0Jc2VsZWN0
IEFSTV9CSUdfTElUVExFX0NQVUZSRVEKLQlkZXBlbmRzIG9uIE9GICYmIEhBVkVfQ0xLCisJdHJp
c3RhdGUgIkdlbmVyaWMgcHJvYmluZyB2aWEgRFQgZm9yIEFSTSBiaWcgTElUVExFIENQVWZyZXEg
ZHJpdmVyIgorCWRlcGVuZHMgb24gQVJNX0JJR19MSVRUTEVfQ1BVRlJFUSAmJiBPRgogCWhlbHAK
LQkgIFRoaXMgZW5hYmxlcyB0aGUgR2VuZXJpYyBDUFVmcmVxIGRyaXZlciBmb3IgQVJNIGJpZy5M
SVRUTEUgcGxhdGZvcm0uCi0JICBUaGlzIGdldHMgZnJlcXVlbmN5IHRhYmxlcyBmcm9tIERULgor
CSAgVGhpcyBlbmFibGVzIHByb2JpbmcgdmlhIERUIGZvciBHZW5lcmljIENQVWZyZXEgZHJpdmVy
IGZvciBBUk0KKwkgIGJpZy5MSVRUTEUgcGxhdGZvcm0uIFRoaXMgZ2V0cyBmcmVxdWVuY3kgdGFi
bGVzIGZyb20gRFQuCiAKIGNvbmZpZyBBUk1fRVhZTk9TX0NQVUZSRVEKIAlib29sICJTQU1TVU5H
IEVYWU5PUyBTb0NzIgotLSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--089e012297626b60a904dbdebbbe--
