Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3CZEZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 00:25:50 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33730 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab3CZEZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 00:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomnOaVG1xktDL=YGz6yM2vFoYVF2Un-9_zL7owiJVG6gw@mail.gmail.com>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
	<2641a3f059f1698ee6825c7b6bfe25a3937e1474.1364229828.git.viresh.kumar@linaro.org>
	<20130325.130745.670476511400589185.davem@davemloft.net>
	<CAKohpomnOaVG1xktDL=YGz6yM2vFoYVF2Un-9_zL7owiJVG6gw@mail.gmail.com>
Date: Tue, 26 Mar 2013 09:55:47 +0530
Message-ID: <CAKohponJJKDcFXK-Zs-eCS2=v3=-CrkEqF1FaHz64D-kq888BA@mail.gmail.com>
Subject: Re: [PATCH 8/9] spark: cpufreq: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        sparclinux@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8fb207a4cfaac304d8cc50ed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8fb207a4cfaac304d8cc50ed
Content-Type: text/plain; charset=ISO-8859-1

On 26 March 2013 07:30, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 25 March 2013 22:37, David Miller <davem@davemloft.net> wrote:
>> From: Viresh Kumar <viresh.kumar@linaro.org>
>> Date: Mon, 25 Mar 2013 22:24:44 +0530
>>
>>> This patch moves cpufreq driver of SPARK architecture to drivers/cpufreq.
>>
>> I don't know what spark is.
>
> :(
>
> s/spark/sparc ...
>
> I will fix patch in V2..

Mistake was done in code too and not only log :)

Here is re-spin of this patch (attached too in case you want to test):

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 25 Mar 2013 11:20:23 +0530
Subject: [PATCH] sparc: cpufreq:  move cpufreq driver to drivers/cpufreq

This patch moves cpufreq driver of SPARC architecture to drivers/cpufreq.

Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/sparc/Kconfig                                 | 23 ----------------------
 arch/sparc/kernel/Makefile                         |  3 ---
 drivers/cpufreq/Kconfig                            | 23 ++++++++++++++++++++++
 drivers/cpufreq/Makefile                           |  2 ++
 .../cpufreq/sparc-us2e-cpufreq.c                   |  0
 .../cpufreq/sparc-us3-cpufreq.c                    |  0
 6 files changed, 25 insertions(+), 26 deletions(-)
 rename arch/sparc/kernel/us2e_cpufreq.c =>
drivers/cpufreq/sparc-us2e-cpufreq.c (100%)
 rename arch/sparc/kernel/us3_cpufreq.c =>
drivers/cpufreq/sparc-us3-cpufreq.c (100%)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 289127d..52e7680 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -260,29 +260,6 @@ config HOTPLUG_CPU

 if SPARC64
 source "drivers/cpufreq/Kconfig"
-
-config US3_FREQ
-	tristate "UltraSPARC-III CPU Frequency driver"
-	depends on CPU_FREQ
-	select CPU_FREQ_TABLE
-	help
-	  This adds the CPUFreq driver for UltraSPARC-III processors.
-
-	  For details, take a look at <file:Documentation/cpu-freq>.
-
-	  If in doubt, say N.
-
-config US2E_FREQ
-	tristate "UltraSPARC-IIe CPU Frequency driver"
-	depends on CPU_FREQ
-	select CPU_FREQ_TABLE
-	help
-	  This adds the CPUFreq driver for UltraSPARC-IIe processors.
-
-	  For details, take a look at <file:Documentation/cpu-freq>.
-
-	  If in doubt, say N.
-
 endif

 config US3_MC
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index 6cf591b..5276fd4 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -102,9 +102,6 @@ obj-$(CONFIG_PCI_MSI)        += pci_msi.o

 obj-$(CONFIG_COMPAT)         += sys32.o sys_sparc32.o signal32.o

-# sparc64 cpufreq
-obj-$(CONFIG_US3_FREQ)  += us3_cpufreq.o
-obj-$(CONFIG_US2E_FREQ) += us2e_cpufreq.o
 obj-$(CONFIG_US3_MC)    += chmc.o

 obj-$(CONFIG_KPROBES)   += kprobes.o
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 602d5db..a1488f5 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -258,6 +258,29 @@ depends on PPC32 || PPC64
 source "drivers/cpufreq/Kconfig.powerpc"
 endmenu

