Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3IXRQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:16:33 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:50329 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3IXRQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:16:32 -0400
Date: Tue, 24 Sep 2013 14:16:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] perf trace: Add mmap2 handler
Message-ID: <20130924171626.GC2634@ghostprotocols.net>
References: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
 <1379900700-5186-4-git-send-email-dsahern@gmail.com>
 <5240DB4D.100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5240DB4D.100@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 23, 2013 at 06:22:37PM -0600, David Ahern escreveu:
> Arnaldo:
> 
> I see this is you perf core tree; the problem exists in Linus' tree
> so it is needed in your urgent tree as well.

Sure, reproduced the segfault, cherry picked this patch from perf/core,
segfault fixes, thanks.

- Arnaldo
 
> David
> 
> On 9/22/13 7:44 PM, David Ahern wrote:
> >5c5e854b changed perf_event__synthesize_mmap_events to generate MMAP2
> >events. Since perf-trace does not have a handler for it it dies with a
> >segfault when trying to process files:
> >
> >perf trace -i /tmp/perf.data
> >Segmentation fault
> >
> >Signed-off-by: David Ahern <dsahern@gmail.com>
> >---
> >  tools/perf/builtin-trace.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> >diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> >index 9c7f017..f61c968 100644
> >--- a/tools/perf/builtin-trace.c
> >+++ b/tools/perf/builtin-trace.c
> >@@ -1383,6 +1383,7 @@ static int trace__replay(struct trace *trace)
> >
> >  	trace->tool.sample	  = trace__process_sample;
> >  	trace->tool.mmap	  = perf_event__process_mmap;
> >+	trace->tool.mmap2	  = perf_event__process_mmap2;
> >  	trace->tool.comm	  = perf_event__process_comm;
> >  	trace->tool.exit	  = perf_event__process_exit;
> >  	trace->tool.fork	  = perf_event__process_fork;
> >
