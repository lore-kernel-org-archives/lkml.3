Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaBKLvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:51:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51800 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaBKLvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:51:43 -0500
Date: Tue, 11 Feb 2014 12:51:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Richard Fowles <fowles@inreach.com>
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140211115135.GE3104@twins.programming.kicks-ass.net>
References: <20140211071401.GG27965@twins.programming.kicks-ass.net>
 <CABPqkBRn+AVUA-KTx-JQ28j1NhE4pDQe5vjb5NKGx0jrZq8g_Q@mail.gmail.com>
 <20140211105217.GS9987@twins.programming.kicks-ass.net>
 <CABPqkBROriDQa5-b-w45zV+2gS94oEW1c_bYwGmYAeYcqPoUog@mail.gmail.com>
 <20140211110242.GU9987@twins.programming.kicks-ass.net>
 <CABPqkBQhUCUOszQzBJZd_pwX-nLf6y=0X-+swPi0pE3ivRpVcg@mail.gmail.com>
 <CABPqkBSbBqOtvstKwQWD7jM8nn3XEdq0OXMjW8Z8oCF17uRYPw@mail.gmail.com>
 <20140211111421.GN27965@twins.programming.kicks-ass.net>
 <CABPqkBRw4W9=ORuhAJpx4L0pCt8iBKshhR5Qv5cLvcD5vR2eRA@mail.gmail.com>
 <20140211113149.GW9987@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211113149.GW9987@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 12:31:49PM +0100, Peter Zijlstra wrote:
> On Tue, Feb 11, 2014 at 12:28:47PM +0100, Stephane Eranian wrote:
> > On Tue, Feb 11, 2014 at 12:14 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, Feb 11, 2014 at 12:08:56PM +0100, Stephane Eranian wrote:
> > >> Assuming you can decode and get the info about the base registers used,
> > >> you'd have to do this for each arch with load/store sampling capabilities.
> > >> this is painful compared to getting the portable info from dwarf directly.
> > >
> > > But its useful now, as compared to whenever GCC gets around to
> > > implementing more dwarves and that GCC getting used widely enough to
> > > actually rely on it.
> > >
> > > All you need for the decode is a disassembler, and every arch should
> > > already have multiple of those. Should be easy to reuse one, right?
> > 
> > I know, and you want to pull this into the perf tool?
> 
> Sure why not, its already got the world and then some :/
> 
> It would be just another dynamic lib.

The added benefit is that we could get rid of the objdump usage for
annotate if we find a usable disasm lib. At which point we can start
improving the annotations with these variable/type information as well.


