Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab3GCGo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 02:44:27 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:35751 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3GCGo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 02:44:26 -0400
MIME-Version: 1.0
In-Reply-To: <51D27CC6.1050209@intel.com>
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
	<1372319707-13892-13-git-send-email-adrian.hunter@intel.com>
	<51CC6AAF.4030404@gmail.com>
	<51D14CB6.206@intel.com>
	<51D1D043.5030509@gmail.com>
	<51D27CC6.1050209@intel.com>
Date: Wed, 3 Jul 2013 08:44:25 +0200
Message-ID: <CABPqkBQar4SKq_A+=ShdjJgYfxW90yuD=M=WQ2HjFwR_bKxKkg@mail.gmail.com>
Subject: Re: [PATCH V2 12/15] perf tools: allow non-matching sample types
From: Stephane Eranian <eranian@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 9:09 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 01/07/13 21:53, David Ahern wrote:
>> On 7/1/13 3:32 AM, Adrian Hunter wrote:
>>> Snip
>>>
>>>>
>>>> While this works for a combined S/W and tracepoint events session, I do not
>>>> like promoting sample types to the minimum compatible level for all events
>>>> in the session. perf needs to allow each event to have its own sample_type
>>>> and not force a minimal compatibility.
>>>
>>> Why?  The impact is small. The kernel API is completely unchanged.
>>
>> I'd like to see libperf become a stable, usable library - usable by more
>> than the perf binary and its builtin commands. I have already done this once
>> for a daemon, and it was a PITA to get the specific use functional without
>> memory leaks/growth in the libperf part.
>>
>> With respect to this specific patch it means appropriate flexibility in the
>> data collected for events. ie., each event can have its own sample_type. For
>> example if the tracepoint already contains task information TID is not
>> needed - and IP may not be wanted either. The code processing the samples
>> should not require all events to have some minimum data format - that just
>> wastes buffer space.
>
> It would be more compelling to provide a use-case where that "waste"
> actually makes any difference.
>
In my opinion, it's not so much of the "wasted" space than on the ease of use
for tools. With your change, tools would have to know something about the order
in which sample_type is laid out. And it just happens that it is not
as trivial as
expected. It is NOT the bit position order in sample_type. So this is more error
prone.

I prefer your IDENTIFIER solution better, yet it also implies that this flag is
special. It provides the event ID at the first position in the sample's body.
