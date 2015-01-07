Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbbAGNbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:31:43 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54828 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbAGNbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:31:41 -0500
MIME-Version: 1.0
In-Reply-To: <20150107081009.GE6243@krava.brq.redhat.com>
References: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
 <1419656793-32756-5-git-send-email-namhyung@kernel.org> <20150104182656.GC29388@krava.brq.redhat.com>
 <20150107074706.GF849@sejong> <20150107081009.GE6243@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 7 Jan 2015 22:31:19 +0900
X-Google-Sender-Auth: JmskDP6bnG-pwfvE_XxT1F2IuaE
Message-ID: <CAM9d7ci5TN+-AqetxgeLdiUNUX=Wet_awapWAkTr3O71ynTtfg@mail.gmail.com>
Subject: Re: [PATCH 5/5] perf diff: Fix -o/--order option behavior
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 5:10 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Jan 07, 2015 at 04:47:06PM +0900, Namhyung Kim wrote:
>> On Sun, Jan 04, 2015 at 07:26:56PM +0100, Jiri Olsa wrote:
>> > On Sat, Dec 27, 2014 at 02:06:33PM +0900, Namhyung Kim wrote:
>> >
>> > SNIP
>> >
>> > > +         return 0;
>> > > +
>> > > + fmt = zalloc(sizeof(*fmt));
>> > > + if (fmt == NULL) {
>> > > +         pr_err("Memory allocation failed\n");
>> > > +         return -1;
>> > > + }
>> > > +
>> > > + fmt->cmp      = hist_entry__cmp_nop;
>> > > + fmt->collapse = hist_entry__cmp_nop;
>> > > +
>> > > + switch (compute) {
>> > > + case COMPUTE_DELTA:
>> > > +         fmt->sort = hist_entry__cmp_delta_idx;
>> > > +         break;
>> > > + case COMPUTE_RATIO:
>> > > +         fmt->sort = hist_entry__cmp_ratio_idx;
>> > > +         break;
>> > > + case COMPUTE_WEIGHTED_DIFF:
>> > > +         fmt->sort = hist_entry__cmp_wdiff_idx;
>> > > +         break;
>> > > + default:
>> > > +         BUG_ON(1);
>> > > + }
>> > > +
>> > > + list_add(&fmt->sort_list, &perf_hpp__sort_list);
>> > > + return 0;
>> >
>> > so the first 'fmt' which gets to sorting is the one for
>> > data__files[sort_idx] file, that sounds good..
>> >
>> > but as the sorting goes through all the perf_hpp__sort_list list,
>> > it will hit the 'sort_idx' data again.. should you disable sort
>> > function for its 'fmt' then?
>>
>> Do you really think it's needed?
>>
>> Yes, it'll be called twice but I think it's a relatively rare case as
>> most entries will be sorted by the sort_idx and baseline columns.
>
> I did not think it through completely.. thats why I asked ;-)
>
> but I think you're right and it's not a big deal, maybe just
> add some comment that this is happening and we dont think
> it's too bad.. or something like that ;-)

OK, I'll add the comment.

Thanks,
Namhyung
