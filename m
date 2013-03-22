Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161093Ab3CVRd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:33:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:30408 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161061Ab3CVRd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:33:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,893,1355126400"; 
   d="scan'208";a="274692890"
Date: Fri, 22 Mar 2013 10:33:26 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v5 0/2] perf: use hrtimer for event multiplexing
Message-ID: <20130322173326.GN19692@tassilo.jf.intel.com>
References: <1363949499-3728-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363949499-3728-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 11:51:37AM +0100, Stephane Eranian wrote:
> The current scheme of using the timer tick was fine
> for per-thread events. However, it was causing
> bias issues in system-wide mode (including for
> uncore PMUs). Event groups would not get their
> fair share of runtime on the PMU. With tickless
> kernels, if a core is idle there is no timer tick,
> and thus no event rotation (multiplexing). However,
> there are events (especially uncore events) which do
> count even though cores are asleep.

Would it be possible to only do this when uncore events
are active? Otherwise it may have a large power cost
and actually change results, as the core counters
will tick more.

-Andi
