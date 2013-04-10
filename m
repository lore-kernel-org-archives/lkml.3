Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965232Ab3DJLwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:52:34 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:44166 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965218Ab3DJLw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:52:29 -0400
MIME-Version: 1.0
In-Reply-To: <1365594552.30071.63.camel@laptop>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
	<1365586878.30071.33.camel@laptop>
	<CABPqkBRTaMV9FNmX6qRJAHaO8yTyiqF=EzmeC7Gp7=e-7Bo-gA@mail.gmail.com>
	<1365594552.30071.63.camel@laptop>
Date: Wed, 10 Apr 2013 13:52:28 +0200
Message-ID: <CABPqkBTZaEBfKRjVmSBo5+d7E56P622y4xFnV760NgVjLdYZNw@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I
 Performance Counters
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86 <x86@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 1:49 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2013-04-10 at 13:38 +0200, Stephane Eranian wrote:
>> On Wed, Apr 10, 2013 at 11:41 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> >
>> > On Tue, 2013-04-09 at 10:23 -0500, Jacob Shin wrote:
>> > > Upcoming AMD Family 16h Processors provide 4 new performance counters
>> > > to count L2 related events. Similar to northbridge counters, these new
>> > > counters are shared across multiple CPUs that share the same L2 cache.
>> > > This patchset adds support for these new counters and enforces sharing
>> > > by leveraging the existing sharing logic used for the northbridge
>> > > counters.
>> >
>> > If they're separate counters -- not shared with the regular cpu
>> > counters like the 10h NB counters are, then they should have their own
>> > PMU driver.
>> >
>> > Similar to the 15h NB counters; which are a separate set of counters
>> > and no longer overlay the normal counters.
>> >
>> Well, that's how this was suggested but that's not how it's
>> implemented currently
>> and committed if I recall.
>
> Hmm.. the 15h old interface bits got merged? I thought I kept telling
> that should be done like the intel uncore stuff since the hardware
> interface wasn't retarded anymore.
>
I remember. I agreed with you on this. I don't recall the details as to
why Robert did not like that but I think it had to do with code duplication
from the perf_event_amd.c.
