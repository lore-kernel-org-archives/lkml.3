Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbaHKWN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:13:26 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:44431 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaHKWNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:13:25 -0400
From: Sadasivan Shaiju <sshaiju@mvista.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac+1sWXlrzArgwQQQAWOX864yhWXSQ==
Date: Mon, 11 Aug 2014 15:13:19 -0700
Message-ID: <5bf77c903d6df6cfe656a3585c314df1@mail.gmail.com>
Subject: [PATCH] delaying interrupts in mips [ 2.6.32]
To: linux-kernel@vger.kernel.org, ralf@linux-mips.org, david.daney@cavium.com
Cc: shaiju_sada@yahoo.com
Content-Type: multipart/mixed; boundary=001a11c138dc1652e6050061dda3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c138dc1652e6050061dda3
Content-Type: text/plain; charset=UTF-8

Hi ,

I  work for Montavista (Cavium Inc) as  a  Technical  Lead .  I want to
push some  of the kernel  patches to  rt community (2.6.32 kernel 2.6.33
rt patch)  , so  that  It  will  go  to  the  main line These patches  are
reviewed  and approved  by  our system Architect.  I request  you to
include  in the main line .  These  issues  were  reported  by our
customer CISCO .

Problem Description:
When CONFIG_DEBUG_PREEMPT is enabled the following stack trace occurs.

[ 170.814470] BUG: using smp_processor_id() in preemptible [00000000]
code: sirq-timer/4/62
[ 170.814482] caller is hrtimer_run_pending+0x10/0x20
[ 170.814488] Call Trace:
[ 170.814496] [<ffffffff8010d844>] dump_stack+0x8/0x34
[ 170.814507] [<ffffffff803c2598>] debug_smp_processor_id+0xe0/0xf0
[ 170.814517] [<ffffffff80254158>] hrtimer_run_pending+0x10/0x20
[ 170.814528] [<ffffffff80242400>] run_timer_softirq+0x60/0x348
[ 170.814539] [<ffffffff8023ae80>] run_ksoftirqd+0x1c8/0x348
[ 170.814550] [<ffffffff802503f8>] kthread+0x88/0x90
[ 170.814561] [<ffffffff80206c80>] kernel_thread_helper+0x10/0x18

Root Cause:
Interrupt was occurring before the processor was completely up, and the
softirq
threads were unable to schedule on the processor and then ran on the wrong
CPU.

How Solved:
Enabling of interrupt has been delayed till smp_finish so that
kthread_bind
can safely bind threads to any possible CPU.

I request you  to merge  the above patch  to the  main line .  If  any
questions please contact me at sshaiju@mvista.com (shaiju_sada@yahoo.com)

Regards,
Shaiju.

--001a11c138dc1652e6050061dda3
Content-Type: application/octet-stream; 
	name="0001-Interrupt-delaying-enabling-of-interrupt.patch"
Content-Disposition: attachment; 
	filename="0001-Interrupt-delaying-enabling-of-interrupt.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: e5a27cff808156cf_0.1

RnJvbSA1ODUxMjQ3NWNiYTkzMDAzYzIzZjJiMzgwYjU3M2U2NGVlYmNhYmQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYWRhc2l2YW4gU2hhaWp1IDxzc2hhaWp1QG12aXN0YS5jb20+
CkRhdGU6IE1vbiwgMjAgRmViIDIwMTIgMTM6MjU6NTAgLTA4MDAKU3ViamVjdDogW1BBVENIXSBJ
bnRlcnJ1cHQgOiBkZWxheWluZyBlbmFibGluZyBvZiBpbnRlcnJ1cHQKClNvdXJjZTogTW9udGFW
aXN0YSBTb2Z0d2FyZSwgTExDCk1SOiA0NzE1NwpUeXBlOiBEZWZlY3QgRml4CkRpc3Bvc2l0aW9u
OiBMb2NhbApDaGFuZ2VJRDogNDhjODM3MzI5NTU2YjE2MWYzMTExZTZmZGVkMWM5ODU3ZmEzYTE0
OQpEZXNjcmlwdGlvbjoKClRoaXMgcGF0Y2ggaXMgdG8gZGVsYXkgdGhlIGVuYWJsaW5nIG9mIGlu
dGVycnVwdCB0aWxsCnNtcF9maW5pc2ggLiBTbyB0aGF0IGt0aHJlYWRfYmluZCBjYW4gc2FmZWx5
IGJpbmQKdGhyZWFkcyB0byBhbnkgcG9zc2libGUgY3B1LiBXaXRob3V0IHRoaXMgY2hhbmdlCmlu
dGVycnVwdCBzaG91bGQgb2NjdXIgYmVvZnJlICB0aGUgIHByb2Nlc3NvciB3YXMKY29tcGxldGVs
eSB1cCwgYW5kICB0aGUgc29mdGlycSB0aHJlYWRzIHdlcmUgdW5hYmxlCnRvIHNjaGVkdWxlIG9u
IHRoZSBwcm9jZXNzb3IgYW5kICB0aGVuICByYW4gb24gdGhlCndyb25nIENQVS4KClNpZ25lZC1v
ZmYtYnk6IFNhZGFzaXZhbiBTaGFpanUgPHNzaGFpanVAbXZpc3RhLmNvbT4KLS0tCiBhcmNoL21p
cHMvY2F2aXVtLW9jdGVvbi9zbXAuYyB8ICAgIDMgKystCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL21pcHMvY2F2aXVt
LW9jdGVvbi9zbXAuYyBiL2FyY2gvbWlwcy9jYXZpdW0tb2N0ZW9uL3NtcC5jCmluZGV4IGZmMjE1
NDIuLmM3ZGU3YWMgMTAwNjQ0Ci0tLSBhL2FyY2gvbWlwcy9jYXZpdW0tb2N0ZW9uL3NtcC5jCisr
KyBiL2FyY2gvbWlwcy9jYXZpdW0tb2N0ZW9uL3NtcC5jCkBAIC0zMDgsNyArMzA4LDYgQEAgc3Rh
dGljIHZvaWQgb2N0ZW9uX2luaXRfc2Vjb25kYXJ5KHZvaWQpCiAJb2N0ZW9uX2luaXRfY3ZtY291
bnQoKTsKIAogCW9jdGVvbl9pcnFfc2V0dXBfc2Vjb25kYXJ5KCk7Ci0JcmF3X2xvY2FsX2lycV9l
bmFibGUoKTsKIH0KIAogLyoqCkBAIC0zNjUsNiArMzY0LDggQEAgc3RhdGljIHZvaWQgb2N0ZW9u
X3NtcF9maW5pc2godm9pZCkKIAogCS8qIHRvIGdlbmVyYXRlIHRoZSBmaXJzdCBDUFUgdGltZXIg
aW50ZXJydXB0ICovCiAJd3JpdGVfYzBfY29tcGFyZShyZWFkX2MwX2NvdW50KCkgKyBtaXBzX2hw
dF9mcmVxdWVuY3kgLyBIWik7CisJLyogZW5hYmxlIGxvY2FsIGludGVycnVwdHMgKi8KKwlyYXdf
bG9jYWxfaXJxX2VuYWJsZSgpOwogfQogCiAvKioKLS0gCjEuNy4wLjEKCg==
--001a11c138dc1652e6050061dda3--
