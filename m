Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbaCSASW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:18:22 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:53379 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbaCSASV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:18:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140318200837.GG6482@ghostprotocols.net>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
 <1394437440-11609-4-git-send-email-namhyung@kernel.org> <20140318200837.GG6482@ghostprotocols.net>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 19 Mar 2014 00:18:00 +0000
X-Google-Sender-Auth: 1thtoEDd1oK9f_UcQnnlE9ekpG0
Message-ID: <CAM9d7cgkpFr7z+CXwYxaPJtssr6CRA7uX-Z6tpLAQ2qoic4FOg@mail.gmail.com>
Subject: Re: [PATCH 3/9] perf hists: Add support for showing relative percentage
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, Mar 18, 2014 at 8:08 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Mon, Mar 10, 2014 at 04:43:54PM +0900, Namhyung Kim escreveu:
>> @@ -695,12 +695,17 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
>>       if (h->filtered)
>>               return;
>>
>> -     ++hists->nr_entries;
>> -     if (h->ms.unfolded)
>> +     hists->nr_entries++;
>> +     hists->nr_non_filtered_entries++;
>
> Why not keep existing practice? prefix or suffix generates the same
> code, changing it from prefix to suffix increment just adds noise to the
> patch :-\

Argh, sorry - I couldn't resist changing it.  Won't do that in the future. :-/

>
> Also, this is why I was asking about nr_entries and total_period being
> invariant, looking at this function we can see it is _not_ invariant, as
> when we apply/remove filters we touch them.
>
> This is why I made the comment (in a private conversation) about having
> a invariant_total_period invariant_nr_entries pair (I think I used some
> other naming) while knowing that the existing variables nr_entries and
> total_period are actually subjected to the filters being used.
>
> I.e. to avoid confusion we need to make total_entries and nr_entries
> never change when a filter is applied, touching only two new variables
> for non_filtered total_period and nr_entries.
>
> I'll try doing it if you don't do it first, but will first process some
> more patches and submit what I already processed.

Please see the next patch 4/9 ("perf report: Add --percentage option")
doing that.  What I did in this patch is just adding new
non_filtered_* fields and not changing existing behavior.  And in the
next patch, the total_period and nr_entries will become invariant.

Do you want to split the patch 4/9 or merge a part of it into this?

Thanks,
Namhyung