+menu "SPARC CPU frequency scaling drivers"
+depends on SPARC64
+config SPARC_US3_CPUFREQ
+	tristate "UltraSPARC-III CPU Frequency driver"
+	select CPU_FREQ_TABLE
+	help
+	  This adds the CPUFreq driver for UltraSPARC-III processors.
+
+	  For details, take a look at <file:Documentation/cpu-freq>.
+
+	  If in doubt, say N.
+
+config SPARC_US2E_CPUFREQ
+	tristate "UltraSPARC-IIe CPU Frequency driver"
+	select CPU_FREQ_TABLE
+	help
+	  This adds the CPUFreq driver for UltraSPARC-IIe processors.
+
+	  For details, take a look at <file:Documentation/cpu-freq>.
+
+	  If in doubt, say N.
+endmenu
+
 menu "SH CPU Frequency scaling"
 depends on SUPERH
 config SH_CPU_FREQ
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index ab3a054..050bd0c 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -85,4 +85,6 @@ obj-$(CONFIG_ETRAXFS)			+= cris-etraxfs-cpufreq.o
 obj-$(CONFIG_IA64_ACPI_CPUFREQ)		+= ia64-acpi-cpufreq.o
 obj-$(CONFIG_LOONGSON2_CPUFREQ)		+= loongson2_cpufreq.o
 obj-$(CONFIG_SH_CPU_FREQ)		+= sh-cpufreq.o
+obj-$(CONFIG_SPARC_US2E_CPUFREQ)	+= sparc-us2e-cpufreq.o
+obj-$(CONFIG_SPARC_US3_CPUFREQ)		+= sparc-us3-cpufreq.o
 obj-$(CONFIG_UNICORE32)			+= unicore2-cpufreq.o
diff --git a/arch/sparc/kernel/us2e_cpufreq.c
b/drivers/cpufreq/sparc-us2e-cpufreq.c
similarity index 100%
rename from arch/sparc/kernel/us2e_cpufreq.c
rename to drivers/cpufreq/sparc-us2e-cpufreq.c
diff --git a/arch/sparc/kernel/us3_cpufreq.c
b/drivers/cpufreq/sparc-us3-cpufreq.c
similarity index 100%
rename from arch/sparc/kernel/us3_cpufreq.c
rename to drivers/cpufreq/sparc-us3-cpufreq.c

--e89a8fb207a4cfaac304d8cc50ed
Content-Type: application/octet-stream; 
	name="0001-sparc-cpufreq-move-cpufreq-driver-to-drivers-cpufreq.patch"
Content-Disposition: attachment; 
	filename="0001-sparc-cpufreq-move-cpufreq-driver-to-drivers-cpufreq.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_heqka1xa0

