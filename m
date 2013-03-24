Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3CXO3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:29:38 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36250 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3CXO3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:29:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAG9S4UjMeRZECAiigZVLTU4av2ZJNBukyUAoCmiYRjtkdThhFw@mail.gmail.com>
References: <CAG9S4UjMeRZECAiigZVLTU4av2ZJNBukyUAoCmiYRjtkdThhFw@mail.gmail.com>
Date: Sun, 24 Mar 2013 19:59:35 +0530
Message-ID: <CAKohpokBySA5uaTTAwF5tmUr-_+W04Ki_f6cWTLu7n1C3Tcqog@mail.gmail.com>
Subject: Re: [REGRESSION] [CPUFREQ] 3.9.0-rcX
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: multipart/mixed; boundary=089e01184d747b63a704d8ac844a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01184d747b63a704d8ac844a
Content-Type: text/plain; charset=ISO-8859-1

On 24 March 2013 19:41, Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> (long e-mail, sorry ;-))

Don't be, it was useful :)

> Last known good: 3.8.0
>
> Short description:
> 1. On -rc3, after s2ram cpufreq does not set CPU on max frequency on high
> load (on battery).

Try attached patch for this.

> 2. On -rc4 (this is not real regression because I change config between -rc3
> and rc4), "ondemand" does not work. Current frequency is 'strange' (792
> MHz).

I don't really have a reason for that :(
But with your config it is clear that, your working setup has:

# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m

and rc4 version has:

CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m

So, i believe you are using another cpufreq driver this, try with same
configuration once.

> 1. Kernel 3.8.0:
>
> Output (show only fisrt CPU, others are same):
> cpu0/cpufreq//affected_cpus:0
> cpu0/cpufreq//related_cpus:0 1 2 3

> Kernel 3.9.0-rc1

> CASE 2
> After boot:
> cpu0/cpufreq//affected_cpus:0 1 2 3
> cpu0/cpufreq//related_cpus:0 1 2 3

My attached patch will restore 1. instead of CASE 2.

> ===============================================================================
> Kernel 3.9.0-rc4
>
> CASE 7
> (normal boot)
> cpu0/cpufreq//affected_cpus:0
> cpu0/cpufreq//related_cpus:0

This must be related to your different driver.

> Config, dmesg:
> http://mrutecki.pl/download/kernel/3.9.0-rc4/cpufreq/

These were very important and helpful.

--089e01184d747b63a704d8ac844a
Content-Type: application/octet-stream; 
	name="0001-cpufreq-acpi-cpufreq-Don-t-set-policy-related_cpus-f.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-acpi-cpufreq-Don-t-set-policy-related_cpus-f.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_heoaonwl0

