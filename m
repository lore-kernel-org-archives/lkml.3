Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbbAHFVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 00:21:37 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52213 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbbAHFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 00:21:35 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 8 Jan 2015 14:19:33 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC/PATCHSET 00/37] perf tools: Speed-up perf report by using
 multi thread (v1)
Message-ID: <20150108051933.GB7268@sejong>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <20150105184811.GQ2915@two.firstfloor.org>
 <CABPqkBQ_mcMr=mfaFoECm6YFWvgz3JWudQ4wdT2Q61yJZOok1w@mail.gmail.com>
 <20150107071323.GC849@sejong>
 <CABPqkBTamwaC_rueabTkuYpwZNycvejrULSFGQ7npna2gNQwLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBTamwaC_rueabTkuYpwZNycvejrULSFGQ7npna2gNQwLg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 10:14:56AM -0500, Stephane Eranian wrote:
> On Wed, Jan 7, 2015 at 2:13 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> > Hi Stephane,
> >
> > On Tue, Jan 06, 2015 at 10:50:44AM -0500, Stephane Eranian wrote:
> >> We use the pipe mode a lot and this would not work there. So no,
> >> I don't like the 2 files solution. But I like the idea of using multiple
> >> threads to speed up processing.
> >
> > Actually it's not 2 files, it's 1 + N files. :)  Anyway, I think the
> > single file + index approach requires seeking to process them, is it
> > ok for pipe-mode?
> >
> There is no seek possible in pipe mode.
> 
> The way this is done (as I remember) is by creating pseudo-record types
> and injecting them in the stream.

Right.  But I have no idea how I can index a live stream and process
it using multiple threads.

Thanks,
Namhyung
