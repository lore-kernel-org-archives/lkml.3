Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaJCIKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaJCIJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:09:57 -0400
Date: Fri, 3 Oct 2014 10:09:20 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [BUG] perf tools: off-by-one error in map_groups__find_ams()
Message-ID: <20141003080920.GE19087@krava.brq.redhat.com>
References: <CABPqkBQPjpgD_5n0ZMmx971+YO86CO+5mSfcg7a1p4Ys_TgOUA@mail.gmail.com>
 <20141002083635.GF9764@krava.brq.redhat.com>
 <CABPqkBRrBttsL6maPCjXuQXhCmEYLWVYVpmQaMYihXcRy2k_-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRrBttsL6maPCjXuQXhCmEYLWVYVpmQaMYihXcRy2k_-g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 06:40:14PM +0200, Stephane Eranian wrote:
> On Thu, Oct 2, 2014 at 10:36 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Wed, Oct 01, 2014 at 09:16:31PM +0200, Stephane Eranian wrote:
> >> Hi,
> >>
> >> It appears that there is a off-by-one bug in map_groups__find_ams().
> >> The upper-bound check in the test below should be >= because
> >> end = start + len; The end address is outside the range.
> >>
> >> Please confirm.
> >>
> >>
> >> int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
> >> {
> >>                 if (ams->addr < ams->map->start || ams->addr > ams->map->end) {
> >
> > yep, looks like bug to me
> >
> Are you providing a fix or should I?

please go ahead

jirka
