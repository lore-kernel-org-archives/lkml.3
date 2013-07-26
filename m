Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab3GZDTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:19:36 -0400
Received: from smtpauth05.mfg.siteprotect.com ([64.26.60.144]:53712 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756387Ab3GZDTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:19:33 -0400
Date: Thu, 25 Jul 2013 23:20:24 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Adrian Hunter <adrian.hunter@intel.com>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
In-Reply-To: <51F0C41C.8080005@intel.com>
Message-ID: <alpine.DEB.2.02.1307252313460.26062@pianoman.cluster.toy>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net> <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org> <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy> <51F0C41C.8080005@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020203.51F1EAC4.002B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Jul 2013, Adrian Hunter wrote:

> >> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> >> index 0b1df41..00d8274 100644
> >> --- a/include/uapi/linux/perf_event.h
> >> +++ b/include/uapi/linux/perf_event.h
> >> @@ -478,6 +478,16 @@ enum perf_event_type {
> >>  	 * file will be supported by older perf tools, with these new optional
> >>  	 * fields being ignored.
> >>  	 *
> >> +	 * struct sample_id {
> >> +	 * 	{ u32			pid, tid; } && PERF_SAMPLE_TID
> >> +	 * 	{ u64			time;     } && PERF_SAMPLE_TIME
> >> +	 * 	{ u64			id;       } && PERF_SAMPLE_ID
> >> +	 * 	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
> >> +	 * 	{ u32			cpu, res; } && PERF_SAMPLE_CPU
> >> +	 * } && perf_event_attr::sample_id_all
> >> +	 */
> >> +

a thing that personally bothers me are these imaginary struct definitions 
added as part of the documentation that aren't actually available in the 
public perf_event.h

I can see why it's done, but it can be confusing picking out in later 
definitions which struct fields are real and which ones are conceptual.

> >> @@ -498,6 +508,7 @@ enum perf_event_type {
> >>  	 *	struct perf_event_header	header;
> >>  	 *	u64				id;
> >>  	 *	u64				lost;
> >> +	 * 	struct sample_id		sample_id;
> >>  	 * };

This is what confused me; this documentation shows the sample_id
as always being there, but in reality that struct is only there
if perf_event_attr::sample_id_all is set.  

It might be clearer
if you stuck the perf_event_attr::sample_id_all qualifier each
place you add the sample_id field.

And it's nice that the header holds a size field which ensures backward 
compatability, I somehow had forgotten that with my initial complaint.

Vince
