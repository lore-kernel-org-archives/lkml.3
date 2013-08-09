Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3HIEEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:04:53 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:58392 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab3HIEEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:04:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomr8kwDitAFD7FKvHo3zNWz8qT5bkd3yOVEnC_k16o=Dw@mail.gmail.com>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
	<568f3dbd414b050bb2319d960fb5044a5aed8ee3.1375964117.git.viresh.kumar@linaro.org>
	<5203BCDD.40809@wwwdotorg.org>
	<CAKohpomr8kwDitAFD7FKvHo3zNWz8qT5bkd3yOVEnC_k16o=Dw@mail.gmail.com>
Date: Fri, 9 Aug 2013 09:34:47 +0530
Message-ID: <CAKohpo=Gy7D2LYmdFU1p+eL-nMoPE18YXWvE2M8t-fb-a5HBgg@mail.gmail.com>
Subject: Re: [PATCH 35/35] cpufreq: tegra: use cpufreq_table_validate_and_show()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Content-Type: multipart/mixed; boundary=089e0158adfe20e07a04e37be01f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0158adfe20e07a04e37be01f
Content-Type: text/plain; charset=ISO-8859-1

On 8 August 2013 21:37, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Its useless and the correct routine isn't called at all :) .. I will add that
> additional patch and send it to you and will get this change out of this
> commit.

The two commits look like this now attached too in case you want
to test:

commit 9abdc9127b9f7f1e00c75694d15345843a60ff99
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Thu Aug 8 16:40:32 2013 +0530

    cpufreq: tegra: use cpufreq_table_validate_and_show()

    Lets use cpufreq_table_validate_and_show() instead of calling
    cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

    Cc: Stephen Warren <swarren@nvidia.com>
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index cd66b85..51752b3 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -215,8 +215,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
        clk_prepare_enable(emc_clk);
        clk_prepare_enable(cpu_clk);

-       cpufreq_frequency_table_cpuinfo(policy, freq_table);
-       cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
+       cpufreq_table_validate_and_show(policy, freq_table);
        policy->cur = tegra_getspeed(policy->cpu);
        target_cpu_speed[policy->cpu] = policy->cur;


commit f1bb1cab6130501251eee616280b88c0b49d96d7
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri Aug 9 09:29:19 2013 +0530

    cpufreq: tegra: fix implementation of ->exit()

    ->exit() of drivers should call cpufreq_frequency_table_put_attr()
if they have
    called cpufreq_frequency_table_get_attr() earlier in init() and they aren't
    required to validate their cpufreq table in exit by calling
    cpufreq_frequency_table_cpuinfo(). Tegra's driver wasn't calling
    cpufreq_frequency_table_put_attr() and was calling
    cpufreq_frequency_table_cpuinfo() in exit.

    Fix both these issues in it.

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 51752b3..faf1ce5 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -232,7 +232,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)

 static int tegra_cpu_exit(struct cpufreq_policy *policy)
 {
-       cpufreq_frequency_table_cpuinfo(policy, freq_table);
+       cpufreq_frequency_table_put_attr(policy->cpu);
        clk_disable_unprepare(emc_clk);
        return 0;
 }

--089e0158adfe20e07a04e37be01f
Content-Type: application/octet-stream; 
	name="0001-cpufreq-Add-new-helper-cpufreq_table_validate_and_sh.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-Add-new-helper-cpufreq_table_validate_and_sh.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hk4vez5c0

