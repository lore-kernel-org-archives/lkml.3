Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab3JOQiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:38:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32934 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955Ab3JOQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:38:19 -0400
Date: Tue, 15 Oct 2013 18:37:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record: mmap output file
Message-ID: <20131015163707.GA10341@dyad.arnhem.chello.nl>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
 <1381289214-24885-4-git-send-email-dsahern@gmail.com>
 <20131009055957.GA7664@gmail.com>
 <525D4B5F.4090005@gmail.com>
 <20131015143245.GB9828@ghostprotocols.net>
 <20131015143819.GM10651@twins.programming.kicks-ass.net>
 <20131015152747.GA15979@gmail.com>
 <525D5FA1.7060404@gmail.com>
 <20131015160646.GC16003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015160646.GC16003@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 06:06:46PM +0200, Ingo Molnar wrote:
> 
> splice() is very fast and should be able to process a lot of pages in one 
> go, so the feedback loop should be pretty weak. mmap() triggers kernel 
> code as well, every time we run out of the 64 MB window we got to remap 
> it, right?
> 
> But that's all just theory - I think non-temporal stores have a pretty 
> good chance of being a very good solution as well.

The first write to a fresh page will also cause kernel code to be ran. We fault
and run mk_write, which will end up doing block allocation etc..
