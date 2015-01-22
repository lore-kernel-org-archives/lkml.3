Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbbAVRIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:08:11 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49347 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbbAVRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:08:08 -0500
Date: Thu, 22 Jan 2015 17:08:04 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Vince Weaver <vince@deater.net>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Perf tests for hw events
Message-ID: <20150122170804.GG12079@codeblueprint.co.uk>
References: <20150122124014.GF12079@codeblueprint.co.uk>
 <20150122125658.GA2473@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122125658.GA2473@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan, at 01:56:59PM, Jiri Olsa wrote:
> On Thu, Jan 22, 2015 at 12:40:14PM +0000, Matt Fleming wrote:
> > Folks,
> > 
> > In the process of writing perf support for Intel's Cache QoS Monitoring
> > feature [0] I've had to write my own userland tests to drive tools/perf
> > and indirectly the kernel internals. I'm now getting requests for these
> > tests from various people and it occurs to me that they should probably
> > live in the kernel tree.
> > 
> > The tests I've got do a couple of things like setting up a perf_event
> > cgroup and assigning enough tasks to trigger the RMID recycling code in
> > the CQM driver, ensuring that we can run multiple events simultaneously
> > (that the event scheduling/rotation code works), etc.
> > 
> > Does anything like this already exist for hw events? I couldn't find
> > anything specific to hw events from snooping around in tools/perf/tests. 
> 
> that's the only place for this kind of stuff.. and AFAIK we use
> just some basic HW events like cycles, or software events
 
OK cool. I just wanted confirmation that tools/perf/tests was the best
place for these tests.

> > We should only test those hw events that are present on a user's
> > machine; there's no sense in emulating things.
> 
> agreed.. I remember we were discussing with Arnaldo the strengthening
> of the test framework.. so it would detect what tests are runable
> under current machine and priviledge
> 
> IIRC we already have some CPU detection support:
>   int __attribute__ ((weak)) get_cpuid(char *buffer, size_t sz);

Aha, excellent. I hadn't noticed this. It should be possible to build
something on top of this.

-- 
Matt Fleming, Intel Open Source Technology Center