RnJvbSA4YWRkYTA0MTNmMDA3ZGQzZDRhYjZkYWM5MzRjMDc0YzIwNWFkYThkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8OGFkZGEwNDEzZjAwN2RkM2Q0YWI2ZGFjOTM0YzA3
NGMyMDVhZGE4ZC4xMzc2MDIxMDU1LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVGh1LCA4IEF1ZyAy
MDEzIDE2OjIyOjA0ICswNTMwClN1YmplY3Q6IFtQQVRDSCAwMS8zNl0gY3B1ZnJlcTogQWRkIG5l
dyBoZWxwZXIKIGNwdWZyZXFfdGFibGVfdmFsaWRhdGVfYW5kX3Nob3coKQoKQWxtb3N0IGV2ZXJ5
IGNwdWZyZXEgZHJpdmVyIGlzIHJlcXVpcmVkIHRvIHZhbGlkYXRlIGl0cyBmcmVxdWVuY3kgdGFi
bGUgd2l0aDoKY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfY3B1aW5mbygpIGFuZCB0aGVuIGV4cG9z
ZSBpdCB0byBjcHVmcmVxIGNvcmUgd2l0aDoKY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfZ2V0X2F0
dHIoKS4KClRoaXMgcGF0Y2ggY3JlYXRlcyBhbm90aGVyIGhlbHBlciByb3V0aW5lIGNwdWZyZXFf
dGFibGVfdmFsaWRhdGVfYW5kX3Nob3coKSB0aGF0CndpbGwgZG8gYm90aCB0aGVzZSBzdGVwcyBp
biBhIHNpbmdsZSBjYWxsIGFuZCB3aWxsIHJldHVybiAwIGZvciBzdWNjZXNzLCBlcnJvcgpvdGhl
cndpc2UuCgpUaGlzIGFsc28gZml4ZXMgcG90ZW50aWFsIGJ1Z3MgaW4gY3B1ZnJlcSBkcml2ZXJz
IHdoZXJlIHBlb3BsZSBoYXZlIGNhbGxlZApjcHVmcmVxX2ZyZXF1ZW5jeV90YWJsZV9nZXRfYXR0
cigpIGJlZm9yZSBjYWxsaW5nCmNwdWZyZXFfZnJlcXVlbmN5X3RhYmxlX2NwdWluZm8oKSwgYXMg
dGhlIGxhdGVyIG1heSBmYWlsLgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gu
a3VtYXJAbGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvZnJlcV90YWJsZS5jIHwgMTIg
KysrKysrKysrKysrCiBpbmNsdWRlL2xpbnV4L2NwdWZyZXEuaCAgICAgIHwgIDIgKysKIDIgZmls
ZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJl
cS9mcmVxX3RhYmxlLmMgYi9kcml2ZXJzL2NwdWZyZXEvZnJlcV90YWJsZS5jCmluZGV4IGYxMTE0
NTRhLi4xMWY2ZmE5IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvZnJlcV90YWJsZS5jCisr
KyBiL2RyaXZlcnMvY3B1ZnJlcS9mcmVxX3RhYmxlLmMKQEAgLTIxOSw2ICsyMTksMTggQEAgdm9p
ZCBjcHVmcmVxX2ZyZXF1ZW5jeV90YWJsZV9wdXRfYXR0cih1bnNpZ25lZCBpbnQgY3B1KQogfQog
RVhQT1JUX1NZTUJPTF9HUEwoY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfcHV0X2F0dHIpOwogCitp
bnQgY3B1ZnJlcV90YWJsZV92YWxpZGF0ZV9hbmRfc2hvdyhzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kg
KnBvbGljeSwKKwkJCQkgICAgICBzdHJ1Y3QgY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGUgKnRhYmxl
KQoreworCWludCByZXQgPSBjcHVmcmVxX2ZyZXF1ZW5jeV90YWJsZV9jcHVpbmZvKHBvbGljeSwg
dGFibGUpOworCisJaWYgKCFyZXQpCisJCWNwdWZyZXFfZnJlcXVlbmN5X3RhYmxlX2dldF9hdHRy
KHRhYmxlLCBwb2xpY3ktPmNwdSk7CisKKwlyZXR1cm4gcmV0OworfQorRVhQT1JUX1NZTUJPTF9H
UEwoY3B1ZnJlcV90YWJsZV92YWxpZGF0ZV9hbmRfc2hvdyk7CisKIHZvaWQgY3B1ZnJlcV9mcmVx
dWVuY3lfdGFibGVfdXBkYXRlX3BvbGljeV9jcHUoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xp
Y3kpCiB7CiAJcHJfZGVidWcoIlVwZGF0aW5nIHNob3dfdGFibGUgZm9yIG5ld19jcHUgJXUgZnJv
bSBsYXN0X2NwdSAldVxuIiwKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5oIGIv
aW5jbHVkZS9saW51eC9jcHVmcmVxLmgKaW5kZXggZDU2OGYzOS4uYzAyOTdhNiAxMDA2NDQKLS0t
IGEvaW5jbHVkZS9saW51eC9jcHVmcmVxLmgKKysrIGIvaW5jbHVkZS9saW51eC9jcHVmcmVxLmgK
QEAgLTQxMSw1ICs0MTEsNyBAQCBleHRlcm4gc3RydWN0IGZyZXFfYXR0ciBjcHVmcmVxX2ZyZXFf
YXR0cl9zY2FsaW5nX2F2YWlsYWJsZV9mcmVxczsKIHZvaWQgY3B1ZnJlcV9mcmVxdWVuY3lfdGFi
bGVfZ2V0X2F0dHIoc3RydWN0IGNwdWZyZXFfZnJlcXVlbmN5X3RhYmxlICp0YWJsZSwKIAkJCQkg
ICAgICB1bnNpZ25lZCBpbnQgY3B1KTsKIHZvaWQgY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfcHV0
X2F0dHIodW5zaWduZWQgaW50IGNwdSk7CitpbnQgY3B1ZnJlcV90YWJsZV92YWxpZGF0ZV9hbmRf
c2hvdyhzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKKwkJCQkgICAgICBzdHJ1Y3QgY3B1
ZnJlcV9mcmVxdWVuY3lfdGFibGUgKnRhYmxlKTsKIAogI2VuZGlmIC8qIF9MSU5VWF9DUFVGUkVR
X0ggKi8KLS0gCjEuNy4xMi5yYzIuMTguZzYxYjQ3MmUKCg==
--089e0158adfe20e07a04e37be01f
Content-Type: application/octet-stream; 
	name="0035-cpufreq-tegra-use-cpufreq_table_validate_and_show.patch"
