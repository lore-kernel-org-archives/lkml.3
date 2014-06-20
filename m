Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbaFTDEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 23:04:07 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:51714 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaFTDEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 23:04:06 -0400
Message-ID: <1403233437.1581.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/9] perf bench: Add --repeat option
From: Davidlohr Bueso <davidlohr@hp.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        mitake@dcl.info.waseda.ac.jp, Aswin Chandramouleeswaran <aswin@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 19 Jun 2014 20:03:57 -0700
In-Reply-To: <CAM9d7cgPhffEX3-AKnXtzgxeT_21hPBjWDsAT1LPu6S=T9VZ_A@mail.gmail.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
	 <1402942467-10671-2-git-send-email-davidlohr@hp.com>
	 <877g4d8lye.fsf@sejong.aot.lge.com>
	 <1403178338.20417.6.camel@buesod1.americas.hpqcorp.net>
	 <CAM9d7cgPhffEX3-AKnXtzgxeT_21hPBjWDsAT1LPu6S=T9VZ_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 23:51 +0000, Namhyung Kim wrote:
> Hi Davidlohr,
> 
> On Thu, Jun 19, 2014 at 11:45 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > Hi Namhyung,
> >
> > On Thu, 2014-06-19 at 15:14 +0900, Namhyung Kim wrote:
> >> By adding a top-level option, I think it should be applied to all
> >> benchmaks - but I guess it only supports sched messaging and futex,
> >> right?
> >
> > Yes, for now only those. While there is opportunity for others to use it
> > as well (perhaps shed-pipe & memcpy/memset), I don't think *all*
> > benchmarks need multiple runs, ie: numa.
> 
> Hmm.. but it'd make users confusing if one runs the numa benchmark
> with -r 5 option but it only do a single run..

Yeah, it crossed my mind. For that to be addressed, we would have to
come up with a way to determine if the argument was passed, and just
inform the user that it is not [currently(?)] supported. Some
alternatives would be to (i) explicitly document it, and/or (ii) print
out the amount of runs that will be made and if that option is
supported. All in all I think we need a better infrastructure for such
things. 

I feel perf-bench suffers fundamental design issues and tries to cover
too much.

Thanks,
Davidlohr

