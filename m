Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaFESAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:00:25 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:44339 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaFESAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:00:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140605165213.GI16642@pd.tnic>
References: <CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
	<CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
	<CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
	<CABPqkBTEafZ5MbYM4UQxX92uWcPiphPeXMoJRKTt8jnrB+5j2w@mail.gmail.com>
	<20140605132750.GA16811@pd.tnic>
	<CABPqkBT9ExD4unz0VZ5G1d+oGpkepiwXskgBpv5GTavs=tYAKA@mail.gmail.com>
	<20140605140316.GB16811@pd.tnic>
	<CAHzUATiVCHytrG3sz8AmC8anZTQcPDRHp91-kWEoeq=RU7UNiw@mail.gmail.com>
	<20140605151734.GD16811@pd.tnic>
	<CAHzUATioT8e=RxypbqBsHw-QkcYsdQEiKhb3e44A4S+98Ut6=Q@mail.gmail.com>
	<20140605165213.GI16642@pd.tnic>
Date: Thu, 5 Jun 2014 21:00:23 +0300
Message-ID: <CAHzUATiOi0_U4r+TN_okYh_5_VB-NpW+A5qgg6Vkz9kyrwqZug@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>,
        Matt Fleming <matt@console-pimps.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 7:52 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jun 05, 2014 at 07:39:55PM +0300, Maria Dimakopoulou wrote:
>> This series aims to avoid corruption of non-corrupting events.
>> Re-integration of the counts is not related to this.
>
> What do you mean "not related"? Then you have a partial workaround. This
> whole thing is trying to fix a hw bug so of course it is related.

I said not related to the problem of corruption of non-corrupting events which
we solve here.
Re-integration of the counts of corrupting events is a different problem.
Both problems are related to HT bug.

>
> Once you do the "full" workaround, along with the part which
> reintegrates the counts and thus completely fixes the issue (I believe),
> then you don't need to disable it at all because disabling it doesn't
> make any sense then. See what I'm saying?
>
> This is the whole point Matt and I are trying to make: if the *full*
> workaround doesn't have any noticeable disadvantages, then you don't
> need to add a disable-mechanism due to the can of worms opening if you
> do.
>

As Stephane pointed out, the sysfs entry is optional and the workaround
can be disabled only as root.

It is not absolutely necessary and it's not important.
We will drop it in V2.

> How you get this upstream to ease the review is a whole another story
> and I applaud your desire to keep things clean.
>

Then, I guess we agree to keep the re-integration for another series for
the reason you just pointed.


> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
