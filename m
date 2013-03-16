Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3CPWGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 18:06:16 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56449 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3CPWGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 18:06:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwHRAiaFBZdwoYMVAUKrT7XPi99JKNMjjROFAKhgw8=4A@mail.gmail.com>
References: <20130315132607.GA4565@quad>
	<CAOULuObGX24KK+i88WT1PSN4_o3zFYuyyyZAcQPXqm-3xGrW0g@mail.gmail.com>
	<CA+55aFwHRAiaFBZdwoYMVAUKrT7XPi99JKNMjjROFAKhgw8=4A@mail.gmail.com>
Date: Sat, 16 Mar 2013 18:06:13 -0400
Message-ID: <CAOULuOZ2Bx4ispxc9Jro27TfhFTsrsz90mokOHBRpbqGDXDFqw@mail.gmail.com>
Subject: Re: [PATCH] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
From: Parag Warudkar <parag.lkml@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Eranian <eranian@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 1:56 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Mar 16, 2013 at 9:11 AM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>>
>> This seems to trigger a WARN_ON during suspend/resume.
>
> Ugh, yes. It's practically harmless, but it's ugly and technically
> wrong (we're using wrmsr_on_cpu() on our current cpu, but in a context
> where using it on anything else would be horribly broken).
>
> I think the attached patch should fix it. UNTESTED!

Applied and that seems to have suppressed the warning.

Unrelated to this now it dies in intel_pstate_timer_func doing what
seems to be a divide by zero.

Hopefully I will be able to capture the oops on camera next time.

Thanks,
Parag
