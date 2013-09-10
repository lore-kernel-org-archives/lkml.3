Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3IJQeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:34:46 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:47561 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab3IJQen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:34:43 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1309101740120.16010@axis700.grange>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
	<CAKohponZ+FnzqXYMbBzbun0-1iQMi2fS4syrEBC_MdF41vLCeA@mail.gmail.com>
	<Pine.LNX.4.64.1309101656150.16010@axis700.grange>
	<CAKohpomBBKLhNemVUpUHAftGhPJJe+ZB7T_9UYLD7LwpR1nK0g@mail.gmail.com>
	<Pine.LNX.4.64.1309101740120.16010@axis700.grange>
Date: Tue, 10 Sep 2013 22:04:42 +0530
Message-ID: <CAKohpomK7Y_6aLMA3B+hZrtgYq9U89ihgkbvYWA3BsKN3gJD3g@mail.gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: multipart/mixed; boundary=089e01228b14fe405704e60a1430
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01228b14fe405704e60a1430
Content-Type: text/plain; charset=ISO-8859-1

On 10 September 2013 21:52, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Of course, isn't that what I've written above? reverted a commit and added
> debug - in that order.

Ok, I misread it then :(

> Sure, I can... So, with the performance governor I get
>
> [    1.290000] cpufreq-cpu0 cpufreq-cpu0: Looking up cpu0-supply from device tree
> [    1.290000] cpufreq: trying to register driver generic_cpu0
> [    1.290000] cpufreq: adding CPU 0
> [    1.290000] cpufreq: Adding link for CPU: 1
> [    1.290000] cpufreq: setting new policy for CPU 0: 398667 - 1196000 kHz
> [    1.290000] cpufreq: new min and max freqs are 398667 - 1196000 kHz
> [    1.290000] cpufreq: governor switch
> [    1.290000] cpufreq: __cpufreq_governor for CPU 0, event 4
> [    1.290000] cpufreq: __cpufreq_governor for CPU 0, event 1
> [    1.290000] cpufreq_performance: setting to 1196000 kHz because of event 1
> [    1.290000] cpufreq: __cpufreq_driver_target().1665 1
>
> This is my debug - .transition_ongoing is incremented ^^^^^^^^
>
> [    1.300000] cpufreq: target for CPU 0: 1196000 kHz, relation 1, requested 1196000 kHz

Quite straight forward actually.. Please try attached patch and see if it fixes
your problem.. Which it should if I am not wrong.. I will send it
separately then..

Thanks for your time..

--089e01228b14fe405704e60a1430
Content-Type: application/octet-stream; name="0001-fix-target.patch"
Content-Disposition: attachment; filename="0001-fix-target.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlfcarh40

RnJvbSA0ZjUzNzlkMmMxMGYyYzYzNTQ3MjFkOWVhNTkxNTA4M2RmYTI5Y2E3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NGY1Mzc5ZDJjMTBmMmM2MzU0NzIxZDllYTU5MTUw
ODNkZmEyOWNhNy4xMzc4ODMwNzcwLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVHVlLCAxMCBTZXAg
MjAxMyAyMjowMjozOCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGZpeCB0YXJnZXQoKQoKU2lnbmVk
LW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KLS0tCiBkcml2
ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwgMTggKysrKysrKysrLS0tLS0tLS0tCiAxIGZpbGUgY2hh
bmdlZCwgOSBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvY3B1ZnJlcS9jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCmluZGV4IDA5
YmJkYjAuLjNkNDkzOGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKKysr
IGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwpAQCAtMTY1NSwxNSArMTY1NSw2IEBAIGludCBf
X2NwdWZyZXFfZHJpdmVyX3RhcmdldChzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAlp
ZiAoY3B1ZnJlcV9kaXNhYmxlZCgpKQogCQlyZXR1cm4gLUVOT0RFVjsKIAotCXdyaXRlX2xvY2tf
aXJxc2F2ZSgmY3B1ZnJlcV9kcml2ZXJfbG9jaywgZmxhZ3MpOwotCWlmIChwb2xpY3ktPnRyYW5z
aXRpb25fb25nb2luZykgewotCQlwcl9lcnIoIiVzOiBUYXJnZXQgZmFpbGVkXG4iLCBfX2Z1bmNf
Xyk7Ci0JCXdyaXRlX3VubG9ja19pcnFyZXN0b3JlKCZjcHVmcmVxX2RyaXZlcl9sb2NrLCBmbGFn
cyk7Ci0JCXJldHVybiAtRUJVU1k7Ci0JfQotCXBvbGljeS0+dHJhbnNpdGlvbl9vbmdvaW5nKys7
Ci0Jd3JpdGVfdW5sb2NrX2lycXJlc3RvcmUoJmNwdWZyZXFfZHJpdmVyX2xvY2ssIGZsYWdzKTsK
LQogCS8qIE1ha2Ugc3VyZSB0aGF0IHRhcmdldF9mcmVxIGlzIHdpdGhpbiBzdXBwb3J0ZWQgcmFu
Z2UgKi8KIAlpZiAodGFyZ2V0X2ZyZXEgPiBwb2xpY3ktPm1heCkKIAkJdGFyZ2V0X2ZyZXEgPSBw
b2xpY3ktPm1heDsKQEAgLTE2NzYsNiArMTY2NywxNSBAQCBpbnQgX19jcHVmcmVxX2RyaXZlcl90
YXJnZXQoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJaWYgKHRhcmdldF9mcmVxID09
IHBvbGljeS0+Y3VyKQogCQlyZXR1cm4gMDsKIAorCXdyaXRlX2xvY2tfaXJxc2F2ZSgmY3B1ZnJl
cV9kcml2ZXJfbG9jaywgZmxhZ3MpOworCWlmIChwb2xpY3ktPnRyYW5zaXRpb25fb25nb2luZykg
eworCQlwcl9lcnIoIiVzOiBUYXJnZXQgZmFpbGVkXG4iLCBfX2Z1bmNfXyk7CisJCXdyaXRlX3Vu
bG9ja19pcnFyZXN0b3JlKCZjcHVmcmVxX2RyaXZlcl9sb2NrLCBmbGFncyk7CisJCXJldHVybiAt
RUJVU1k7CisJfQorCXBvbGljeS0+dHJhbnNpdGlvbl9vbmdvaW5nKys7CisJd3JpdGVfdW5sb2Nr
X2lycXJlc3RvcmUoJmNwdWZyZXFfZHJpdmVyX2xvY2ssIGZsYWdzKTsKKwogCWlmIChjcHVmcmVx
X2RyaXZlci0+dGFyZ2V0KQogCQlyZXR2YWwgPSBjcHVmcmVxX2RyaXZlci0+dGFyZ2V0KHBvbGlj
eSwgdGFyZ2V0X2ZyZXEsIHJlbGF0aW9uKTsKIAotLSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--089e01228b14fe405704e60a1430--
