Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3AWRZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:25:07 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:56314 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab3AWRZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:25:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130123171351.GZ30577@one.firstfloor.org>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
	<1358455012-12287-17-git-send-email-andi@firstfloor.org>
	<CABPqkBQNXUfC9VwyZAA-OyhKJ6JL8Sr__Rq=sZPAzSL6cP+E6Q@mail.gmail.com>
	<CABPqkBT+wKBKVt30OJ4mhMGGq1711r51tdWsxyyHAmEy3rYfyw@mail.gmail.com>
	<CABPqkBSBWsx50Pupc5nh6yqvkgLBa4BSCQN==6=SPp1Z_iQUYA@mail.gmail.com>
	<20130123171351.GZ30577@one.firstfloor.org>
Date: Wed, 23 Jan 2013 18:25:04 +0100
Message-ID: <CABPqkBQvh5R32mxvLsaN2+YmBhxcoRmUYUZeQju4kBDnHB4s5A@mail.gmail.com>
Subject: Re: [PATCH 16/29] perf, tools: Add support for weight v7
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 6:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> For PEBS-LL and possibly other special cases, it is important to remember
>> that perf report always end up sorting by period (hist_collapse_resort). But
>> for PEBS-LL we want to sort on nr_events * weight. Thus, with your patch,
>> the only way, I found, to achieve this is by passing:
>>
>>        add_hist_entry(self, &entry, al, weight, weight);
>
> Seems like a hack. IMHO it should always sort by all the keys
> i specified with --sort in exactly that order I specified
>
Well, it does except for the "implicit" column which uses period, see
hists__collapse_resort().
And that function is hardcoded to only look at period.

As for the hack, I did not put in in my hist__add_mem_entry() but
rather in the caller.
For PEBS-LL, the period is not important. I think it counts the number
of loads/stores
and not just the qualifying ones. For loads, that means it counts all
loads and not just
the ones above the threshold, but I may be wrong.

> I had a similar thing in a really old version of my patches,
> but I gave it up because it was too unintuitive.
>
Well, but then it does not present a sensible view of the samples when weight is
more important than period.

> -Andi
