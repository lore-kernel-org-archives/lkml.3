Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583Ab3JQT0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:26:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758635Ab3JQT0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:26:53 -0400
Date: Thu, 17 Oct 2013 16:26:30 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        dsahern@gmail.com, jolsa@redhat.com, ak@linux.intel.com
Subject: Re: [PATCH v3] perf: disable PERF_RECORD_MMAP2 support
Message-ID: <20131017192630.GB6443@infradead.org>
References: <20131017173215.GA8820@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017173215.GA8820@quad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 17, 2013 at 07:32:15PM +0200, Stephane Eranian escreveu:
> 
> For now, we disable the extended MMAP record support (MMAP2).
> We have identified cases where it would not report the correct
> mapping information, clone(VM_CLONE) but with separate pids.
> We will revisit the support once we find a solution for this case.
> 
> The patch changes the kernel to return EINVAL if attr->mmap2
> is set. The patch also modifies the perf tool to use regular PERF_RECORD_MMAP
> for synthetic events and it also prevents the tool from requesting attr->mmap2
> mode because the kernel would reject it.
> 
> The support will be revisited once the kenrel interface is updated.
> 
> In V2, we reduce the patch to the strict minimum.
> In V3, we avoid calling perf_event_open() with mmap2 set because we
> know it will fail and require fallback retry.

Again it applied, but with some fuzz, which branch did you coded this
against? Testing...

[acme@zoo linux]$ patch -p1 < /wb/1
patching file kernel/events/core.c
Hunk #1 succeeded at 6767 (offset -6 lines).
patching file tools/perf/util/event.c
patching file tools/perf/util/evsel.c
Hunk #1 succeeded at 678 with fuzz 1.
[acme@zoo linux]$ 

- Arnaldo
