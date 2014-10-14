Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbaJNN46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:56:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbaJNN45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:56:57 -0400
Date: Tue, 14 Oct 2014 15:56:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141014135631.GA32308@krava.fdxtended.com>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006212606.GF14113@kernel.org>
 <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
 <20141007133236.GG14113@kernel.org>
 <20141007140433.GG30146@pd.tnic>
 <20141010200708.GB18775@kernel.org>
 <20141010202854.GC13017@pd.tnic>
 <20141010204158.GA13834@kernel.org>
 <20141010204432.GD13017@pd.tnic>
 <CAFrcx1nm4pqWPsUtj1h5qQqo6dghiafRM60-9asaYXx7NLqAEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1nm4pqWPsUtj1h5qQqo6dghiafRM60-9asaYXx7NLqAEQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 09:29:57AM +0200, Jean Pihet wrote:
> Hi Arnaldo, Borislav,
> 
> On 10 October 2014 22:44, Borislav Petkov <bp@alien8.de> wrote:
> > On Fri, Oct 10, 2014 at 05:41:58PM -0300, Arnaldo Carvalho de Melo wrote:
> >> Right, stoopid me, no need for some specific tracepoint, just to see
> >> that whatever tp it is, it will show up in "rasd"'s event loop. Ok, I'll
> >> try that later.
> >>
> >> Next stuff I probably will do is to move the bare minimum used by rasd
> >> to tools/lib/api/perf/, i.e. there will be:
> >>
> >> tools/lib/api/perf/evsel.c
> >> tools/perf/util/evsel.c
> >>
> >> Both will share the perf_evsel__ namespace (which I thought at some
> >> point to make just: evsel__<METHOD_NAME>, wdyt?).
> Makes perfectly sense
> 
> >>
> >> That way we just make public the bare minimum that already proved to be
> >> useful outside tools/perf/ and over time we move stuff from
> >> tools/perf/util/evsel.c (and from other tools in or out perf's repo)
> >> into the lib.
> That is great!
> 
> About rasd usage, there are some details at
> https://wiki.linaro.org/LEG/Engineering/Kernel/perfAndRAS#rasd_implementation.

heya,
sorry for late reply.. I was on vacation last week..

I read the rasd sources and realized we could poke this
from another angle..  AFAIU the work the rasd does is following:
   - reads config file and opens configured tracepoints
   - reads samples comming from those tracepoints and displays/writes
     this data to the console/file
   - is there more?

If I'm not missing anything, this is quite usefull/common usage
pattern which would deserve new perf command.

I can see the analogy with ftrace debugfs interface
  - choose/enable tracepoints
  - cat .../tracing/trace-pipe

and there could be '-d' for the command to act as daemon.

thoughts? ;-)

jirka
