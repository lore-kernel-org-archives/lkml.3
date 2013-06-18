Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab3FRP3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:29:42 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:52762 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab3FRP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:29:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130618151954.GB16094@twins.programming.kicks-ass.net>
References: <cover.1370948150.git.viresh.kumar@linaro.org>
	<7a61e955abdcbb1dfa9fe493f11a5ec53a11ddd3.1370948150.git.viresh.kumar@linaro.org>
	<20130618100306.GL3204@twins.programming.kicks-ass.net>
	<CAKohpo=oAa=mdkZk9yq4W7v-hQpCAM00rTJTWOn-eCBreEqTdA@mail.gmail.com>
	<20130618151954.GB16094@twins.programming.kicks-ass.net>
Date: Tue, 18 Jun 2013 20:59:39 +0530
Message-ID: <CAKohpon_1StvME0nySHRzc2dHNTXHF5X6CXo5J6Rvtyb8wktRg@mail.gmail.com>
Subject: Re: [PATCH 2/3] sched: don't call get_group() for covered cpus
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Content-Type: multipart/mixed; boundary=001a11c2ab98aefa8604df6f6116
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c2ab98aefa8604df6f6116
Content-Type: text/plain; charset=ISO-8859-1

On 18 June 2013 20:49, Peter Zijlstra <peterz@infradead.org> wrote:
> Sure. Just send a new patch and I'll substitute.

This is the new log (patch is attached):

sched: Fix memory leakage in build_sched_groups()

In build_sched_groups() we don't need to call get_group() for cpus which are
already covered in previous iterations. Calling get_group() would mark the group
used and eventually leak it since we wouldn't connect it and not find it again
to free it.

This will happen only in cases where sg->cpumask contained more than one cpu
(For any topology level). This patch would free sg's memory for all cpus leaving
the group leader as the group isn't marked used now.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--001a11c2ab98aefa8604df6f6116
Content-Type: application/octet-stream; 
	name="0001-sched-Fix-memory-leakage-in-build_sched_groups.patch"
Content-Disposition: attachment; 
	filename="0001-sched-Fix-memory-leakage-in-build_sched_groups.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hi38zcfo0

RnJvbSBmYTczMjA4YmJmYTBjMTZlNDY3NzY5NTA3MzYzMmVkYjk2NjIzNDNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZmE3MzIwOGJiZmEwYzE2ZTQ2Nzc2OTUwNzM2MzJl
ZGI5NjYyMzQzZS4xMzcxNTY5MzQ1LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVHVlLCAxMSBKdW4g
MjAxMyAxNDo0Mzo0MyArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIHNjaGVkOiBGaXggbWVtb3J5IGxl
YWthZ2UgaW4gYnVpbGRfc2NoZWRfZ3JvdXBzKCkKCkluIGJ1aWxkX3NjaGVkX2dyb3VwcygpIHdl
IGRvbid0IG5lZWQgdG8gY2FsbCBnZXRfZ3JvdXAoKSBmb3IgY3B1cyB3aGljaCBhcmUKYWxyZWFk
eSBjb3ZlcmVkIGluIHByZXZpb3VzIGl0ZXJhdGlvbnMuIENhbGxpbmcgZ2V0X2dyb3VwKCkgd291
bGQgbWFyayB0aGUgZ3JvdXAKdXNlZCBhbmQgZXZlbnR1YWxseSBsZWFrIGl0IHNpbmNlIHdlIHdv
dWxkbid0IGNvbm5lY3QgaXQgYW5kIG5vdCBmaW5kIGl0IGFnYWluCnRvIGZyZWUgaXQuCgpUaGlz
IHdpbGwgaGFwcGVuIG9ubHkgaW4gY2FzZXMgd2hlcmUgc2ctPmNwdW1hc2sgY29udGFpbmVkIG1v
cmUgdGhhbiBvbmUgY3B1CihGb3IgYW55IHRvcG9sb2d5IGxldmVsKS4gVGhpcyBwYXRjaCB3b3Vs
ZCBmcmVlIHNnJ3MgbWVtb3J5IGZvciBhbGwgY3B1cyBsZWF2aW5nCnRoZSBncm91cCBsZWFkZXIg
YXMgdGhlIGdyb3VwIGlzbid0IG1hcmtlZCB1c2VkIG5vdy4KClNpZ25lZC1vZmYtYnk6IFZpcmVz
aCBLdW1hciA8dmlyZXNoLmt1bWFyQGxpbmFyby5vcmc+Ci0tLQoga2VybmVsL3NjaGVkL2NvcmUu
YyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvc2NoZWQvY29yZS5jIGIva2VybmVsL3NjaGVkL2NvcmUu
YwppbmRleCA0YWJjNzQzLi4yNzg0MmY1IDEwMDY0NAotLS0gYS9rZXJuZWwvc2NoZWQvY29yZS5j
CisrKyBiL2tlcm5lbC9zY2hlZC9jb3JlLmMKQEAgLTUzNDQsMTIgKzUzNDQsMTIgQEAgYnVpbGRf
c2NoZWRfZ3JvdXBzKHN0cnVjdCBzY2hlZF9kb21haW4gKnNkLCBpbnQgY3B1KQogCiAJZm9yX2Vh
Y2hfY3B1KGksIHNwYW4pIHsKIAkJc3RydWN0IHNjaGVkX2dyb3VwICpzZzsKLQkJaW50IGdyb3Vw
ID0gZ2V0X2dyb3VwKGksIHNkZCwgJnNnKTsKLQkJaW50IGo7CisJCWludCBncm91cCwgajsKIAog
CQlpZiAoY3B1bWFza190ZXN0X2NwdShpLCBjb3ZlcmVkKSkKIAkJCWNvbnRpbnVlOwogCisJCWdy
b3VwID0gZ2V0X2dyb3VwKGksIHNkZCwgJnNnKTsKIAkJY3B1bWFza19jbGVhcihzY2hlZF9ncm91
cF9jcHVzKHNnKSk7CiAJCXNnLT5zZ3AtPnBvd2VyID0gMDsKIAkJY3B1bWFza19zZXRhbGwoc2No
ZWRfZ3JvdXBfbWFzayhzZykpOwotLSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--001a11c2ab98aefa8604df6f6116--
