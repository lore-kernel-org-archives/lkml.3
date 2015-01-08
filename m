Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbbAHOwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:52:14 -0500
Received: from one.firstfloor.org ([193.170.194.197]:33669 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbbAHOwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:52:12 -0500
Date: Thu, 8 Jan 2015 15:52:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC/PATCHSET 00/37] perf tools: Speed-up perf report by using
 multi thread (v1)
Message-ID: <20150108145210.GY2915@two.firstfloor.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <20150105184811.GQ2915@two.firstfloor.org>
 <20150107065849.GB849@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107065849.GB849@sejong>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Isn't it fast enough to have a single thread that pre scans
> > the events (perhaps with some single-thread optimizations
> > like vectorization), and then load balances the work to
> > a thread pool?
> 
> I don't understand it.  Could you please elaborate it?

Have a thread pool. Then there is a single thread which pre-processes
events and puts them into queues, which are then processed in parallel
by the threads in the thread pool.


-Andi