Content-Disposition: attachment; 
	filename="0035-cpufreq-tegra-use-cpufreq_table_validate_and_show.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hk4vf92b1

RnJvbSA5YWJkYzkxMjdiOWY3ZjFlMDBjNzU2OTRkMTUzNDU4NDNhNjBmZjk5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8OWFiZGM5MTI3YjlmN2YxZTAwYzc1Njk0ZDE1MzQ1
ODQzYTYwZmY5OS4xMzc2MDIxMDU1LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KSW4tUmVw
bHktVG86IDw4YWRkYTA0MTNmMDA3ZGQzZDRhYjZkYWM5MzRjMDc0YzIwNWFkYThkLjEzNzYwMjEw
NTUuZ2l0LnZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgpSZWZlcmVuY2VzOiA8OGFkZGEwNDEzZjAw
N2RkM2Q0YWI2ZGFjOTM0YzA3NGMyMDVhZGE4ZC4xMzc2MDIxMDU1LmdpdC52aXJlc2gua3VtYXJA
bGluYXJvLm9yZz4KRnJvbTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4K
RGF0ZTogVGh1LCA4IEF1ZyAyMDEzIDE2OjQwOjMyICswNTMwClN1YmplY3Q6IFtQQVRDSCAzNS8z
Nl0gY3B1ZnJlcTogdGVncmE6IHVzZSBjcHVmcmVxX3RhYmxlX3ZhbGlkYXRlX2FuZF9zaG93KCkK
CkxldHMgdXNlIGNwdWZyZXFfdGFibGVfdmFsaWRhdGVfYW5kX3Nob3coKSBpbnN0ZWFkIG9mIGNh
bGxpbmcKY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfY3B1aW5mbygpIGFuZCBjcHVmcmVxX2ZyZXF1
ZW5jeV90YWJsZV9nZXRfYXR0cigpLgoKQ2M6IFN0ZXBoZW4gV2FycmVuIDxzd2FycmVuQG52aWRp
YS5jb20+ClNpZ25lZC1vZmYtYnk6IFZpcmVzaCBLdW1hciA8dmlyZXNoLmt1bWFyQGxpbmFyby5v
cmc+Ci0tLQogZHJpdmVycy9jcHVmcmVxL3RlZ3JhLWNwdWZyZXEuYyB8IDMgKy0tCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9jcHVmcmVxL3RlZ3JhLWNwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS90ZWdyYS1jcHVm
cmVxLmMKaW5kZXggY2Q2NmI4NS4uNTE3NTJiMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVx
L3RlZ3JhLWNwdWZyZXEuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvdGVncmEtY3B1ZnJlcS5jCkBA
IC0yMTUsOCArMjE1LDcgQEAgc3RhdGljIGludCB0ZWdyYV9jcHVfaW5pdChzdHJ1Y3QgY3B1ZnJl
cV9wb2xpY3kgKnBvbGljeSkKIAljbGtfcHJlcGFyZV9lbmFibGUoZW1jX2Nsayk7CiAJY2xrX3By
ZXBhcmVfZW5hYmxlKGNwdV9jbGspOwogCi0JY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfY3B1aW5m
byhwb2xpY3ksIGZyZXFfdGFibGUpOwotCWNwdWZyZXFfZnJlcXVlbmN5X3RhYmxlX2dldF9hdHRy
KGZyZXFfdGFibGUsIHBvbGljeS0+Y3B1KTsKKwljcHVmcmVxX3RhYmxlX3ZhbGlkYXRlX2FuZF9z
aG93KHBvbGljeSwgZnJlcV90YWJsZSk7CiAJcG9saWN5LT5jdXIgPSB0ZWdyYV9nZXRzcGVlZChw
b2xpY3ktPmNwdSk7CiAJdGFyZ2V0X2NwdV9zcGVlZFtwb2xpY3ktPmNwdV0gPSBwb2xpY3ktPmN1
cjsKIAotLSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--089e0158adfe20e07a04e37be01f
Content-Type: application/octet-stream; 
	name="0036-cpufreq-tegra-fix-implementation-of-exit.patch"
