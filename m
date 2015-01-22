Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbbAVMkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:40:22 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39649 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbbAVMkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:40:17 -0500
Date: Thu, 22 Jan 2015 12:40:14 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Vince Weaver <vince@deater.net>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Perf tests for hw events
Message-ID: <20150122124014.GF12079@codeblueprint.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

In the process of writing perf support for Intel's Cache QoS Monitoring
feature [0] I've had to write my own userland tests to drive tools/perf
and indirectly the kernel internals. I'm now getting requests for these
tests from various people and it occurs to me that they should probably
live in the kernel tree.

The tests I've got do a couple of things like setting up a perf_event
cgroup and assigning enough tasks to trigger the RMID recycling code in
the CQM driver, ensuring that we can run multiple events simultaneously
(that the event scheduling/rotation code works), etc.

Does anything like this already exist for hw events? I couldn't find
anything specific to hw events from snooping around in tools/perf/tests. 

I propose we add some hw event tests to the kernel tree. These will
provide,

 - regression tests
 - a source of documentation for how to use the events

We should only test those hw events that are present on a user's
machine; there's no sense in emulating things.

Thoughts?

[0] - https://lkml.kernel.org/r/1415999712-5850-1-git-send-email-matt@console-pimps.org

-- 
Matt Fleming, Intel Open Source Technology Center
