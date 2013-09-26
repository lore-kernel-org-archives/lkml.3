Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3IZPpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:45:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:19220 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab3IZPpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:45:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,986,1371106800"; 
   d="scan'208";a="401438376"
Date: Thu, 26 Sep 2013 08:45:19 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.jf.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/21] perf tools: Add toggling events support
Message-ID: <20130926154519.GH2018@tassilo.jf.intel.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
 <20130925191216.GE2018@tassilo.jf.intel.com>
 <20130926070307.GE19090@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926070307.GE19090@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It would be better to keep counting and just do RDPMC on the switch 
> > points, and then subtract for counting. For sampling could need a MSR 
> > write to enable/disable. Still somewhat expensive, but nowhere near as 
> > bad as a full switch.
> 
> This is essentially an optimized event switch and should probably be done 
> on a higher level so that other instances of event/context switching 
> benefit as well.

Ok. Need to be a bit careful and it cannot be done in all cases.

For non global counters this only works if RDPMC is disabled, otherwise
it leaks counter interformation between unrelated processes, which
may be a security problem.

-Andu
