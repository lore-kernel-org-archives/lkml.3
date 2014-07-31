Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaGaHZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:25:17 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52452 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaGaHZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:25:12 -0400
Date: Thu, 31 Jul 2014 09:25:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v4 0/9] perf, x86: large PEBS interrupt threshold
Message-ID: <20140731072507.GC4209@gmail.com>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
 <20140731071625.GA4209@gmail.com>
 <53D9EDB5.6020304@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D9EDB5.6020304@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yan, Zheng <zheng.z.yan@intel.com> wrote:

> On 07/31/2014 03:16 PM, Ingo Molnar wrote:
> > 
> > * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> > 
> >> This patch series implements large PEBS interrupt threshold. For some
> >> limited cases, it can significantly reduce the sample overhead. Please
> >> read patch 6's commit message for more information.
> >>
> >> changes since v1:
> >>   - drop patch 'perf, core: Add all PMUs to pmu_idr'
> >>   - add comments for case that multiple counters overflow simultaneously
> >> changes since v2:
> >>   - rename perf_sched_cb_{enable,disable} to perf_sched_cb_user_{inc,dec} 
> >>   - use flag to indicate auto reload mechanism
> >>   - move codes that setup PEBS sample data to separate function
> >>   - output the PEBS records in batch 
> >>   - enable this for All (PEBS capable) hardware 
> >>   - more description for the multiplex
> >> changes since v3:
> >>   - ignore conflicting PEBS record
> > 
> > Please include performance measurements, 'significantly reduces sample 
> > overhead' is a totally inadequate description to judge this patch set.
> 
> patch 6 contains performance data.

I actually checked patch 6, because you referred to it in the 
description - but the performance data is actually in patch 5.

Which nicely demonstrates why such figures belong into 0/N as well.

Please also improve the desciption of the performance figures: what 
does plain/multi/delta mean, and convert into nicely digestible 
before/after performance comparison with human readable percentage 
figures.

"It got faster by 50% when XYZ" is so much nicer to read for everyone 
involved.

Thanks,

	Ingo