Content-Disposition: attachment; 
	filename="0036-cpufreq-tegra-fix-implementation-of-exit.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hk4vf92f2

RnJvbSBmMWJiMWNhYjYxMzA1MDEyNTFlZWU2MTYyODBiODhjMGI0OWQ5NmQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZjFiYjFjYWI2MTMwNTAxMjUxZWVlNjE2MjgwYjg4
YzBiNDlkOTZkNy4xMzc2MDIxMDU1LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KSW4tUmVw
bHktVG86IDw4YWRkYTA0MTNmMDA3ZGQzZDRhYjZkYWM5MzRjMDc0YzIwNWFkYThkLjEzNzYwMjEw
NTUuZ2l0LnZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgpSZWZlcmVuY2VzOiA8OGFkZGEwNDEzZjAw
N2RkM2Q0YWI2ZGFjOTM0YzA3NGMyMDVhZGE4ZC4xMzc2MDIxMDU1LmdpdC52aXJlc2gua3VtYXJA
bGluYXJvLm9yZz4KRnJvbTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4K
RGF0ZTogRnJpLCA5IEF1ZyAyMDEzIDA5OjI5OjE5ICswNTMwClN1YmplY3Q6IFtQQVRDSCAzNi8z
Nl0gY3B1ZnJlcTogdGVncmE6IGZpeCBpbXBsZW1lbnRhdGlvbiBvZiAtPmV4aXQoKQoKLT5leGl0
KCkgb2YgZHJpdmVycyBzaG91bGQgY2FsbCBjcHVmcmVxX2ZyZXF1ZW5jeV90YWJsZV9wdXRfYXR0
cigpIGlmIHRoZXkgaGF2ZQpjYWxsZWQgY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfZ2V0X2F0dHIo
KSBlYXJsaWVyIGluIGluaXQoKSBhbmQgdGhleSBhcmVuJ3QKcmVxdWlyZWQgdG8gdmFsaWRhdGUg
dGhlaXIgY3B1ZnJlcSB0YWJsZSBpbiBleGl0IGJ5IGNhbGxpbmcKY3B1ZnJlcV9mcmVxdWVuY3lf
dGFibGVfY3B1aW5mbygpLiBUZWdyYSdzIGRyaXZlciB3YXNuJ3QgY2FsbGluZwpjcHVmcmVxX2Zy
ZXF1ZW5jeV90YWJsZV9wdXRfYXR0cigpIGFuZCB3YXMgY2FsbGluZwpjcHVmcmVxX2ZyZXF1ZW5j
eV90YWJsZV9jcHVpbmZvKCkgaW4gZXhpdC4KCkZpeCBib3RoIHRoZXNlIGlzc3VlcyBpbiBpdC4K
ClNpZ25lZC1vZmYtYnk6IFZpcmVzaCBLdW1hciA8dmlyZXNoLmt1bWFyQGxpbmFyby5vcmc+Ci0t
LQogZHJpdmVycy9jcHVmcmVxL3RlZ3JhLWNwdWZyZXEuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1
ZnJlcS90ZWdyYS1jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEvdGVncmEtY3B1ZnJlcS5jCmlu
ZGV4IDUxNzUyYjMuLmZhZjFjZTUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS90ZWdyYS1j
cHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL3RlZ3JhLWNwdWZyZXEuYwpAQCAtMjMyLDcg
KzIzMiw3IEBAIHN0YXRpYyBpbnQgdGVncmFfY3B1X2luaXQoc3RydWN0IGNwdWZyZXFfcG9saWN5
ICpwb2xpY3kpCiAKIHN0YXRpYyBpbnQgdGVncmFfY3B1X2V4aXQoc3RydWN0IGNwdWZyZXFfcG9s
aWN5ICpwb2xpY3kpCiB7Ci0JY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfY3B1aW5mbyhwb2xpY3ks
IGZyZXFfdGFibGUpOworCWNwdWZyZXFfZnJlcXVlbmN5X3RhYmxlX3B1dF9hdHRyKHBvbGljeS0+
Y3B1KTsKIAljbGtfZGlzYWJsZV91bnByZXBhcmUoZW1jX2Nsayk7CiAJcmV0dXJuIDA7CiB9Ci0t
IAoxLjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--089e0158adfe20e07a04e37be01f--
