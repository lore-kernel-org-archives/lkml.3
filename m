Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab3GDJDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:03:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34912 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3GDJDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:03:36 -0400
Date: Thu, 4 Jul 2013 11:02:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: perf/Documentation/ABI -- add some documentation for perf_event
 sysfs usage
Message-ID: <20130704090253.GJ18898@dyad.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1307031527390.12584@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1307032308040.13409@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1307032308040.13409@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 11:14:40PM -0400, Vince Weaver wrote:
> On Wed, 3 Jul 2013, Vince Weaver wrote:

> OK, don't I feel silly, these values were already documented in 
>    Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> rather than ABI/stable
> 
> To be fair I missed it because the documentation seemed to come from the 
> Power developers and not through perf_event
>
> anyway, that documentation says the values will be hex only, which was 
> broken by
> 
> commit f9134f36aed59ab55c0ab1a4618dd455f15aef5f
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Mon Jun 17 17:36:52 2013 -0700
> 
>     perf/x86/intel: Add mem-loads/stores support for Haswell
> 
> 
> which added:
> EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");
> 
> (note ldlat is not in hex).
> 
> This broke the trinity fuzzer (which scans to look for events to use)
> as well as some of my personal tools.
> 
> Should the ldlat value be fixed to be hex?  Or should we ammend the ABI
> document to allow decimal?

I don't see a good reason not to allow decimal as well. Jolsa?
