Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaBMNDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:03:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbaBMNDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:03:06 -0500
Date: Thu, 13 Feb 2014 14:02:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Don Zickus <dzickus@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Joe Mario <jmario@redhat.com>,
        Richard Fowles <fowles@inreach.com>
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140213130228.GB2908@krava.brq.redhat.com>
References: <CABPqkBRzvfcdKGG4yY9q1PmtVL5Z=9H1RzHg8QDMN42a7=AF6A@mail.gmail.com>
 <20140211071401.GG27965@twins.programming.kicks-ass.net>
 <CABPqkBRn+AVUA-KTx-JQ28j1NhE4pDQe5vjb5NKGx0jrZq8g_Q@mail.gmail.com>
 <20140211105217.GS9987@twins.programming.kicks-ass.net>
 <CABPqkBROriDQa5-b-w45zV+2gS94oEW1c_bYwGmYAeYcqPoUog@mail.gmail.com>
 <20140211110242.GU9987@twins.programming.kicks-ass.net>
 <CABPqkBQhUCUOszQzBJZd_pwX-nLf6y=0X-+swPi0pE3ivRpVcg@mail.gmail.com>
 <CABPqkBSbBqOtvstKwQWD7jM8nn3XEdq0OXMjW8Z8oCF17uRYPw@mail.gmail.com>
 <20140211111421.GN27965@twins.programming.kicks-ass.net>
 <20140211115013.GE28757@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211115013.GE28757@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 08:50:13AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Feb 11, 2014 at 12:14:21PM +0100, Peter Zijlstra escreveu:
> > On Tue, Feb 11, 2014 at 12:08:56PM +0100, Stephane Eranian wrote:
> > > Assuming you can decode and get the info about the base registers used,
> > > you'd have to do this for each arch with load/store sampling capabilities.
> > > this is painful compared to getting the portable info from dwarf directly.
>  
> > But its useful now, as compared to whenever GCC gets around to
> > implementing more dwarves and that GCC getting used widely enough to
> > actually rely on it.
>  
> > All you need for the decode is a disassembler, and every arch should
> > already have multiple of those. Should be easy to reuse one, right?
> 
> Yeah, I never got around to actually try to implement this, but my
> feeling was that all the bits and pieces were there already:
> 
> 1) the precise IP for the instruction, that disassembled would tell
> which registers were being operated on, or memory that we would "reverse
> map" to a register
> 
> 2) DWARF expression locations that allows us to go from registers to a
> variable/parameter and thus to a type
> 
> 3) PERF_SAMPLE_REGS_USER (from a quick look, why do we have "USER" in
> it? Jiri?)

well, it was meant for store user registers only
to assists user DWARF unwind

we can add PERF_SAMPLE_REGS_KERNEL

> 
> 4) libunwind have register maps for various arches, so probably
> something there could be reused here as well (Jiri?)

not sure what you mean by 'something' here.. but yep,
libunwind does have register maps for various arches

jirka
