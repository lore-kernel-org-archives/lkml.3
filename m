Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbbAGHbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:31:10 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59127 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbbAGHa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:30:56 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 7 Jan 2015 16:28:50 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 6/7] perf tools: Append callchains only when requested
Message-ID: <20150107072850.GD849@sejong>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
 <1419223455-4362-7-git-send-email-namhyung@kernel.org>
 <20150103022504.GB24430@kernel.org>
 <CAM9d7ciu4dVKv+mT3fHPE=BdBfLXdU+6zD9STVEkzxET2REUuQ@mail.gmail.com>
 <20150105124924.GA2587@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150105124924.GA2587@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, Jan 05, 2015 at 09:49:24AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sun, Jan 04, 2015 at 12:01:26AM +0900, Namhyung Kim escreveu:
> > On Sat, Jan 3, 2015 at 11:25 AM, Arnaldo Carvalho de Melo
> > <acme@kernel.org> wrote:
> > > Em Mon, Dec 22, 2014 at 01:44:14PM +0900, Namhyung Kim escreveu:
> > >> The perf report --children can be called with callchain disabled so no
> > >> need to append callchains.  Actually the root of callchain tree is not
> > >> initialized properly in this case.
> 
> > >         I should have caught this using 'perf test', but it slipped
> > > thru, please try running 'perf test cumulation', I noticed that it fails
> > > and that if I revert this changeset it works again, can you please
> > > check?
>  
> > This change should not affect the test result, but I guess the test
> > somehow relied on the undefined behavior.  Actually I posted a patch
> > to fix this problem.  So please take a look at the link below:
>  
> > https://lkml.org/lkml/2014/12/22/561
> 
> Ok, missed this one, will get it on perf/urgent and look if there are
> patches pending merging in that pull req.

Could please consider applying it below:

https://lkml.org/lkml/2014/12/24/13

Thanks,
Namhyung
