Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab3AQQFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:05:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824Ab3AQQFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:05:46 -0500
Date: Thu, 17 Jan 2013 17:05:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ulrich Drepper <drepper@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 0/4] perf tool: Adding ratios support
Message-ID: <20130117160516.GA4724@krava.brq.redhat.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
 <CAOPLpQeHTCwr4tuHi0nORCn+LKJRzEGoCWhC-rj30nLe7bY5Nw@mail.gmail.com>
 <20130116142549.GD1042@krava.brq.redhat.com>
 <CAOPLpQcohbB7tekbaezTkKaLVWKaZgMjR-YjCTKxQnix2+pn=A@mail.gmail.com>
 <87pq14lixn.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq14lixn.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:03:32AM +0900, Namhyung Kim wrote:
> Hi,
> 
> On Wed, 16 Jan 2013 10:12:14 -0500, Ulrich Drepper wrote:
> > On Wed, Jan 16, 2013 at 9:25 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> >> I was thinking having config files (global and arch specific)
> >> comming with perf having predefined formulas.
> >
> > All the more reason to not mention the file name or really any source
> > for the definition of the formula in the name,
> >
> >
> >> 1)  -e 'ratio/branch-rate/'  # special event class
> >> 2)  -e 'ratio-branch-rate'   # 'ratio-' prefix
> >> 3)  -e cpu/branch-rate/      # handled like aliases, ratio name would need to be unique
> >>   ... ?
> >
> > I think 3 is the most extensible.  Perhaps use the syntax used in
> > other places.  We have these :u suffixes etc.  Perhaps have :r or :R
> > or whatever.
> 
> I don't think it's a good idea.  The ':r' syntax is for modifiers to the
> existing events so it doesn't match to this case IMHO.
> 
> I prefer a special event class like 1 since it's possible to include
> non-cpu events to a ratio/formular.  In that case, using 'cpu' in the
> PMU name can be misleading.
> 
> >
> > Given the other comments, we might want to avoid right away "ratio".
> > If the mechanism is generalized it could be used to express "counter1
> > - counter2" for events which cannot be expressed with a single counter
> > but are not really ratios.
> 
> Agreed.  Looks like "formular" is better.

agreed, I think I wouldn't touch modifiers for this
also, 'ratio' is not good choice, formula seems better

jirka
