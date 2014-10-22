Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaJVOUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:20:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:58447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaJVOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:20:06 -0400
Date: Wed, 22 Oct 2014 16:20:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141022142003.GQ12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 04:45:40PM +0300, Alexander Shishkin wrote:
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1528,6 +1528,14 @@ again:
>  	}
>  
>  	/*
> +	 * Intel PT
> +	 */
> +	if (__test_and_clear_bit(55, (unsigned long *)&status)) {
> +		handled++;
> +		intel_pt_interrupt();
> +	}
> +

How does the PT interrupt interact with the regular PMI? In particular
does it respect stuff like FREEZE_ON_PMI etc?