RnJvbSAwZWI2YTZjZTI1YzcxZTYwZGM2OWUxODk3ZjgwYjdjZTNiYjQxZmIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MGViNmE2Y2UyNWM3MWU2MGRjNjllMTg5N2Y4MGI3
Y2UzYmI0MWZiMi4xMzY0MTM0ODI3LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogU2F0LCAyMyBNYXIg
MjAxMyAyMzo0Mjo0NCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IGFjcGktY3B1ZnJl
cTogRG9uJ3Qgc2V0IHBvbGljeS0+cmVsYXRlZF9jcHVzIGZyb20KIC5pbml0KCkKCldpdGggdGhl
IGFkZGl0aW9uIG9mIGZvbGxvd2luZyBwYXRjaDoKCmZjZjgwNTggY3B1ZnJlcTogU2ltcGxpZnkg
Y3B1ZnJlcV9hZGRfZGV2KCkKCmNwdWZyZXEgZHJpdmVyJ3MgLmluaXQoKSByb3V0aW5lIG11c3Qg
aW5pdGlhbGl6ZSBwb2xpY3ktPmNwdXMgd2l0aCBtYXNrIG9mIGFsbApwb3NzaWJsZSBjcHVzIChP
bmxpbmUgKyBPZmZsaW5lKSB0aGF0IHNoYXJlIHRoZSBjbG9jay4gVGhlbiB0aGUgY29yZSB3b3Vs
ZCBjb3B5CnRoaXMgbWFzayBvbnRvIHBvbGljeS0+cmVsYXRlZF9jcHVzIGFuZCB3aWxsIHJlc2V0
IHBvbGljeS0+Y3B1cyB0byBjYXJyeSBvbmx5Cm9ubGluZSBjcHVzLgoKYWNwaS1jcHVmcmVxIGRy
aXZlciB3YXNuJ3QgdXBkYXRlZCB3aXRoIHRoaXMgYXNzdW1wdGlvbiBhbmQgc28gc29tZXRpbWVz
IHdoZW4Kd2UgdHJ5IHRvIGhvdFt1bl1wbHVnIGNwdXMgYXQgcnVuIHRpbWUsIHN5c2ZzIGRpcmVj
dG9yaWVzIGdldHMgY29ycnVwdGVkLgoKVGhpcyBwYXRjaCBmaXhlcyBhY3BpLWNwdWZyZXEgZHJp
dmVyIGFnYWluc3QgdGhpcyBjb3JydXB0aW9uLgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFy
IDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvYWNwaS1jcHVm
cmVxLmMgfCAyIC0tCiAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2NwdWZyZXEvYWNwaS1jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEvYWNwaS1j
cHVmcmVxLmMKaW5kZXggYWZiZWY5Yy4uMTFiOGI0YiAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVm
cmVxL2FjcGktY3B1ZnJlcS5jCisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9hY3BpLWNwdWZyZXEuYwpA
QCAtNzIzLDcgKzcyMyw2IEBAIHN0YXRpYyBpbnQgYWNwaV9jcHVmcmVxX2NwdV9pbml0KHN0cnVj
dCBjcHVmcmVxX3BvbGljeSAqcG9saWN5KQogCSAgICBwb2xpY3ktPnNoYXJlZF90eXBlID09IENQ
VUZSRVFfU0hBUkVEX1RZUEVfQU5ZKSB7CiAJCWNwdW1hc2tfY29weShwb2xpY3ktPmNwdXMsIHBl
cmYtPnNoYXJlZF9jcHVfbWFwKTsKIAl9Ci0JY3B1bWFza19jb3B5KHBvbGljeS0+cmVsYXRlZF9j
cHVzLCBwZXJmLT5zaGFyZWRfY3B1X21hcCk7CiAKICNpZmRlZiBDT05GSUdfU01QCiAJZG1pX2No
ZWNrX3N5c3RlbShzd19hbnlfYnVnX2RtaV90YWJsZSk7CkBAIC03MzUsNyArNzM0LDYgQEAgc3Rh
dGljIGludCBhY3BpX2NwdWZyZXFfY3B1X2luaXQoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xp
Y3kpCiAJaWYgKGNoZWNrX2FtZF9od3BzdGF0ZV9jcHUoY3B1KSAmJiAhYWNwaV9wc3RhdGVfc3Ry
aWN0KSB7CiAJCWNwdW1hc2tfY2xlYXIocG9saWN5LT5jcHVzKTsKIAkJY3B1bWFza19zZXRfY3B1
KGNwdSwgcG9saWN5LT5jcHVzKTsKLQkJY3B1bWFza19jb3B5KHBvbGljeS0+cmVsYXRlZF9jcHVz
LCBjcHVfc2libGluZ19tYXNrKGNwdSkpOwogCQlwb2xpY3ktPnNoYXJlZF90eXBlID0gQ1BVRlJF
UV9TSEFSRURfVFlQRV9IVzsKIAkJcHJfaW5mb19vbmNlKFBGWCAib3ZlcnJpZGluZyBCSU9TIHBy
b3ZpZGVkIF9QU0QgZGF0YVxuIik7CiAJfQotLSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--089e01184d747b63a704d8ac844a--
