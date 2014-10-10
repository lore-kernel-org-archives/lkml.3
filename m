Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaJJLBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:01:03 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44833 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaJJLBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:01:02 -0400
Message-ID: <5437BC67.2010700@gmail.com>
Date: Fri, 10 Oct 2014 19:00:55 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@arm.com>, Kirill V Tkhai <tkhai@yandex.ru>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/deadline: do not try to push tasks if pinned task
 switches to dl
References: <1412908997-15396-1-git-send-email-wanpeng.li@linux.intel.com> <20141010101016.GJ10832@worktop.programming.kicks-ass.net> <5437B462.4050102@gmail.com> <20141010105614.GA3343@worktop.programming.kicks-ass.net>
In-Reply-To: <20141010105614.GA3343@worktop.programming.kicks-ass.net>
Content-Type: multipart/mixed;
 boundary="------------020907010901020206010006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020907010901020206010006
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


于 10/10/14, 6:56 PM, Peter Zijlstra 写道:
> On Fri, Oct 10, 2014 at 06:26:42PM +0800, Wanpeng Li wrote:
>> 于 10/10/14, 6:10 PM, Peter Zijlstra 写道:
>>> On Fri, Oct 10, 2014 at 10:43:17AM +0800, Wanpeng Li wrote:
>>>> As Kirill mentioned(https://lkml.org/lkml/2013/1/29/118):
>>>> | If rq has already had 2 or more pushable tasks and we try to add a
>>>> | pinned task then call of push_rt_task will just waste a time.
>>>>
>>>> Just switched pinned task is not able to be pushed. If the rq had had
>>>> several dl tasks before they have already been considered as candidates
>>>> to be pushed (or pulled). This patch does the same behavior as rt class
>>>> which introduced by commit 104479 (sched/rt: Do not try to push tasks
>>>> if pinned task switches to RT).
>>> Checkpatch rightly complains:
>>>
>>> ERROR: Please use 12 or more chars for the git commit ID like: 'commit 10447917551e ("sched/rt: Do not try to push tasks if pinned task switches to RT")'
>>> #12:
>>> which introduced by commit 104479 (sched/rt: Do not try to push tasks
>> I also got this warning before send out the patch, however, I check 6 chars
>> is enough for this commit. Anyway, I will send a newer version later.
> It is currently, it might not be in the future. I've already had hash
> collisions with 8 char hashes. And the fact thats it in the changelog
> means it can (and therefore) will be referenced at some point in the
> future. If by that point there is a collision...

Got it, thanks for your pointing out.

Regards,
Wanpeng Li


--------------020907010901020206010006
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-sched-deadline-do-not-try-to-push-tasks-if-pinned-ta.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-sched-deadline-do-not-try-to-push-tasks-if-pinned-ta.pa";
 filename*1="tch"

RnJvbSAyNDc0NjAyMzg0MTQ3NDQxMTkyNjVkNmFhOTJmNGJmMDA2YjA2MGFhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBXYW5wZW5nIExpIDx3YW5wZW5nLmxpQGxpbnV4Lmlu
dGVsLmNvbT4KRGF0ZTogRnJpLCAxMCBPY3QgMjAxNCAxMDowOTozNyArMDgwMApTdWJqZWN0
OiBbUEFUQ0ggdjJdIHNjaGVkL2RlYWRsaW5lOiBkbyBub3QgdHJ5IHRvIHB1c2ggdGFza3Mg
aWYgcGlubmVkIHRhc2sgc3dpdGNoZXMgdG8gZGwKCkFzIEtpcmlsbCBtZW50aW9uZWQoaHR0
cHM6Ly9sa21sLm9yZy9sa21sLzIwMTMvMS8yOS8xMTgpOgp8IElmIHJxIGhhcyBhbHJlYWR5
IGhhZCAyIG9yIG1vcmUgcHVzaGFibGUgdGFza3MgYW5kIHdlIHRyeSB0byBhZGQgYSAKfCBw
aW5uZWQgdGFzayB0aGVuIGNhbGwgb2YgcHVzaF9ydF90YXNrIHdpbGwganVzdCB3YXN0ZSBh
IHRpbWUuCgpKdXN0IHN3aXRjaGVkIHBpbm5lZCB0YXNrIGlzIG5vdCBhYmxlIHRvIGJlIHB1
c2hlZC4gSWYgdGhlIHJxIGhhZCBoYWQKc2V2ZXJhbCBkbCB0YXNrcyBiZWZvcmUgdGhleSBo
YXZlIGFscmVhZHkgYmVlbiBjb25zaWRlcmVkIGFzIGNhbmRpZGF0ZXMKdG8gYmUgcHVzaGVk
IChvciBwdWxsZWQpLiBUaGlzIHBhdGNoIGRvbmUgdGhlIHNhbWUgYmVoYXZpb3IgYXMgcnQg
Y2xhc3MgCndoaWNoIGludHJvZHVjZWQgYnkgY29tbWl0IDEwNDQ3OTE3NTUxZSAoInNjaGVk
L3J0OiBEbyBub3QgdHJ5IHRvIHB1c2ggCnRhc2tzIGlmIHBpbm5lZCB0YXNrIHN3aXRjaGVz
IHRvIFJUIikuIAoKU2lnbmVkLW9mZi1ieTogV2FucGVuZyBMaSA8d2FucGVuZy5saUBsaW51
eC5pbnRlbC5jb20+Ci0tLQp2MSAtPiB2MjoKICogdXNlIDEyIG9yIG1vcmUgY2hhcnMgZm9y
IHRoZSBnaXQgY29tbWl0IElECgoga2VybmVsL3NjaGVkL2RlYWRsaW5lLmMgfCAzICsrLQog
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAt
LWdpdCBhL2tlcm5lbC9zY2hlZC9kZWFkbGluZS5jIGIva2VybmVsL3NjaGVkL2RlYWRsaW5l
LmMKaW5kZXggYWJmYWYzZC4uY2Y3YzliNiAxMDA2NDQKLS0tIGEva2VybmVsL3NjaGVkL2Rl
YWRsaW5lLmMKKysrIGIva2VybmVsL3NjaGVkL2RlYWRsaW5lLmMKQEAgLTE2MDMsNyArMTYw
Myw4IEBAIHN0YXRpYyB2b2lkIHN3aXRjaGVkX3RvX2RsKHN0cnVjdCBycSAqcnEsIHN0cnVj
dCB0YXNrX3N0cnVjdCAqcCkKIAogCWlmICh0YXNrX29uX3JxX3F1ZXVlZChwKSAmJiBycS0+
Y3VyciAhPSBwKSB7CiAjaWZkZWYgQ09ORklHX1NNUAotCQlpZiAocnEtPmRsLm92ZXJsb2Fk
ZWQgJiYgcHVzaF9kbF90YXNrKHJxKSAmJiBycSAhPSB0YXNrX3JxKHApKQorCQlpZiAocC0+
bnJfY3B1c19hbGxvd2VkID4gMSAmJiBycS0+ZGwub3ZlcmxvYWRlZAorCQkJCSYmIHB1c2hf
ZGxfdGFzayhycSkgJiYgcnEgIT0gdGFza19ycShwKSkKIAkJCS8qIE9ubHkgcmVzY2hlZHVs
ZSBpZiBwdXNoaW5nIGZhaWxlZCAqLwogCQkJY2hlY2tfcmVzY2hlZCA9IDA7CiAjZW5kaWYg
LyogQ09ORklHX1NNUCAqLwotLSAKMS45LjEKCg==
--------------020907010901020206010006--
