Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaJNRKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:10:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:36386 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaJNRKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:10:03 -0400
Date: Tue, 14 Oct 2014 14:09:57 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Jean Pihet <jean.pihet@linaro.org>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141014170957.GD3198@kernel.org>
References: <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
 <20141007133236.GG14113@kernel.org>
 <20141007140433.GG30146@pd.tnic>
 <20141010200708.GB18775@kernel.org>
 <20141010202854.GC13017@pd.tnic>
 <20141010204158.GA13834@kernel.org>
 <20141010204432.GD13017@pd.tnic>
 <CAFrcx1nm4pqWPsUtj1h5qQqo6dghiafRM60-9asaYXx7NLqAEQ@mail.gmail.com>
 <20141014135631.GA32308@krava.fdxtended.com>
 <543D3108.5080401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543D3108.5080401@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 14, 2014 at 08:19:52AM -0600, David Ahern escreveu:
> On 10/14/14, 7:56 AM, Jiri Olsa wrote:
> >I read the rasd sources and realized we could poke this
> >from another angle..  AFAIU the work the rasd does is following:
> >    - reads config file and opens configured tracepoints
> >    - reads samples comming from those tracepoints and displays/writes
> >      this data to the console/file
> >    - is there more?
> >
> >If I'm not missing anything, this is quite usefull/common usage
> >pattern which would deserve new perf command.
> >
> >I can see the analogy with ftrace debugfs interface
> >   - choose/enable tracepoints
> >   - cat .../tracing/trace-pipe
> >
> >and there could be '-d' for the command to act as daemon.
> 
> Yes, this parallels a new use case on my end. Right now I am running perf
> record ... | perf script. With the tracepoints and filters involved it is a
> LOT of typing - and still collects more than is needed (I don't need MMAP
> events for example, only COMM events). I am leaning towards a new perf
> sub-command but from my scheduling timehist and daemon commands I know there
> is a lot of overhead that goes with that. A perf library with a stable API
> would make this a lot easier. (AFAIK the python bindings do not currently
> support opening events, it is mainly an analysis option.)

Yeah, please take a look at this branch:

https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=perf/hists

Trying to use the rasd.c opportunity to go over the boilerplate to
diminish it by having defaults for syswide tracing, etc.

I'm now working on moving the most minimalistic set of evsel.c/evlist.c
into tools/lib/api/perf/

- Arnaldo
