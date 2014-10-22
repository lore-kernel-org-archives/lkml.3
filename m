Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaJVOCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:02:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaJVOCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:02:20 -0400
Date: Wed, 22 Oct 2014 16:02:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 07/20] perf: Add api for pmus to write to AUX area
Message-ID: <20141022140207.GN12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-8-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413207948-28202-8-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 04:45:35PM +0300, Alexander Shishkin wrote:
> +	/*
> +	 * Nesting is not supported for AUX area, make sure nested
> +	 * writers are caught early
> +	 */
> +	if (WARN_ON_ONCE(local_xchg(&rb->aux_nest, 1)))
> +		goto err_put;

Note that printk() from NMI is prone to making your machine die, not
that I have a better option though.
