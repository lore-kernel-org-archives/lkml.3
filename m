Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3IMQ3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:29:15 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:39024 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab3IMQ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:29:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130913161059.GD12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<6d8d406ebca886e5147191cc8c333d926ef9eb30.1379063063.git.viresh.kumar@linaro.org>
	<20130913161059.GD12758@n2100.arm.linux.org.uk>
Date: Fri, 13 Sep 2013 21:59:10 +0530
Message-ID: <CAKohponAWXXCVtDL1=C5sQv0QB03P4jtkyE7N+=DDdGPLZpW_w@mail.gmail.com>
Subject: Re: [PATCH 106/228] cpufreq: integrator: don't initialize part of
 policy that is set by core too
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: multipart/mixed; boundary=e89a8fb1ef64b397a904e6465aae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8fb1ef64b397a904e6465aae
Content-Type: text/plain; charset=ISO-8859-1

On 13 September 2013 21:40, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> This patch actually changes things - the description is misleading.
> Please explain why this change - which results in different values for
> policy->min and policy->max doesn't cause any functional difference.

Yeah, see if below log looks correct (patch attached):

Subject: [PATCH 106/228] cpufreq: integrator: don't initialize part of policy
 that is set by core too

Many common initializations of struct policy are moved to core now and hence
this driver doesn't need to do it. This patch removes such code.

Most recent of those changes is to call ->get() in the core after calling
->init(). And so we don't need to set policy->cur from driver anymore.

Over that it sets policy->min and max correctly. They were earlier set to
current frequency of CPU but they should be set to max and min freq of cpu.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/integrator-cpufreq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--e89a8fb1ef64b397a904e6465aae
Content-Type: application/octet-stream; 
	name="0106-cpufreq-integrator-don-t-initialize-part-of-policy-t.patch"
Content-Disposition: attachment; 
	filename="0106-cpufreq-integrator-don-t-initialize-part-of-policy-t.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hljmfdxg0

RnJvbSA2ZDhkNDA2ZWJjYTg4NmU1MTQ3MTkxY2M4YzMzM2Q5MjZlZjllYjMwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NmQ4ZDQwNmViY2E4ODZlNTE0NzE5MWNjOGMzMzNk
OTI2ZWY5ZWIzMC4xMzc5MDYzMDYzLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KSW4tUmVw
bHktVG86IDxjb3Zlci4xMzc5MDYzMDYzLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KUmVm
ZXJlbmNlczogPGNvdmVyLjEzNzkwNjMwNjMuZ2l0LnZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgpG
cm9tOiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgpEYXRlOiBXZWQsIDE0
IEF1ZyAyMDEzIDE2OjAyOjQ3ICswNTMwClN1YmplY3Q6IFtQQVRDSCAxMDYvMjI4XSBjcHVmcmVx
OiBpbnRlZ3JhdG9yOiBkb24ndCBpbml0aWFsaXplIHBhcnQgb2YgcG9saWN5CiB0aGF0IGlzIHNl
dCBieSBjb3JlIHRvbwoKTWFueSBjb21tb24gaW5pdGlhbGl6YXRpb25zIG9mIHN0cnVjdCBwb2xp
Y3kgYXJlIG1vdmVkIHRvIGNvcmUgbm93IGFuZCBoZW5jZQp0aGlzIGRyaXZlciBkb2Vzbid0IG5l
ZWQgdG8gZG8gaXQuIFRoaXMgcGF0Y2ggcmVtb3ZlcyBzdWNoIGNvZGUuCgpNb3N0IHJlY2VudCBv
ZiB0aG9zZSBjaGFuZ2VzIGlzIHRvIGNhbGwgLT5nZXQoKSBpbiB0aGUgY29yZSBhZnRlciBjYWxs
aW5nCi0+aW5pdCgpLiBBbmQgc28gd2UgZG9uJ3QgbmVlZCB0byBzZXQgcG9saWN5LT5jdXIgZnJv
bSBkcml2ZXIgYW55bW9yZS4KCk92ZXIgdGhhdCBpdCBzZXRzIHBvbGljeS0+bWluIGFuZCBtYXgg
Y29ycmVjdGx5LiBUaGV5IHdlcmUgZWFybGllciBzZXQgdG8KY3VycmVudCBmcmVxdWVuY3kgb2Yg
Q1BVIGJ1dCB0aGV5IHNob3VsZCBiZSBzZXQgdG8gbWF4IGFuZCBtaW4gZnJlcSBvZiBjcHUuCgpD
YzogUnVzc2VsbCBLaW5nIDxsaW51eEBhcm0ubGludXgub3JnLnVrPgpTaWduZWQtb2ZmLWJ5OiBW
aXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJl
cS9pbnRlZ3JhdG9yLWNwdWZyZXEuYyB8IDUgKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVmcmVxL2lu
dGVncmF0b3ItY3B1ZnJlcS5jIGIvZHJpdmVycy9jcHVmcmVxL2ludGVncmF0b3ItY3B1ZnJlcS5j
CmluZGV4IDgxNTJhOWIuLmJhYmYzZTQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9pbnRl
Z3JhdG9yLWNwdWZyZXEuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvaW50ZWdyYXRvci1jcHVmcmVx
LmMKQEAgLTE4MSwxMCArMTgxLDkgQEAgc3RhdGljIGludCBpbnRlZ3JhdG9yX2NwdWZyZXFfaW5p
dChzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSkKIHsKIAogCS8qIHNldCBkZWZhdWx0IHBv
bGljeSBhbmQgY3B1aW5mbyAqLwotCXBvbGljeS0+Y3B1aW5mby5tYXhfZnJlcSA9IDE2MDAwMDsK
LQlwb2xpY3ktPmNwdWluZm8ubWluX2ZyZXEgPSAxMjAwMDsKKwlwb2xpY3ktPm1heCA9IHBvbGlj
eS0+Y3B1aW5mby5tYXhfZnJlcSA9IDE2MDAwMDsKKwlwb2xpY3ktPm1pbiA9IHBvbGljeS0+Y3B1
aW5mby5taW5fZnJlcSA9IDEyMDAwOwogCXBvbGljeS0+Y3B1aW5mby50cmFuc2l0aW9uX2xhdGVu
Y3kgPSAxMDAwMDAwOyAvKiAxIG1zLCBhc3N1bWVkICovCi0JcG9saWN5LT5jdXIgPSBwb2xpY3kt
Pm1pbiA9IHBvbGljeS0+bWF4ID0gaW50ZWdyYXRvcl9nZXQocG9saWN5LT5jcHUpOwogCiAJcmV0
dXJuIDA7CiB9Ci0tIAoxLjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--e89a8fb1ef64b397a904e6465aae--
