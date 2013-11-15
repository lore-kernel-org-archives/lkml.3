Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab3KOLw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:52:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3KOLwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:52:53 -0500
Date: Fri, 15 Nov 2013 12:52:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
Message-ID: <20131115115245.GD10456@twins.programming.kicks-ass.net>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
 <20131115063457.GB12442@gmail.com>
 <CABPqkBQ2wD_knJP9FQxThSxNng4DZhtRxeUUAW0efAs9=jBXEA@mail.gmail.com>
 <20131115103405.GA18264@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115103405.GA18264@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:34:05AM +0100, Ingo Molnar wrote:
> That brings up an interesting question: what is better for users, if 
> we schedule as many as we can and say 'not supported' to the rest 
> (current behavior), or if we fail the whole group?
> 
> I'd say that the default behavior should be what Jiri implemented: get 
> the most out of the situation and inform. But you are right in that 
> 'forcing' all elements of a group to be valid should be possible as 
> well - if a special perf stat option or event format is used.

So I don't agree, but if you want to keep this IMO weird behaviour at
least WARN about it in big blinking neon letters that the user isn't
getting what he asked for.
