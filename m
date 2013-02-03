Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3BCUhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 15:37:20 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40387 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3BCUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 15:37:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130129080305.GB594@gmail.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
	<1359230650-10415-2-git-send-email-jolsa@redhat.com>
	<CABPqkBSH=67hG8VRwHPU3byEancpVqsyetHkSjb4nOScPvcnFA@mail.gmail.com>
	<CABPqkBTPHKf+XTmeyA8PrWReG8Ak6ow9gSwfh4ozK+gvJMze1w@mail.gmail.com>
	<20130129080305.GB594@gmail.com>
Date: Sun, 3 Feb 2013 21:37:16 +0100
Message-ID: <CABPqkBSVnbt1pthyW2au1Wnpvvf+8Acf2MjCwNLf8Hvw88j4Aw@mail.gmail.com>
Subject: Re: [PATCH 1/8] perf tools: Add '.' as part of the event 'name' token
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 9:03 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Mon, Jan 28, 2013 at 9:52 PM, Stephane Eranian <eranian@google.com> wrote:
>> > Jiri,
>> >
>> > I don't see part 0/8 of this series. Did you send it to me too?
>> >
>> > I have some comments about it. I don't see why create something from scratch
>> > when I have been developing a library (libpfm4) that takes care of that and that
>> > is already used by many tool developers. That library can be linked with perf
>> > and provide full symbolic events + all the modifiers. The library is portable
>> > and supports all existing archs. It can also be used by self-monitoring apps.
>> >
>> >
>> > You're introducing yet another event table to maintain. And believe me this is
>> > a lot of work to maintain this.
>> >
>> > I don't understand why not use this existing library.
>> >
>>
>> I meant to add that I think it would be more productive if we
>> (you and I) were to work on the library to extend it with
>> external text-based event tables that could be used by perf
>> either directly or thru the libpfm4 interface.
>
> perf is intentionally external file free and does not
> (fundamentally) depend on external libraries either,
> other than core system libraries.
>
Perf does use external files, otherwise there would not be
a need for what's in libexec.

As far as I know, perf is constantly adding dependencies
to other libraries. For instance, nowadays, it does not compile
if you don't have libnuma, libdw, and the likes. libpfm4 is similar
in nature.

The goal of the library is to provide access to event table in a
portable manner for tools and self-monitoring programs (on which they
are many). Users don't have to have to change event names, event
modifier syntax when they go from one tool to another. Or even
when they switch from one OS to another. That's what libpfm4
provides and the scope goes beyond the perf tool.



> There are several advantages to that:
>
>  - there is no version skew and no design/maintenance friction
>
There is rarely an version problem with event tables.

>  - 'upgrading' perf between similar boxes is as simple as
>    copying the perf binary
>
Not quite.

>  - it's self-sufficient
>
>  - there's no real advantage of external text files versus
>    internal text files (i.e. text tables within the source
>    code), while there are several disadvantages
>
libpfm4 currently has the tables internally hardcoded.

> So as long as Jiri is happy to maintain these tables I think
> it's a superior solution (even if the tables start out
> incomplete), from the perf project's perspective.
>
Adding the option for users to link with libpfm4 was no big
deal in my mind. You are opposed to that. That's your
choice. I don't buy your arguments for this patch series
and will continue to provide a patch to link perf and libpfm4
for users who are interested.

I would have appreciated some discussion on this instead, once
again, work was done behind closed door and thrown at my face.
The worst being that as far I can see in the patches, no proper
credits to libpfm4 contributors is even given for providing the raw
information that allowed you to  build your event tables without too
much sweat! Building electronic event tables from vendor specs is
a lot harder than it seems, but you may not know this.
