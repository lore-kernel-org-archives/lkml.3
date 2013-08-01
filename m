Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3HACdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:33:14 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:51673 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3HACdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:33:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130731142405.GB3008@twins.programming.kicks-ass.net>
References: <1375218838-31042-1-git-send-email-adrian.hunter@intel.com>
 <1375218838-31042-2-git-send-email-adrian.hunter@intel.com>
 <20130731141732.GD3614@ghostprotocols.net> <20130731142405.GB3008@twins.programming.kicks-ass.net>
From: Namhyung Kim <namhyung@gmail.com>
Date: Thu, 1 Aug 2013 11:32:52 +0900
Message-ID: <CAM9d7chP-MqyU+Yc0sxHVtcHT4tN6xF75yS8aT6VBFgfad6z2g@mail.gmail.com>
Subject: Re: [PATCH V2 1/9] perf tools: add test for reading object code
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Jul 31, 2013 at 11:24 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jul 31, 2013 at 11:17:32AM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Wed, Jul 31, 2013 at 12:13:50AM +0300, Adrian Hunter escreveu:
>> > Using the information in mmap events, perf tools can read object
>> > code associated with sampled addresses.  A test is added that
>> > compares bytes read by perf with the same bytes read using
>> > objdump.
>>
>> So this parses objdump output, and we also already have the annotation
>> logic that does that too, have you thought about having common routines
>> for these two cases?
>>
>
> Or better yet, stop using objdump like this and start using libbfd
> directly. The only reason we did horrible things like parsing objdump
> output is because nobody knew how the underlying stuff actually worked
> and we wanted to have something quick.

I have similar patch for getting srcline info (using addr2line) based
on Roberto Vitillo's patch.  I'll send the series soon and then look
at the objdump too.


-- 
Thanks,
Namhyung Kim
