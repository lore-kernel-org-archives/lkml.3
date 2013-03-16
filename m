Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3CPR42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 13:56:28 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:49478 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3CPR41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 13:56:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAOULuObGX24KK+i88WT1PSN4_o3zFYuyyyZAcQPXqm-3xGrW0g@mail.gmail.com>
References: <20130315132607.GA4565@quad>
	<CAOULuObGX24KK+i88WT1PSN4_o3zFYuyyyZAcQPXqm-3xGrW0g@mail.gmail.com>
Date: Sat, 16 Mar 2013 10:56:26 -0700
X-Google-Sender-Auth: B2kBJGHZW3eNKM22zxrl6_RY6QQ
Message-ID: <CA+55aFwHRAiaFBZdwoYMVAUKrT7XPi99JKNMjjROFAKhgw8=4A@mail.gmail.com>
Subject: Re: [PATCH] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Stephane Eranian <eranian@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: multipart/mixed; boundary=089e013cc38684342904d80e790f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013cc38684342904d80e790f
Content-Type: text/plain; charset=UTF-8

On Sat, Mar 16, 2013 at 9:11 AM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>
> This seems to trigger a WARN_ON during suspend/resume.

Ugh, yes. It's practically harmless, but it's ugly and technically
wrong (we're using wrmsr_on_cpu() on our current cpu, but in a context
where using it on anything else would be horribly broken).

I think the attached patch should fix it. UNTESTED!

                  Linus

--089e013cc38684342904d80e790f
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hed2u35j0

IGFyY2gveDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVudF9pbnRlbF9kcy5jIHwgNCArKystCiAxIGZp
bGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50X2ludGVsX2RzLmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L3BlcmZfZXZlbnRfaW50ZWxfZHMuYwppbmRleCAwZTliZGQzY2IwMWUuLmIwNWE1NzVk
NTZmNCAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50X2ludGVsX2Rz
LmMKKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50X2ludGVsX2RzLmMKQEAgLTcz
Miw4ICs3MzIsMTAgQEAgdm9pZCBpbnRlbF9kc19pbml0KHZvaWQpCiAKIHZvaWQgcGVyZl9yZXN0
b3JlX2RlYnVnX3N0b3JlKHZvaWQpCiB7CisJc3RydWN0IGRlYnVnX3N0b3JlICpkcyA9IF9fdGhp
c19jcHVfcmVhZChjcHVfaHdfZXZlbnRzLmRzKTsKKwogCWlmICgheDg2X3BtdS5idHMgJiYgIXg4
Nl9wbXUucGVicykKIAkJcmV0dXJuOwogCi0JaW5pdF9kZWJ1Z19zdG9yZV9vbl9jcHUoc21wX3By
b2Nlc3Nvcl9pZCgpKTsKKwl3cm1zcmwoTVNSX0lBMzJfRFNfQVJFQSwgKHVuc2lnbmVkIGxvbmcp
ZHMpOwogfQo=
--089e013cc38684342904d80e790f--
