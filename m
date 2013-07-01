Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3GATKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:10:41 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:43986 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3GATKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <51D1D043.5030509@gmail.com>
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
	<1372319707-13892-13-git-send-email-adrian.hunter@intel.com>
	<51CC6AAF.4030404@gmail.com>
	<51D14CB6.206@intel.com>
	<51D1D043.5030509@gmail.com>
Date: Mon, 1 Jul 2013 21:10:38 +0200
Message-ID: <CABPqkBRJNcSi_qdmn9Bfw57MbX=RcaSC9RLt-u6FKfW+q5jM0A@mail.gmail.com>
Subject: Re: [PATCH V2 12/15] perf tools: allow non-matching sample types
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 8:53 PM, David Ahern <dsahern@gmail.com> wrote:
>
> On 7/1/13 3:32 AM, Adrian Hunter wrote:
>>
>> Snip
>>
>>>
>>> While this works for a combined S/W and tracepoint events session, I do not
>>> like promoting sample types to the minimum compatible level for all events
>>> in the session. perf needs to allow each event to have its own sample_type
>>> and not force a minimal compatibility.
>>
>>
>> Why?  The impact is small. The kernel API is completely unchanged.
>
>
> I'd like to see libperf become a stable, usable library - usable by more than the perf binary and its builtin commands. I have already done this once for a daemon, and it was a PITA to get the specific use functional without memory leaks/growth in the libperf part.
>
> With respect to this specific patch it means appropriate flexibility in the data collected for events. ie., each event can have its own sample_type. For example if the tracepoint already contains task information TID is not needed - and IP may not be wanted either. The code processing the samples should not require all events to have some minimum data format - that just wastes buffer space.
>
I agree. This kernel needs to allow for any bit combination on
sample_type and yet provide enough info
to parse the buffer in the case of multi-event sampling. This is
kernel bug. Tools should not have to handle
this. Because it'd have to be repeated for each tool.

Later this week, I'll post a patch that address the kernel limitation.
