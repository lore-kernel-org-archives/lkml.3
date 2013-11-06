Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab3KFMOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:14:46 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40005 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab3KFMOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:14:45 -0500
Date: Wed, 6 Nov 2013 13:14:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131106121440.GB7919@localhost.localdomain>
References: <874n7w4gtm.fsf@sejong.aot.lge.com>
 <20131101092759.GC27063@gmail.com>
 <87bo1zz4mu.fsf@sejong.aot.lge.com>
 <20131105074650.GA2855@gmail.com>
 <87txfrxlq8.fsf@sejong.aot.lge.com>
 <20131105115802.GA12045@gmail.com>
 <87ppqex8tj.fsf@sejong.aot.lge.com>
 <20131106083046.GA4655@gmail.com>
 <87r4atx51i.fsf@sejong.aot.lge.com>
 <20131106114701.GA20249@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106114701.GA20249@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 12:47:01PM +0100, Ingo Molnar wrote:
> 
> * Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > On Wed, 6 Nov 2013 09:30:46 +0100, Ingo Molnar wrote:
> > > * Namhyung Kim <namhyung@kernel.org> wrote:
> > >
> > >> Hi Ingo,
> > >> 
> > >> On Tue, 5 Nov 2013 12:58:02 +0100, Ingo Molnar wrote:
> > >> > * Namhyung Kim <namhyung@kernel.org> wrote:
> > >> >> But the 'cumulative' (btw, I feel a bit hard to type this word..) is 
> > >> >> different in that it *generates* entries didn't get sampled originally. 
> > >> >> And as it requires callchains, total field will not work if callchains 
> > >> >> are missing.
> > >> >
> > >> > Well, 'total' should disappear if it's not available.
> > >> 
> > >> But what if it's the only sort key user gave?
> > >
> > > Do you mean something like:
> > >
> > >   -F self,name -s total
> > >
> > > i.e. if a sort key not displayed?
> > 
> > What I worry is when no -F option was given at all.
> 
> In that case the default list applied, plus whatever new fields are 
> mentioned in -s would also be added (appended or prepended).
> 
> The display order of columns should _probably_ be something like:
> 
>   key1 key2 ... non-key1 non-key2
> 
> there's not much point in sorting and then displaying the key not in 
> front, right?
> 
> > > I think sort keys should be automatically added to the displayed 
> > > fields list.
> > 
> > Agreed.
> 
> > > This problem should be solved if all -s fields are displayed - i.e. 
> > > they are added to the -F list, right?
> > 
> > But old users might not aware of the new -F option, and use -s option 
> > only.  If so, she will get output like the first example, right?
> 
> Well, there's a default -F list that applies - so this shouldn't be a 
> problem, agreed? So output should be like the second (expected) example.
> 
> > > Basically there's just a single concept: the -F list. The -s option 
> > > simply modifies and extends the -F list but internally perf report 
> > > would not know anything about '-s', it only knows about fields to 
> > > display and it would know which of those fields are to be sorted and 
> > > in what order.
> > >
> > > Does that make sense to you? Does it cover everything needed?
> > 
> > I like the concept.  I'm just looking for a way to add it without 
> > upsetting old users. :)
> 
> If the default -F list matches our current displayed fields list then 
> there should not be much change in behavior (beyond the addition of total 
> for call-graph outputs - which can be kept completely separate).
> 
> I'm not too worried about call-graph 'legacies': it generates such huge 
> perf.data files which is parsed so slowly at the moment that there's very 
> little user base ... Anyone who absolutely needs call-graph profiling uses 
> SysProf which performs well.

I'm a bit confused by what will be changed with call-graph here. Also I've
seen perf callgraph reports quite often on emails not even related to perf
developement. It doesn't appear to me like an irrelevant feature...
