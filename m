Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaJVO1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:27:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:58528 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaJVO1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:27:08 -0400
Date: Wed, 22 Oct 2014 16:27:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141022142706.GS12706@worktop.programming.kicks-ass.net>
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
> +	if (test_cpu_cap(&boot_cpu_data, X86_FEATURE_INTEL_PT)) {
> +		for (i = 0; i < PT_CPUID_LEAVES; i++)
> +			cpuid_count(20, i,
> +				    &pt_pmu.caps[CR_EAX + i * 4],
> +				    &pt_pmu.caps[CR_EBX + i * 4],
> +				    &pt_pmu.caps[CR_ECX + i * 4],
> +				    &pt_pmu.caps[CR_EDX + i * 4]);
> +	} else
> +		return -ENODEV;

Please use {} for every multi-line stmt, even if its a single stmt, also
use {} in both branches of a condition, even if only one strictly
requires it.
