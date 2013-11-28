Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662Ab3K1UC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:02:28 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:53060 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759639Ab3K1UCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 15:02:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131128134642.GB12292@ghostprotocols.net>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
	<1385583394-3703-35-git-send-email-acme@infradead.org>
	<20131127224323.GB1350@krava.redhat.com>
	<20131128095801.GA1245@krava.brq.redhat.com>
	<20131128125619.GA12292@ghostprotocols.net>
	<20131128134642.GB12292@ghostprotocols.net>
Date: Thu, 28 Nov 2013 21:02:23 +0100
Message-ID: <CAFrcx1mr0AYdNJ04jSVV+y0KfHSF13Qx1BnpdUb++1bvhH2f0g@mail.gmail.com>
Subject: Re: [PATCH 34/34] perf tools unwinding: Use the per-feature check flags
From: Jean Pihet <jean.pihet@linaro.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 November 2013 14:46, Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> Em Thu, Nov 28, 2013 at 09:56:19AM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Thu, Nov 28, 2013 at 10:58:01AM +0100, Jiri Olsa escreveu:
>> > On Wed, Nov 27, 2013 at 11:43:23PM +0100, Jiri Olsa wrote:
>> > > On Wed, Nov 27, 2013 at 05:16:34PM -0300, Arnaldo Carvalho de Melo wrote:
>> > >   LINK     perf
>> > > /bin/ld: cannot find -lunwind
>> > > /bin/ld: cannot find -lunwind-x86_64
>> > > collect2: error: ld returned 1 exit status
>> > > make[1]: *** [perf] Error 1
>> > > make[1]: *** Waiting for unfinished jobs....
>> > > make: *** [all] Error 2
>>
>> > > I haven't checked this one.. will do tomorrow
>>
>> > we need to plug libunwind flags/libs only if
>> > the $(feature-libunwind) is enabled..
>>
>> > NO_LIBUNWIND - user's decision not to link with libunwind or
>> >                architecture that does not support it
>>
>> > $(feature-libunwind) - if it's actually installed
>>
>> > attached change fixies that for me, feel free to use/merge it
>>
>> Argh, I used tests/make on one machine where those two patches by Jean
>> were not applied, then rebased on another, the one I use to submit,
>> those got included but not tests/make tested, which probably explains
>> why this got thru :-\
>>
>> Jean, can you please check that this works for you on ARM too?
>
> I just noticed that this patch breaks the feature detection mechanism,
> after it is applied it is back performing all tests at every make call,
> this needs rethinking, so I'm dropping both.
Oh I am sorry about that. I tested on ARM with and without the
LIBUNWIND_DIR option set.
Let me rethink/rework this and come back to you with a proper fix.

>
> Ingo, please disregard, yet again, my latest pull request, sigh.
>
> Jiri, this could be something for tests/make, till then I'll try
> to check this manually.

One question though: are you OK with the principle of having
per-feature check flags? This brings two things to the feature
detection and build:
1. the ability to specify specific flags for the feature check, which
is not possible on the current code,
2. a simplification in the Makefiles.

Jean

>
> - Arnaldo
