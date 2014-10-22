Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaJVPOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:14:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51350 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaJVPOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:14:31 -0400
Date: Wed, 22 Oct 2014 17:14:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141022151413.GY12706@worktop.programming.kicks-ass.net>
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
> +			if ((pt_cap_get(PT_CAP_topa_multiple_entries)
> +			     && topa->table[i].stop)
> +			    || topa->table[i].end)
> +				break;

> +		old = (local64_xchg(&buf->head, base) &
> +		       ((buf->nr_pages << PAGE_SHIFT) - 1));

> +		if (!pt_cap_get(PT_CAP_topa_multiple_entries) ||
> +		    buf->output_off == sizes(TOPA_ENTRY(buf->cur, buf->cur_idx)->size)) {
> +			local_inc(&buf->lost);
> +			advance++;
> +		}

Inconsistent coding style. Please put operators at the end of a line,
not at the start of one.
