Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbbAIONl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:13:41 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbbAIONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:13:40 -0500
Date: Fri, 9 Jan 2015 15:13:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org
Subject: Re: [PATCH v8 14/14] perf: add ITRACE_START record to indicate that
 tracing has started
Message-ID: <20150109141318.GR10476@twins.programming.kicks-ass.net>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1415972627-37514-15-git-send-email-alexander.shishkin@linux.intel.com>
 <20150109141248.GO3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109141248.GO3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 03:12:48PM +0100, Peter Zijlstra wrote:
> On Fri, Nov 14, 2014 at 03:43:47PM +0200, Alexander Shishkin wrote:
> > +++ b/include/uapi/linux/perf_event.h
> > @@ -750,6 +750,17 @@ enum perf_event_type {
> >  	 */
> >  	PERF_RECORD_AUX				= 11,
> >  
> > +	/*
> > +	 * Indicates that instruction trace has started
> > +	 *
> > +	 * struct {
> > +	 *	struct perf_event_header	header;
> > +	 *	u32				pid;
> > +	 *	u32				tid;
> 
> The below function suggests we should have:
> 
> 		struct sample_id		sample_id;
> 
> > +	 * };
> > +	 */
> > +	PERF_RECORD_ITRACE_START		= 12,

This also raises the question; why not use PERF_RECORD_COMM?
