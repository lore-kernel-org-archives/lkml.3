Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3CVMK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:10:28 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:52830 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3CVMK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:10:26 -0400
MIME-Version: 1.0
In-Reply-To: <2999694.A2YTRdtkxt@vostro.rjw.lan>
References: <234906745c34fb72b0c450d897f261a22ed18d40.1363947023.git.viresh.kumar@linaro.org>
	<38998218.UX7TkEXzYs@vostro.rjw.lan>
	<CAKohpo=TFO5CEtO_tDxTthC3K01yh08v9h7hXr2Oq4zffgb2OQ@mail.gmail.com>
	<2999694.A2YTRdtkxt@vostro.rjw.lan>
Date: Fri, 22 Mar 2013 17:40:25 +0530
Message-ID: <CAKohpokYkieTyv=e9kM=zp6qJ9o5+c1D7eodsHf2ncCUig-1MA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: stats: do cpufreq_cpu_put() corresponding to cpufreq_cpu_get
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Robin Randhawa <robin.randhawa@arm.com>, linux-pm@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Steve Bannister <Steve.Bannister@arm.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>
Content-Type: multipart/mixed; boundary=e89a8fb2017e1eccb904d88257af
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8fb2017e1eccb904d88257af
Content-Type: text/plain; charset=ISO-8859-1

On 22 March 2013 17:42, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Which would be useful to write in the changelog, wouldn't it?

Hmm..

copy-paste with gmail is also broken, so find it attached too.

New change log, no change in patch and you can trust me on that :)

----------x-------------x--------

>From 034e5ac4cccd09872592a46decd38d5f24047f10 Mon Sep 17 00:00:00 2001
Message-Id: <034e5ac4cccd09872592a46decd38d5f24047f10.1363954124.git.viresh.kumar@linaro.org>
From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 22 Mar 2013 15:15:48 +0530
Subject: [PATCH] cpufreq: stats: do cpufreq_cpu_put() corresponding to
 cpufreq_cpu_get

In cpufreq_stats_free_sysfs() we aren't balancing calls to cpufreq_cpu_get()
with cpufreq_cpu_put(). This will never let us have ref count to policy->kobj as
zero.

We will get a hang if somehow cpufreq_driver_unregister() is called. And that
can happen when we compile our driver as module and insmod/rmmod it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

--e89a8fb2017e1eccb904d88257af
Content-Type: application/octet-stream; 
	name="0001-cpufreq-stats-do-cpufreq_cpu_put-corresponding-to-cp.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-stats-do-cpufreq_cpu_put-corresponding-to-cp.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_helb3n2b0

RnJvbSAwMzRlNWFjNGNjY2QwOTg3MjU5MmE0NmRlY2QzOGQ1ZjI0MDQ3ZjEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MDM0ZTVhYzRjY2NkMDk4NzI1OTJhNDZkZWNkMzhk
NWYyNDA0N2YxMC4xMzYzOTU0MTI0LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogRnJpLCAyMiBNYXIg
MjAxMyAxNToxNTo0OCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IHN0YXRzOiBkbyBj
cHVmcmVxX2NwdV9wdXQoKSBjb3JyZXNwb25kaW5nIHRvCiBjcHVmcmVxX2NwdV9nZXQKCkluIGNw
dWZyZXFfc3RhdHNfZnJlZV9zeXNmcygpIHdlIGFyZW4ndCBiYWxhbmNpbmcgY2FsbHMgdG8gY3B1
ZnJlcV9jcHVfZ2V0KCkKd2l0aCBjcHVmcmVxX2NwdV9wdXQoKS4gVGhpcyB3aWxsIG5ldmVyIGxl
dCB1cyBoYXZlIHJlZiBjb3VudCB0byBwb2xpY3ktPmtvYmogYXMKemVyby4KCldlIHdpbGwgZ2V0
IGEgaGFuZyBpZiBzb21laG93IGNwdWZyZXFfZHJpdmVyX3VucmVnaXN0ZXIoKSBpcyBjYWxsZWQu
IEFuZCB0aGF0CmNhbiBoYXBwZW4gd2hlbiB3ZSBjb21waWxlIG91ciBkcml2ZXIgYXMgbW9kdWxl
IGFuZCBpbnNtb2Qvcm1tb2QgaXQuCgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVz
aC5rdW1hckBsaW5hcm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX3N0YXRzLmMg
fCAxMiArKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDQgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfc3RhdHMuYyBi
L2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX3N0YXRzLmMKaW5kZXggMmZkNzc5ZS4uYmZkNjI3MyAx
MDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfc3RhdHMuYworKysgYi9kcml2ZXJz
L2NwdWZyZXEvY3B1ZnJlcV9zdGF0cy5jCkBAIC0xODAsMTUgKzE4MCwxOSBAQCBzdGF0aWMgdm9p
ZCBjcHVmcmVxX3N0YXRzX2ZyZWVfc3lzZnModW5zaWduZWQgaW50IGNwdSkKIHsKIAlzdHJ1Y3Qg
Y3B1ZnJlcV9wb2xpY3kgKnBvbGljeSA9IGNwdWZyZXFfY3B1X2dldChjcHUpOwogCi0JaWYgKCFj
cHVmcmVxX2ZyZXF1ZW5jeV9nZXRfdGFibGUoY3B1KSkKKwlpZiAoIXBvbGljeSkKIAkJcmV0dXJu
OwogCi0JaWYgKHBvbGljeSAmJiAhcG9saWN5X2lzX3NoYXJlZChwb2xpY3kpKSB7CisJaWYgKCFj
cHVmcmVxX2ZyZXF1ZW5jeV9nZXRfdGFibGUoY3B1KSkKKwkJZ290byBwdXRfcmVmOworCisJaWYg
KCFwb2xpY3lfaXNfc2hhcmVkKHBvbGljeSkpIHsKIAkJcHJfZGVidWcoIiVzOiBGcmVlIHN5c2Zz
IHN0YXRcbiIsIF9fZnVuY19fKTsKIAkJc3lzZnNfcmVtb3ZlX2dyb3VwKCZwb2xpY3ktPmtvYmos
ICZzdGF0c19hdHRyX2dyb3VwKTsKIAl9Ci0JaWYgKHBvbGljeSkKLQkJY3B1ZnJlcV9jcHVfcHV0
KHBvbGljeSk7CisKK3B1dF9yZWY6CisJY3B1ZnJlcV9jcHVfcHV0KHBvbGljeSk7CiB9CiAKIHN0
YXRpYyBpbnQgY3B1ZnJlcV9zdGF0c19jcmVhdGVfdGFibGUoc3RydWN0IGNwdWZyZXFfcG9saWN5
ICpwb2xpY3ksCi0tIAoxLjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--e89a8fb2017e1eccb904d88257af--
