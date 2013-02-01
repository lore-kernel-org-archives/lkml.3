Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3BAK0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:26:35 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58225 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3BAK0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:26:33 -0500
Date: Fri, 1 Feb 2013 11:26:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@au1.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 22/25] perf: Make EVENT_ATTR global
Message-ID: <20130201102629.GA24485@gmail.com>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
 <1359653128-10433-23-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359653128-10433-23-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> 
> Rename EVENT_ATTR() to PMU_EVENT_ATTR() and make it global so it is
> available to all architectures.
> 
> Further to allow architectures flexibility, have PMU_EVENT_ATTR() pass
> in the variable name as a parameter.
> 
> Changelog[v2]
> 	- [Jiri Olsa] No need to define PMU_EVENT_PTR()
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Anton Blanchard <anton@au1.ibm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: linuxppc-dev@ozlabs.org
> Link: http://lkml.kernel.org/r/20130123062422.GC13720@us.ibm.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c | 13 +++----------
>  include/linux/perf_event.h       | 11 +++++++++++
>  2 files changed, 14 insertions(+), 10 deletions(-)

so this one started conflicting non-trivially with tip:perf/x86 
- the pending memory profiling kernel-side bits.

Can we merge the memory profiling tooling side bits together 
with the kernel side bits - or does it need more work?

For now I've excluded perf/x86 from tip:master until this is 
resolved.

Thanks,

	Ingo
