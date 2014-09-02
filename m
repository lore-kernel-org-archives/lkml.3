Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaIBJob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:44:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaIBJoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:44:30 -0400
Date: Tue, 2 Sep 2014 11:17:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 20/41] perf tools: Let a user specify a PMU event without
 any config terms
Message-ID: <20140902091744.GC8044@krava.redhat.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-21-git-send-email-adrian.hunter@intel.com>
 <20140716142510.GE9441@krava.redhat.com>
 <53C6948C.2080103@intel.com>
 <20140716182214.GB32716@krava.redhat.com>
 <5400CB13.4040004@intel.com>
 <20140830085310.GA14358@krava.redhat.com>
 <540411C5.8030207@intel.com>
 <20140901191107.GE1900@krava.redhat.com>
 <5405582C.6070402@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5405582C.6070402@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 08:39:56AM +0300, Adrian Hunter wrote:

SNIP

> >>>   -e intel_pt/tsc=1,noretcomp=0/
> >>>
> >>> I guess I wanted to hear more elaboration why is this better
> >>> than the current way we have by defining an alias, like:
> >>>
> >>>   krava alias: "tsc=1,noretcomp=0"
> >>>
> >>>   -e intel_pt/krava/
> >>>
> >>> which gives the same result
> >>
> >> The default value must be provided by perf tools not the kernel e.g.
> >> an older version of perf tools will not be aware of new hardware
> >> features that the kernel may know about.  If the kernel enables
> >> new features by default then the tool may fail.  Thus the default
> >> value has to be under the control of the tools not the kernel, so
> >> a sysfs alias will not work.
> >>
> > 
> > I dont follow, could u provide some example?
> 
> Imagine that the 'tsc' term did not exist.  Intel PT trace data
> would not contain TSC packets, and the decoder would not know how to
> decode them.  Then imagine that a new version of the hardware adds
> 'tsc'.  It is such a useful feature that we want it by default, but
> older versions of the tools don't know how to decode it, so the
> kernel cannot turn it on by default.
> 
> > 
> > why the tool needs to understand.. it will just take the alias
> > and apply/use it? The alias follows the format logic, which tells
> > how to apply values on perf_event_attr.. and the kernel knows best
> > what's supported in its version..
> 
> It is similar to why the kernel does not select mmap2 by default.  The
> kernel doesn't know whether the tool supports it.
> 

ook, could you please add some kind of this explanation to the changelog?

thanks,
jirka
