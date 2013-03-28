Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3C1PPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:15:53 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:60767 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3C1PPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:15:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130328151248.GB13795@infradead.org>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
	<1359040242-8269-12-git-send-email-eranian@google.com>
	<20130327141425.GC1092@krava.brq.redhat.com>
	<1364394014.5053.76.camel@laptop>
	<20130327143437.GE1092@krava.brq.redhat.com>
	<CABPqkBSSBdzGJtJ6HLFCM_Hhnwv1ASZ=JCX+zpWcM5X3KwZk6w@mail.gmail.com>
	<20130327165644.GB14744@infradead.org>
	<CABPqkBQESorC6U6kZOjntdgsnwTkT4GiT669mVHw6Wuf_JqDbQ@mail.gmail.com>
	<20130328150018.GA13795@infradead.org>
	<20130328151248.GB13795@infradead.org>
Date: Thu, 28 Mar 2013 16:15:51 +0100
Message-ID: <CABPqkBQ=d7Go5smbvDXZn_3nsZaU4M0fZCnt2Ds683r5=JSg2Q@mail.gmail.com>
Subject: Re: [PATCH v7 11/18] perf tools: add mem access sampling core support
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 4:12 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Thu, Mar 28, 2013 at 12:00:18PM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Thu, Mar 28, 2013 at 03:24:30PM +0100, Stephane Eranian escreveu:
>> > On Wed, Mar 27, 2013 at 5:56 PM, Arnaldo Carvalho de Melo
>> > > Stephane, if you could give it a try again to see that the fixups I did
>> > > (documented in the commit logs, just before my Signed-off-by) are ok,
>> > > that would be good.
>>
>> > I tried on a few examples on both NHM (only loads, no TLB) and SNB
>> > and got the right answers for my tests, including data symbol resolution.
>>
>> > What we discussed with Jiri yesterday can be added later on.
>>
>> > Thanks for the integration work. Looks good to me.
>>
>> Humm, I just tried it with a simple:
>>
>> perf mem -t load rec
>>
>> And got an OOPS, trying again, and this machine was suspended, perhaps
>> perf/core doesn't have that PEBS fix, will check.
>
> Yeah, after a fresh reboot it doesn't OOPses, the fix:
>
> commit 1d9d8639c063caf6efc2447f5f26aa637f844ff6
> Author: Stephane Eranian <eranian@google.com>
> Date:   Fri Mar 15 14:26:07 2013 +0100
>
>     perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
>
Okay, so you too fell into that trap! I mean laptop guys, trying to save
battery, yet running perf, c'mon... ;->

> --------
>
> Isn't in perf/core, cool, before your test results I thougt I had messed
> up something :-)
>
yeah, closed your laptop lid.....
Should work better with the suspend/resume fix now, hopefully.
Of course, on SNB systems, you also need that firmware patch
to enable PEBS, IIRC.
