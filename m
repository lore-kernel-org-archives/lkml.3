Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaC1OyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 10:54:13 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:65210 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaC1OyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 10:54:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130827123827.GB5855@x1.alien8.de>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
	<20130824093826.GB28383@pd.tnic>
	<20130827122721.GF15884@rric.localhost>
	<20130827123827.GB5855@x1.alien8.de>
Date: Fri, 28 Mar 2014 15:54:11 +0100
Message-ID: <CAFrcx1kdVQmNETtUoLJNdtMbzZ4bPSxHq8R-PwOdd=vEu6L9Zw@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] perf, persistent: Add persistent events
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now that the feature is resurfacing, I would like to take over the
task for persistent events.
What is the status of the series, is it close to acceptance?

AFAICS the patch RFC 12/12 was under discussion, mainly about the
naming of the ioctls (latest e-mail is in favor of CLAIM/UNCLAIM).

Any thoughts?

Let me rebase the code against the latest mainline and re-start the discussion.

Thread: https://lkml.org/lkml/2013/8/22/306
RFC 12/12: https://lkml.org/lkml/2013/8/27/264

Regards,
Jean

On 27 August 2013 14:38, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Aug 27, 2013 at 02:27:21PM +0200, Robert Richter wrote:
>> > > There are ioctl functions to control persistent events that can be
>> > > used to detach or attach an event to or from a process. The
>> > > PERF_EVENT_IOC_DETACH ioctl call makes an event persistent.
>> >
>> > Yeah, we probably want to abstract this a step further by allowing
>> > to attach/detach fds to/from events. Then "persistent" is only one
>> > incarnation of us always detaching from the event during its lifetime.
>> >
>> > If we close an event while it is attached, it gets destroyed - i.e.,
>> > current functionality, etc. See the other thread.
>>
>> I don't know what you mean here exactly, please explain.
>
> Basically that detaching an event shouldn't make it persistent
> explicitly - it simply continues running in the background. When we
> reattach to it and die with the event attached, then it gets destroyed
> too.
>
> Which means, we can have arbitrary life periods of events, persistency
> being only a special case of it.
>
> IOW, as long as an event is detached in the background, it counts.
> When something attaches to it and that something exits, the event gets
> destroyed too, as part of the process teardown.
>
> And this is probably the most generic way to look at it.
>
> --
> Regards/Gruss,
> Boris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
