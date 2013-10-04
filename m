Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab3JDFW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 01:22:58 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:38971 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3JDFW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 01:22:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMjE9s4KqHaAbkejZ-2GG4zv4Y1AxpgWzcMKovuMJFZ_-w@mail.gmail.com>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<e689bd437918e56ae50541a90a4b9c606bfb8bf4.1379063063.git.viresh.kumar@linaro.org>
	<CAOesGMjE9s4KqHaAbkejZ-2GG4zv4Y1AxpgWzcMKovuMJFZ_-w@mail.gmail.com>
Date: Fri, 4 Oct 2013 10:52:56 +0530
Message-ID: <CAKohpokDf40BQwEypsBowyBJbDdvj-0CWypUw6sj9=vwc-FaRQ@mail.gmail.com>
Subject: Re: [PATCH 038/228] cpufreq: sa11x0: Expose frequency table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Olof Johansson <olof@lixom.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: multipart/mixed; boundary=001a11c2cce6b7b26704e7e37edd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c2cce6b7b26704e7e37edd
Content-Type: text/plain; charset=ISO-8859-1

On 4 October 2013 08:23, Olof Johansson <olof@lixom.net> wrote:
> This causes breakage in linux-next for any SA1100 target:
>
> In file included from ../../arch/arm/mach-sa1100/irq.c:24:0:
> ../../arch/arm/mach-sa1100/generic.h:24:39: error: array type has
> incomplete element type
>  extern struct cpufreq_frequency_table sa11x0_freq_table[];

Ahh... sorry!! Below diff fixes it..

@Rafael: Please merge the attached fixup patch with $SUBJECT patch.

------x--------------x-----------

commit d2e1eb969ebdb66e3cc199fbbbe2e2a1a8e2960b
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri Oct 4 10:48:16 2013 +0530

    fixup! cpufreq: sa11x0: Expose frequency table
---
 arch/arm/mach-sa1100/generic.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-sa1100/generic.h b/arch/arm/mach-sa1100/generic.h
index f5214ce..2d9bee0 100644
--- a/arch/arm/mach-sa1100/generic.h
+++ b/arch/arm/mach-sa1100/generic.h
@@ -3,6 +3,7 @@
  *
  * Author: Nicolas Pitre
  */
+#include <linux/cpufreq.h>
 #include <linux/reboot.h>

 extern void sa1100_timer_init(void);
@@ -19,8 +20,6 @@ extern void sa11x0_init_late(void);
 extern void sa1110_mb_enable(void);
 extern void sa1110_mb_disable(void);

-struct cpufreq_policy;
-
 extern struct cpufreq_frequency_table sa11x0_freq_table[];
 extern unsigned int sa11x0_freq_to_ppcr(unsigned int khz);
 extern int sa11x0_verify_speed(struct cpufreq_policy *policy);

--001a11c2cce6b7b26704e7e37edd
Content-Type: application/octet-stream; 
	name="0001-fixup-cpufreq-sa11x0-Expose-frequency-table.patch"
Content-Disposition: attachment; 
	filename="0001-fixup-cpufreq-sa11x0-Expose-frequency-table.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmcytdza0

RnJvbSBkMmUxZWI5NjllYmRiNjZlM2NjMTk5ZmJiYmUyZTJhMWE4ZTI5NjBiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZDJlMWViOTY5ZWJkYjY2ZTNjYzE5OWZiYmJlMmUy
YTFhOGUyOTYwYi4xMzgwODYzOTc5LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogRnJpLCA0IE9jdCAy
MDEzIDEwOjQ4OjE2ICswNTMwClN1YmplY3Q6IFtQQVRDSF0gZml4dXAhIGNwdWZyZXE6IHNhMTF4
MDogRXhwb3NlIGZyZXF1ZW5jeSB0YWJsZQoKLS0tCiBhcmNoL2FybS9tYWNoLXNhMTEwMC9nZW5l
cmljLmggfCAzICstLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21hY2gtc2ExMTAwL2dlbmVyaWMuaCBiL2FyY2gv
YXJtL21hY2gtc2ExMTAwL2dlbmVyaWMuaAppbmRleCBmNTIxNGNlLi4yZDliZWUwIDEwMDY0NAot
LS0gYS9hcmNoL2FybS9tYWNoLXNhMTEwMC9nZW5lcmljLmgKKysrIGIvYXJjaC9hcm0vbWFjaC1z
YTExMDAvZ2VuZXJpYy5oCkBAIC0zLDYgKzMsNyBAQAogICoKICAqIEF1dGhvcjogTmljb2xhcyBQ
aXRyZQogICovCisjaW5jbHVkZSA8bGludXgvY3B1ZnJlcS5oPgogI2luY2x1ZGUgPGxpbnV4L3Jl
Ym9vdC5oPgogCiBleHRlcm4gdm9pZCBzYTExMDBfdGltZXJfaW5pdCh2b2lkKTsKQEAgLTE5LDgg
KzIwLDYgQEAgZXh0ZXJuIHZvaWQgc2ExMXgwX2luaXRfbGF0ZSh2b2lkKTsKIGV4dGVybiB2b2lk
IHNhMTExMF9tYl9lbmFibGUodm9pZCk7CiBleHRlcm4gdm9pZCBzYTExMTBfbWJfZGlzYWJsZSh2
b2lkKTsKIAotc3RydWN0IGNwdWZyZXFfcG9saWN5OwotCiBleHRlcm4gc3RydWN0IGNwdWZyZXFf
ZnJlcXVlbmN5X3RhYmxlIHNhMTF4MF9mcmVxX3RhYmxlW107CiBleHRlcm4gdW5zaWduZWQgaW50
IHNhMTF4MF9mcmVxX3RvX3BwY3IodW5zaWduZWQgaW50IGtoeik7CiBleHRlcm4gaW50IHNhMTF4
MF92ZXJpZnlfc3BlZWQoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3kpOwotLSAKMS43LjEy
LnJjMi4xOC5nNjFiNDcyZQoK
--001a11c2cce6b7b26704e7e37edd--
