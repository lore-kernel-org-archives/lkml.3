Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaETCWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:22:42 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:55766 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaETCWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:22:41 -0400
MIME-Version: 1.0
In-Reply-To: <1400507671.1742.4.camel@leonhard>
References: <1400480762-22852-1-git-send-email-namhyung@kernel.org>
 <1400480762-22852-7-git-send-email-namhyung@kernel.org> <20140519131257.GC20810@krava.brq.redhat.com>
 <1400507671.1742.4.camel@leonhard>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 20 May 2014 02:22:21 +0000
X-Google-Sender-Auth: -FU6OKEH5jiSaVimHBg1U8bPicE
Message-ID: <CAM9d7cjocpy-rgKhOR=RHo0_oUC36UycEv5SmSP2t3Ty8Pozwg@mail.gmail.com>
Subject: Re: [PATCH 06/20] perf tools: Consolidate output field handling to
 hpp format routines
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

I updated my -v6 branch to fix the breakage - move the hunk to 15/20.
Do you want me to resend or would you review with this thread
directly?  Either way would be find to me.

Thanks,
Namhyung


On Mon, May 19, 2014 at 1:54 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> 2014-05-19 (월), 15:12 +0200, Jiri Olsa:
>> On Mon, May 19, 2014 at 03:25:48PM +0900, Namhyung Kim wrote:
>>
>> SNIP
>>
>> > @@ -1104,27 +1104,35 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
>> >                                    struct hist_entry *he, FILE *fp)
>> >  {
>> >     char s[8192];
>> > -   double percent;
>> >     int printed = 0;
>> >     char folded_sign = ' ';
>> > +   struct perf_hpp hpp = {
>> > +           .buf = s,
>> > +           .size = sizeof(s),
>> > +   };
>> > +   struct perf_hpp_fmt *fmt;
>> > +   bool first = true;
>> > +   int ret;
>> >
>> >     if (symbol_conf.use_callchain)
>> >             folded_sign = hist_entry__folded(he);
>> >
>> > -   hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
>> > -   percent = (he->stat.period * 100.0) / browser->hists->stats.total_period;
>> > -
>> >     if (symbol_conf.use_callchain)
>> >             printed += fprintf(fp, "%c ", folded_sign);
>> >
>> > -   printed += fprintf(fp, " %5.2f%%", percent);
>> > -
>> > -   if (symbol_conf.show_nr_samples)
>> > -           printed += fprintf(fp, " %11u", he->stat.nr_events);
>> > +   perf_hpp__for_each_format(fmt) {
>> > +           if (perf_hpp__should_skip(fmt))
>> > +                   continue;
>>
>> this one is defined in later patch, so it breaks build in this one
>
> Argh, right.  This one came from a later fixup with interactive rebase
> and missed test..  I'll fix and resend, sorry about that.
>
> Thanks,
> Namhyung
