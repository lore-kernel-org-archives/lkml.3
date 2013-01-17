Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab3AQBDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:03:37 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57164 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3AQBDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:03:36 -0500
X-AuditID: 9c930179-b7b54ae000000e44-60-50f74de5dfc7
From: Namhyung Kim <namhyung@kernel.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 0/4] perf tool: Adding ratios support
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
	<CAOPLpQeHTCwr4tuHi0nORCn+LKJRzEGoCWhC-rj30nLe7bY5Nw@mail.gmail.com>
	<20130116142549.GD1042@krava.brq.redhat.com>
	<CAOPLpQcohbB7tekbaezTkKaLVWKaZgMjR-YjCTKxQnix2+pn=A@mail.gmail.com>
Date: Thu, 17 Jan 2013 10:03:32 +0900
In-Reply-To: <CAOPLpQcohbB7tekbaezTkKaLVWKaZgMjR-YjCTKxQnix2+pn=A@mail.gmail.com>
	(Ulrich Drepper's message of "Wed, 16 Jan 2013 10:12:14 -0500")
Message-ID: <87pq14lixn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 16 Jan 2013 10:12:14 -0500, Ulrich Drepper wrote:
> On Wed, Jan 16, 2013 at 9:25 AM, Jiri Olsa <jolsa@redhat.com> wrote:
>> I was thinking having config files (global and arch specific)
>> comming with perf having predefined formulas.
>
> All the more reason to not mention the file name or really any source
> for the definition of the formula in the name,
>
>
>> 1)  -e 'ratio/branch-rate/'  # special event class
>> 2)  -e 'ratio-branch-rate'   # 'ratio-' prefix
>> 3)  -e cpu/branch-rate/      # handled like aliases, ratio name would need to be unique
>>   ... ?
>
> I think 3 is the most extensible.  Perhaps use the syntax used in
> other places.  We have these :u suffixes etc.  Perhaps have :r or :R
> or whatever.

I don't think it's a good idea.  The ':r' syntax is for modifiers to the
existing events so it doesn't match to this case IMHO.

I prefer a special event class like 1 since it's possible to include
non-cpu events to a ratio/formular.  In that case, using 'cpu' in the
PMU name can be misleading.

>
> Given the other comments, we might want to avoid right away "ratio".
> If the mechanism is generalized it could be used to express "counter1
> - counter2" for events which cannot be expressed with a single counter
> but are not really ratios.

Agreed.  Looks like "formular" is better.

Thanks,
Namhyung
