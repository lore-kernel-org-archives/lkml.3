Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaFXFyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 01:54:11 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:42951 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFXFyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 01:54:09 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        mitake@dcl.info.waseda.ac.jp, Aswin Chandramouleeswaran <aswin@hp.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] perf bench: Add --repeat option
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
	<1402942467-10671-2-git-send-email-davidlohr@hp.com>
	<877g4d8lye.fsf@sejong.aot.lge.com>
	<1403178338.20417.6.camel@buesod1.americas.hpqcorp.net>
	<CAM9d7cgPhffEX3-AKnXtzgxeT_21hPBjWDsAT1LPu6S=T9VZ_A@mail.gmail.com>
	<1403233437.1581.5.camel@buesod1.americas.hpqcorp.net>
Date: Tue, 24 Jun 2014 14:54:07 +0900
In-Reply-To: <1403233437.1581.5.camel@buesod1.americas.hpqcorp.net> (Davidlohr
	Bueso's message of "Thu, 19 Jun 2014 20:03:57 -0700")
Message-ID: <87a9927szk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On Thu, 19 Jun 2014 20:03:57 -0700, Davidlohr Bueso wrote:
> On Thu, 2014-06-19 at 23:51 +0000, Namhyung Kim wrote:
>> Hi Davidlohr,
>> 
>> On Thu, Jun 19, 2014 at 11:45 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> > Hi Namhyung,
>> >
>> > On Thu, 2014-06-19 at 15:14 +0900, Namhyung Kim wrote:
>> >> By adding a top-level option, I think it should be applied to all
>> >> benchmaks - but I guess it only supports sched messaging and futex,
>> >> right?
>> >
>> > Yes, for now only those. While there is opportunity for others to use it
>> > as well (perhaps shed-pipe & memcpy/memset), I don't think *all*
>> > benchmarks need multiple runs, ie: numa.
>> 
>> Hmm.. but it'd make users confusing if one runs the numa benchmark
>> with -r 5 option but it only do a single run..
>
> Yeah, it crossed my mind. For that to be addressed, we would have to
> come up with a way to determine if the argument was passed, and just
> inform the user that it is not [currently(?)] supported. Some
> alternatives would be to (i) explicitly document it, and/or (ii) print
> out the amount of runs that will be made and if that option is
> supported. All in all I think we need a better infrastructure for such
> things. 

I think we don't need to prevent users if she really wants to run a
benchmark multiple times.  So how about supporting it for all benchmarks
but providing sane per-benchmark defaults (i.e. 1 for numa, 5 for sched)?

Thanks,
Namhyung