RnJvbSA2MTY0MWUyYmMwZGUwNjU5ZWZjZDdhZGQ2MzU4ZDcxYmFkZWRlODQwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NjE2NDFlMmJjMGRlMDY1OWVmY2Q3YWRkNjM1OGQ3
MWJhZGVkZTg0MC4xMzY0MjcxOTAwLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogTW9uLCAyNSBNYXIg
MjAxMyAxMToyMDoyMyArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIHNwYXJjOiBjcHVmcmVxOiAgbW92
ZSBjcHVmcmVxIGRyaXZlciB0byBkcml2ZXJzL2NwdWZyZXEKClRoaXMgcGF0Y2ggbW92ZXMgY3B1
ZnJlcSBkcml2ZXIgb2YgU1BBUkMgYXJjaGl0ZWN0dXJlIHRvIGRyaXZlcnMvY3B1ZnJlcS4KCkNj
OiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+CkNjOiBzcGFyY2xpbnV4QHZn
ZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBs
aW5hcm8ub3JnPgotLS0KIGFyY2gvc3BhcmMvS2NvbmZpZyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgMjMgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogYXJjaC9zcGFyYy9rZXJuZWwv
TWFrZWZpbGUgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMyAtLS0KIGRyaXZlcnMvY3B1ZnJl
cS9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMjMgKysrKysrKysrKysrKysr
KysrKysrKwogZHJpdmVycy9jcHVmcmVxL01ha2VmaWxlICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgMiArKwogLi4uL2NwdWZyZXEvc3BhcmMtdXMyZS1jcHVmcmVxLmMgICAgICAgICAgICAg
ICAgICAgfCAgMAogLi4uL2NwdWZyZXEvc3BhcmMtdXMzLWNwdWZyZXEuYyAgICAgICAgICAgICAg
ICAgICAgfCAgMAogNiBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAyNiBkZWxldGlv
bnMoLSkKIHJlbmFtZSBhcmNoL3NwYXJjL2tlcm5lbC91czJlX2NwdWZyZXEuYyA9PiBkcml2ZXJz
L2NwdWZyZXEvc3BhcmMtdXMyZS1jcHVmcmVxLmMgKDEwMCUpCiByZW5hbWUgYXJjaC9zcGFyYy9r
ZXJuZWwvdXMzX2NwdWZyZXEuYyA9PiBkcml2ZXJzL2NwdWZyZXEvc3BhcmMtdXMzLWNwdWZyZXEu
YyAoMTAwJSkKCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjL0tjb25maWcgYi9hcmNoL3NwYXJjL0tj
b25maWcKaW5kZXggMjg5MTI3ZC4uNTJlNzY4MCAxMDA2NDQKLS0tIGEvYXJjaC9zcGFyYy9LY29u
ZmlnCisrKyBiL2FyY2gvc3BhcmMvS2NvbmZpZwpAQCAtMjYwLDI5ICsyNjAsNiBAQCBjb25maWcg
SE9UUExVR19DUFUKIAogaWYgU1BBUkM2NAogc291cmNlICJkcml2ZXJzL2NwdWZyZXEvS2NvbmZp
ZyIKLQotY29uZmlnIFVTM19GUkVRCi0JdHJpc3RhdGUgIlVsdHJhU1BBUkMtSUlJIENQVSBGcmVx
dWVuY3kgZHJpdmVyIgotCWRlcGVuZHMgb24gQ1BVX0ZSRVEKLQlzZWxlY3QgQ1BVX0ZSRVFfVEFC
TEUKLQloZWxwCi0JICBUaGlzIGFkZHMgdGhlIENQVUZyZXEgZHJpdmVyIGZvciBVbHRyYVNQQVJD
LUlJSSBwcm9jZXNzb3JzLgotCi0JICBGb3IgZGV0YWlscywgdGFrZSBhIGxvb2sgYXQgPGZpbGU6
RG9jdW1lbnRhdGlvbi9jcHUtZnJlcT4uCi0KLQkgIElmIGluIGRvdWJ0LCBzYXkgTi4KLQotY29u
ZmlnIFVTMkVfRlJFUQotCXRyaXN0YXRlICJVbHRyYVNQQVJDLUlJZSBDUFUgRnJlcXVlbmN5IGRy
aXZlciIKLQlkZXBlbmRzIG9uIENQVV9GUkVRCi0Jc2VsZWN0IENQVV9GUkVRX1RBQkxFCi0JaGVs
cAotCSAgVGhpcyBhZGRzIHRoZSBDUFVGcmVxIGRyaXZlciBmb3IgVWx0cmFTUEFSQy1JSWUgcHJv
Y2Vzc29ycy4KLQotCSAgRm9yIGRldGFpbHMsIHRha2UgYSBsb29rIGF0IDxmaWxlOkRvY3VtZW50
YXRpb24vY3B1LWZyZXE+LgotCi0JICBJZiBpbiBkb3VidCwgc2F5IE4uCi0KIGVuZGlmCiAKIGNv
bmZpZyBVUzNfTUMKZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMva2VybmVsL01ha2VmaWxlIGIvYXJj
aC9zcGFyYy9rZXJuZWwvTWFrZWZpbGUKaW5kZXggNmNmNTkxYi4uNTI3NmZkNCAxMDA2NDQKLS0t
IGEvYXJjaC9zcGFyYy9rZXJuZWwvTWFrZWZpbGUKKysrIGIvYXJjaC9zcGFyYy9rZXJuZWwvTWFr
ZWZpbGUKQEAgLTEwMiw5ICsxMDIsNiBAQCBvYmotJChDT05GSUdfUENJX01TSSkgICAgICAgICs9
IHBjaV9tc2kubwogCiBvYmotJChDT05GSUdfQ09NUEFUKSAgICAgICAgICs9IHN5czMyLm8gc3lz
X3NwYXJjMzIubyBzaWduYWwzMi5vCiAKLSMgc3BhcmM2NCBjcHVmcmVxCi1vYmotJChDT05GSUdf
VVMzX0ZSRVEpICArPSB1czNfY3B1ZnJlcS5vCi1vYmotJChDT05GSUdfVVMyRV9GUkVRKSArPSB1
czJlX2NwdWZyZXEubwogb2JqLSQoQ09ORklHX1VTM19NQykgICAgKz0gY2htYy5vCiAKIG9iai0k
KENPTkZJR19LUFJPQkVTKSAgICs9IGtwcm9iZXMubwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVm
cmVxL0tjb25maWcgYi9kcml2ZXJzL2NwdWZyZXEvS2NvbmZpZwppbmRleCA2MDJkNWRiLi5hMTQ4
OGY1IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvS2NvbmZpZworKysgYi9kcml2ZXJzL2Nw
dWZyZXEvS2NvbmZpZwpAQCAtMjU4LDYgKzI1OCwyOSBAQCBkZXBlbmRzIG9uIFBQQzMyIHx8IFBQ
QzY0CiBzb3VyY2UgImRyaXZlcnMvY3B1ZnJlcS9LY29uZmlnLnBvd2VycGMiCiBlbmRtZW51CiAK
K21lbnUgIlNQQVJDIENQVSBmcmVxdWVuY3kgc2NhbGluZyBkcml2ZXJzIgorZGVwZW5kcyBvbiBT
UEFSQzY0Citjb25maWcgU1BBUkNfVVMzX0NQVUZSRVEKKwl0cmlzdGF0ZSAiVWx0cmFTUEFSQy1J
SUkgQ1BVIEZyZXF1ZW5jeSBkcml2ZXIiCisJc2VsZWN0IENQVV9GUkVRX1RBQkxFCisJaGVscAor
CSAgVGhpcyBhZGRzIHRoZSBDUFVGcmVxIGRyaXZlciBmb3IgVWx0cmFTUEFSQy1JSUkgcHJvY2Vz
c29ycy4KKworCSAgRm9yIGRldGFpbHMsIHRha2UgYSBsb29rIGF0IDxmaWxlOkRvY3VtZW50YXRp
b24vY3B1LWZyZXE+LgorCisJICBJZiBpbiBkb3VidCwgc2F5IE4uCisKK2NvbmZpZyBTUEFSQ19V
UzJFX0NQVUZSRVEKKwl0cmlzdGF0ZSAiVWx0cmFTUEFSQy1JSWUgQ1BVIEZyZXF1ZW5jeSBkcml2
ZXIiCisJc2VsZWN0IENQVV9GUkVRX1RBQkxFCisJaGVscAorCSAgVGhpcyBhZGRzIHRoZSBDUFVG
cmVxIGRyaXZlciBmb3IgVWx0cmFTUEFSQy1JSWUgcHJvY2Vzc29ycy4KKworCSAgRm9yIGRldGFp
bHMsIHRha2UgYSBsb29rIGF0IDxmaWxlOkRvY3VtZW50YXRpb24vY3B1LWZyZXE+LgorCisJICBJ
ZiBpbiBkb3VidCwgc2F5IE4uCitlbmRtZW51CisKIG1lbnUgIlNIIENQVSBGcmVxdWVuY3kgc2Nh
bGluZyIKIGRlcGVuZHMgb24gU1VQRVJICiBjb25maWcgU0hfQ1BVX0ZSRVEKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvY3B1ZnJlcS9NYWtlZmlsZSBiL2RyaXZlcnMvY3B1ZnJlcS9NYWtlZmlsZQppbmRl
eCBhYjNhMDU0Li4wNTBiZDBjIDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvTWFrZWZpbGUK
KysrIGIvZHJpdmVycy9jcHVmcmVxL01ha2VmaWxlCkBAIC04NSw0ICs4NSw2IEBAIG9iai0kKENP
TkZJR19FVFJBWEZTKQkJCSs9IGNyaXMtZXRyYXhmcy1jcHVmcmVxLm8KIG9iai0kKENPTkZJR19J
QTY0X0FDUElfQ1BVRlJFUSkJCSs9IGlhNjQtYWNwaS1jcHVmcmVxLm8KIG9iai0kKENPTkZJR19M
T09OR1NPTjJfQ1BVRlJFUSkJCSs9IGxvb25nc29uMl9jcHVmcmVxLm8KIG9iai0kKENPTkZJR19T
SF9DUFVfRlJFUSkJCSs9IHNoLWNwdWZyZXEubworb2JqLSQoQ09ORklHX1NQQVJDX1VTMkVfQ1BV
RlJFUSkJKz0gc3BhcmMtdXMyZS1jcHVmcmVxLm8KK29iai0kKENPTkZJR19TUEFSQ19VUzNfQ1BV
RlJFUSkJCSs9IHNwYXJjLXVzMy1jcHVmcmVxLm8KIG9iai0kKENPTkZJR19VTklDT1JFMzIpCQkJ
Kz0gdW5pY29yZTItY3B1ZnJlcS5vCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjL2tlcm5lbC91czJl
X2NwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9zcGFyYy11czJlLWNwdWZyZXEuYwpzaW1pbGFy
aXR5IGluZGV4IDEwMCUKcmVuYW1lIGZyb20gYXJjaC9zcGFyYy9rZXJuZWwvdXMyZV9jcHVmcmVx
LmMKcmVuYW1lIHRvIGRyaXZlcnMvY3B1ZnJlcS9zcGFyYy11czJlLWNwdWZyZXEuYwpkaWZmIC0t
Z2l0IGEvYXJjaC9zcGFyYy9rZXJuZWwvdXMzX2NwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9z
cGFyYy11czMtY3B1ZnJlcS5jCnNpbWlsYXJpdHkgaW5kZXggMTAwJQpyZW5hbWUgZnJvbSBhcmNo
L3NwYXJjL2tlcm5lbC91czNfY3B1ZnJlcS5jCnJlbmFtZSB0byBkcml2ZXJzL2NwdWZyZXEvc3Bh
cmMtdXMzLWNwdWZyZXEuYwotLSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--e89a8fb207a4cfaac304d8cc50ed--
