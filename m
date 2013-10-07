Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3JGQ3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:29:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40083 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3JGQ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:29:45 -0400
Date: Mon, 7 Oct 2013 18:29:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com
Subject: Re: [PATCH v1 0/2] perf,x86: add Intel RAPL PMU support
Message-ID: <20131007162906.GX28601@twins.programming.kicks-ass.net>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381162158-24329-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 06:09:15PM +0200, Stephane Eranian wrote:
> The counters all count in the same unit. The perf_events API
> exposes all RAPL counters as 64-bit integers counting in unit
> of 1/2^32 Joules (or 0.23 nJ). User level tools must convert
> the counts by multiplying them by 0.23 and divide 10^9 to
> obtain Joules.  The reason for this is that the kernel avoids
> doing floating point math whenever possible because it is
> expensive (user floating-point state must be saved). The method
> used avoids kernel floating-point and minimizes the loss of
> precision (bits). Thanks to PeterZ for suggesting this approach.
> 
> To convert the raw count in Watt: W = C * 0.23 / (1e9 * time)

Right, so the output is in 32.32 fixed point. So if you want to convert
to double you'd do something like: 

  double watt = ldexp(counter, -32);


