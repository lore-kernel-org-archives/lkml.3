Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936696Ab3DJM3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:29:46 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:37073 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3DJM3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:29:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130410122826.GD8686@gmail.com>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
	<1365586878.30071.33.camel@laptop>
	<CABPqkBRTaMV9FNmX6qRJAHaO8yTyiqF=EzmeC7Gp7=e-7Bo-gA@mail.gmail.com>
	<1365594552.30071.63.camel@laptop>
	<1365594957.30071.66.camel@laptop>
	<20130410115647.GA8083@gmail.com>
	<CABPqkBQS3ikJWd6yXjjSKdEW3M2pNYzTSs2d56=VTx=aomWUYg@mail.gmail.com>
	<20130410122826.GD8686@gmail.com>
Date: Wed, 10 Apr 2013 14:29:44 +0200
Message-ID: <CABPqkBQ6Nzz91pzshgt1i63tjJ+3QHAuiVgKXd_RQypoeyqx6Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I
 Performance Counters
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jacob Shin <jacob.shin@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86 <x86@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 2:28 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Wed, Apr 10, 2013 at 1:56 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> >> On Wed, 2013-04-10 at 13:49 +0200, Peter Zijlstra wrote:
>> >>
>> >> > Hmm.. the 15h old interface bits got merged? I thought I kept telling
>> >> > that should be done like the intel uncore stuff since the hardware
>> >> > interface wasn't retarded anymore.
>> >>
>> >> Ah well, that crap seems to have slipped in in Feb when I was still a
>> >> near vegetable and not paying much attention.
>> >>
>> >> /me curses a bit.
>> >>
>> >> I don't suppose we can deprecate it and remove this stuff?
>> >
>> > I think we can - if there's a functional replacement.
>> >
>> Does the existing code expose a type in sysfs?
>> If not then you cannot do this transparently, I am afraid
>> because the syntax would be different, i.e., not cpu/...
>
> That could be compatibility-bridged over in tooling?
>
> I doubt these events are in heavy use.
>
I agree.

>> I reviewed the code and tested it. But at the time, I thought
>> you had agreed on the approach used.
>
> I did - but PeterZ has a point, so it would be nice if we could improve on that.
>
I think it is doable by cloning some of the functions into an amd_unc.c file.
