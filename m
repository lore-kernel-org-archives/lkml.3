Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbaE1Tza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:55:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:26993 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaE1Tz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,929,1392192000"; 
   d="scan'208";a="519232582"
Date: Wed, 28 May 2014 12:55:28 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Dave Hansen <dave.hansen@intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [RFC] perf/x86: PMU IRQ handler issues
Message-ID: <20140528195528.GQ29957@tassilo.jf.intel.com>
References: <CABPqkBTsiwicZNuU5BW6FZfB4aC=T=w9vFoxLqBTV3-PS4BnoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTsiwicZNuU5BW6FZfB4aC=T=w9vFoxLqBTV3-PS4BnoA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Another explanation is that because we ACK the NMI early, we leave the
> door open to other interrupts, incl. NIC, and we are interrupting the execution

PMI executes with interrupts off.

> of the PMU IRQ handler, yet that detour is measured in the PMU handler
> latency, causing more throttling than needed. Is that a plausible scenario too?
> And if so, I think we need to narrow the window for timing errors, by
> acking late
> on all processors and not just HSW.

If you think there's a concrete problem please show an ftrace.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
