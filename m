Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbbAVNBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:01:23 -0500
Received: from mail.kernel.org ([198.145.29.136]:46088 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbbAVNBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:01:21 -0500
Date: Thu, 22 Jan 2015 09:59:52 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Vince Weaver <vince@deater.net>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Perf tests for hw events
Message-ID: <20150122125952.GA3073@kernel.org>
References: <20150122124014.GF12079@codeblueprint.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122124014.GF12079@codeblueprint.co.uk>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 22, 2015 at 12:40:14PM +0000, Matt Fleming escreveu:
> Folks,
> 
> In the process of writing perf support for Intel's Cache QoS Monitoring
> feature [0] I've had to write my own userland tests to drive tools/perf
> and indirectly the kernel internals. I'm now getting requests for these
> tests from various people and it occurs to me that they should probably
> live in the kernel tree.
> 
> The tests I've got do a couple of things like setting up a perf_event
> cgroup and assigning enough tasks to trigger the RMID recycling code in
> the CQM driver, ensuring that we can run multiple events simultaneously
> (that the event scheduling/rotation code works), etc.
> 
> Does anything like this already exist for hw events? I couldn't find
> anything specific to hw events from snooping around in tools/perf/tests. 
> 
> I propose we add some hw event tests to the kernel tree. These will
> provide,
> 
>  - regression tests
>  - a source of documentation for how to use the events

That is the description for tools/perf/tests/ please send your patches
for adding new entries there.

> We should only test those hw events that are present on a user's
> machine; there's no sense in emulating things.

At some point 'perf test' should grow infrastructure to specify what is
required for a test so that it auto-skips those, possibly not even
bothering the user telling something can't be tested. Right now for
things like tests that requires finding a vmlinux, if it doesn't find
it, it will just print "Skipped", etc.
 
> Thoughts?
> 
> [0] - https://lkml.kernel.org/r/1415999712-5850-1-git-send-email-matt@console-pimps.org

- Arnaldo
