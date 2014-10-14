Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaJNOCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:02:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:57634 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375AbaJNOCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:02:30 -0400
Date: Tue, 14 Oct 2014 11:02:23 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jean Pihet <jean.pihet@linaro.org>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141014140223.GC3198@kernel.org>
References: <20141006212606.GF14113@kernel.org>
 <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
 <20141007133236.GG14113@kernel.org>
 <20141007140433.GG30146@pd.tnic>
 <20141010200708.GB18775@kernel.org>
 <20141010202854.GC13017@pd.tnic>
 <20141010204158.GA13834@kernel.org>
 <20141010204432.GD13017@pd.tnic>
 <CAFrcx1nm4pqWPsUtj1h5qQqo6dghiafRM60-9asaYXx7NLqAEQ@mail.gmail.com>
 <20141014135631.GA32308@krava.fdxtended.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014135631.GA32308@krava.fdxtended.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 14, 2014 at 03:56:31PM +0200, Jiri Olsa escreveu:
> On Mon, Oct 13, 2014 at 09:29:57AM +0200, Jean Pihet wrote:
> > On 10 October 2014 22:44, Borislav Petkov <bp@alien8.de> wrote:
> > > On Fri, Oct 10, 2014 at 05:41:58PM -0300, Arnaldo Carvalho de Melo wrote:
> > >> That way we just make public the bare minimum that already proved to be
> > >> useful outside tools/perf/ and over time we move stuff from
> > >> tools/perf/util/evsel.c (and from other tools in or out perf's repo)
> > >> into the lib.
> > That is great!

> > About rasd usage, there are some details at
> > https://wiki.linaro.org/LEG/Engineering/Kernel/perfAndRAS#rasd_implementation.
 
> sorry for late reply.. I was on vacation last week..
 
> I read the rasd sources and realized we could poke this
> from another angle..  AFAIU the work the rasd does is following:
>    - reads config file and opens configured tracepoints
>    - reads samples comming from those tracepoints and displays/writes
>      this data to the console/file
>    - is there more?
 
> If I'm not missing anything, this is quite usefull/common usage
> pattern which would deserve new perf command.
 
> I can see the analogy with ftrace debugfs interface
>   - choose/enable tracepoints
>   - cat .../tracing/trace-pipe
 
> and there could be '-d' for the command to act as daemon.

Right, this is to be integrated into 'trace', i.e. to be able to ask for
more events, some with callchains, some without, etc.

We may even have something really bare bones that does what rasd.c does
right now, to show how one can write a tool using the exported
interfaces in tools/lib/api/, but I think that what rasd is _right now_,
is just an attempt to use the libraries using as few as possible apis,
right? I.e. more "meat" will be added there, no?

Anyway, its beeing an interesting exercise and will result in a lot of
untanglement, which is good in any case.

- Arnaldo
