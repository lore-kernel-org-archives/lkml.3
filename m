Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3GZI5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:57:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58028 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3GZI5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:57:41 -0400
Date: Fri, 26 Jul 2013 10:57:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
Message-ID: <20130726085730.GD27075@twins.programming.kicks-ass.net>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net>
 <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org>
 <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy>
 <51F0C41C.8080005@intel.com>
 <alpine.DEB.2.02.1307252313460.26062@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307252313460.26062@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:20:24PM -0400, Vince Weaver wrote:
> 
> On Thu, 25 Jul 2013, Adrian Hunter wrote:
> 
> > >> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> > >> index 0b1df41..00d8274 100644
> > >> --- a/include/uapi/linux/perf_event.h
> > >> +++ b/include/uapi/linux/perf_event.h
> > >> @@ -478,6 +478,16 @@ enum perf_event_type {
> > >>  	 * file will be supported by older perf tools, with these new optional
> > >>  	 * fields being ignored.
> > >>  	 *
> > >> +	 * struct sample_id {
> > >> +	 * 	{ u32			pid, tid; } && PERF_SAMPLE_TID
> > >> +	 * 	{ u64			time;     } && PERF_SAMPLE_TIME
> > >> +	 * 	{ u64			id;       } && PERF_SAMPLE_ID
> > >> +	 * 	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
> > >> +	 * 	{ u32			cpu, res; } && PERF_SAMPLE_CPU
> > >> +	 * } && perf_event_attr::sample_id_all
> > >> +	 */
> > >> +
> 
> a thing that personally bothers me are these imaginary struct definitions 
> added as part of the documentation that aren't actually available in the 
> public perf_event.h
> 
> I can see why it's done, but it can be confusing picking out in later 
> definitions which struct fields are real and which ones are conceptual.

Would it help if we changed the syntax to not look as much as real C
would?

> > >> @@ -498,6 +508,7 @@ enum perf_event_type {
> > >>  	 *	struct perf_event_header	header;
> > >>  	 *	u64				id;
> > >>  	 *	u64				lost;
> > >> +	 * 	struct sample_id		sample_id;
> > >>  	 * };
> 
> This is what confused me; this documentation shows the sample_id
> as always being there, but in reality that struct is only there
> if perf_event_attr::sample_id_all is set.  
> 
> It might be clearer
> if you stuck the perf_event_attr::sample_id_all qualifier each
> place you add the sample_id field.

Ah, I actually considered that but then got lazy and used the 0 sized
struct idea :/


