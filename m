Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab3BZMOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:14:33 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:39951 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab3BZMOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:14:30 -0500
MIME-Version: 1.0
In-Reply-To: <512C9D20.8020309@linaro.org>
References: <5123C299.3080005@linaro.org>
	<1361484083-5906-1-git-send-email-daniel.lezcano@linaro.org>
	<CAKohpomqooF6DzzzdUFByA0wDxQ3RuPne15a9Vy1sScKjZfeyA@mail.gmail.com>
	<512C9D20.8020309@linaro.org>
Date: Tue, 26 Feb 2013 17:44:28 +0530
Message-ID: <CAKohpong=ioMvnWErKQ1gEcG71f5et26EDJFtbsE1SOr=TN_tQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] time : pass broadcast device parameter
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, fweisbec@gmail.com,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8fb205e46cb7bd04d69f992a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8fb205e46cb7bd04d69f992a
Content-Type: text/plain; charset=ISO-8859-1

On 26 February 2013 17:01, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> Oh, by the way, could send me the patch to set the flag to the timer
> device ? I will include it to the patchset.

Sure. Find it attached too as gmail may break it.

commit 14422c760bb5b2485867f3efb7842d296081ad86
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri Feb 22 12:42:39 2013 +0530

    ARM/timer-sp: Set dynamic irq affinity

    When a cpu goes to a deep idle state where its local timer is shutdown, it
    notifies the time frame work to use the broadcast timer instead.

    Unfortunately, the broadcast device could wake up any CPU,
including an idle one
    which is not concerned by the wake up at all.

    This implies, in the worst case, an idle CPU will wake up to send an IPI to
    another idle cpu.

    This patch fixes this for ARM platforms using timer-sp, by setting
    CLOCK_EVT_FEAT_DYNIRQ feature.

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/common/timer-sp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
index 9d2d3ba..ae3c0f9 100644
--- a/arch/arm/common/timer-sp.c
+++ b/arch/arm/common/timer-sp.c
@@ -158,7 +158,8 @@ static int sp804_set_next_event(unsigned long next,
 }

 static struct clock_event_device sp804_clockevent = {
-       .features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+       .features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
+               CLOCK_EVT_FEAT_DYNIRQ,
        .set_mode       = sp804_set_mode,
        .set_next_event = sp804_set_next_event,
        .rating         = 300,

--e89a8fb205e46cb7bd04d69f992a
Content-Type: application/octet-stream; 
	name="0001-ARM-timer-sp-Set-dynamic-irq-affinity.patch"
Content-Disposition: attachment; 
	filename="0001-ARM-timer-sp-Set-dynamic-irq-affinity.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdn0p8ko0

RnJvbSAxNDQyMmM3NjBiYjViMjQ4NTg2N2YzZWZiNzg0MmQyOTYwODFhZDg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MTQ0MjJjNzYwYmI1YjI0ODU4NjdmM2VmYjc4NDJk
Mjk2MDgxYWQ4Ni4xMzYxODgwODI3LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogRnJpLCAyMiBGZWIg
MjAxMyAxMjo0MjozOSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIEFSTS90aW1lci1zcDogU2V0IGR5
bmFtaWMgaXJxIGFmZmluaXR5CgpXaGVuIGEgY3B1IGdvZXMgdG8gYSBkZWVwIGlkbGUgc3RhdGUg
d2hlcmUgaXRzIGxvY2FsIHRpbWVyIGlzIHNodXRkb3duLCBpdApub3RpZmllcyB0aGUgdGltZSBm
cmFtZSB3b3JrIHRvIHVzZSB0aGUgYnJvYWRjYXN0IHRpbWVyIGluc3RlYWQuCgpVbmZvcnR1bmF0
ZWx5LCB0aGUgYnJvYWRjYXN0IGRldmljZSBjb3VsZCB3YWtlIHVwIGFueSBDUFUsIGluY2x1ZGlu
ZyBhbiBpZGxlIG9uZQp3aGljaCBpcyBub3QgY29uY2VybmVkIGJ5IHRoZSB3YWtlIHVwIGF0IGFs
bC4KClRoaXMgaW1wbGllcywgaW4gdGhlIHdvcnN0IGNhc2UsIGFuIGlkbGUgQ1BVIHdpbGwgd2Fr
ZSB1cCB0byBzZW5kIGFuIElQSSB0bwphbm90aGVyIGlkbGUgY3B1LgoKVGhpcyBwYXRjaCBmaXhl
cyB0aGlzIGZvciBBUk0gcGxhdGZvcm1zIHVzaW5nIHRpbWVyLXNwLCBieSBzZXR0aW5nCkNMT0NL
X0VWVF9GRUFUX0RZTklSUSBmZWF0dXJlLgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2
aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KLS0tCiBhcmNoL2FybS9jb21tb24vdGltZXItc3AuYyB8
IDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC0tZ2l0IGEvYXJjaC9hcm0vY29tbW9uL3RpbWVyLXNwLmMgYi9hcmNoL2FybS9jb21tb24v
dGltZXItc3AuYwppbmRleCA5ZDJkM2JhLi5hZTNjMGY5IDEwMDY0NAotLS0gYS9hcmNoL2FybS9j
b21tb24vdGltZXItc3AuYworKysgYi9hcmNoL2FybS9jb21tb24vdGltZXItc3AuYwpAQCAtMTU4
LDcgKzE1OCw4IEBAIHN0YXRpYyBpbnQgc3A4MDRfc2V0X25leHRfZXZlbnQodW5zaWduZWQgbG9u
ZyBuZXh0LAogfQogCiBzdGF0aWMgc3RydWN0IGNsb2NrX2V2ZW50X2RldmljZSBzcDgwNF9jbG9j
a2V2ZW50ID0gewotCS5mZWF0dXJlcyAgICAgICA9IENMT0NLX0VWVF9GRUFUX1BFUklPRElDIHwg
Q0xPQ0tfRVZUX0ZFQVRfT05FU0hPVCwKKwkuZmVhdHVyZXMgICAgICAgPSBDTE9DS19FVlRfRkVB
VF9QRVJJT0RJQyB8IENMT0NLX0VWVF9GRUFUX09ORVNIT1QgfAorCQlDTE9DS19FVlRfRkVBVF9E
WU5JUlEsCiAJLnNldF9tb2RlCT0gc3A4MDRfc2V0X21vZGUsCiAJLnNldF9uZXh0X2V2ZW50CT0g
c3A4MDRfc2V0X25leHRfZXZlbnQsCiAJLnJhdGluZwkJPSAzMDAsCi0tIAoxLjcuMTIucmMyLjE4
Lmc2MWI0NzJlCgo=
--e89a8fb205e46cb7bd04d69f992a--
