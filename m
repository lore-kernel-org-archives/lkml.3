Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaCGTy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:54:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaCGTy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:54:28 -0500
Date: Fri, 7 Mar 2014 16:54:08 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/8] perf, tools: Support handling complete branch stacks
 as histograms v4
Message-ID: <20140307195408.GB6519@infradead.org>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
 <1393561352-23448-3-git-send-email-andi@firstfloor.org>
 <20140307131949.GC13974@krava.brq.redhat.com>
 <20140307195100.GA6519@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307195100.GA6519@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 07, 2014 at 04:51:00PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Mar 07, 2014 at 02:19:49PM +0100, Jiri Olsa escreveu:
> > On Thu, Feb 27, 2014 at 08:22:26PM -0800, Andi Kleen wrote:
> > > +static void resolve_branch_ams(struct machine *machine, struct thread *thread,
> > > +			       u64 ip,
> > > +			       struct addr_location *al)

> > the function name is confusing.. there's no branch or ams
> > being dealt with in here

> yeah, it should be renamed, and all it does is to try to find something
> in all the possible cpu modes, so I think we should rename this to:

>   thread__find_cpumode_addr_location()

> And move it to right after thread__find_addr_location(), then use it
> here, doing that and combining the other patches, etc, should have it in
> a place for testing soon.
>  
> > maybe something like resolve_ip_al or resolve_ip ?

Humm, then it gets overly long and we have
PERF_RECORD_MISC_CPUMODE_UNKNOWN, so I'll try making it so that if
cpumode is passed as PERF_RECORD_MISC_CPUMODE_UNKNOWN,
thread__find_addr_location() will try to figure it out.

- Arnaldo
