Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaJVOTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:19:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:63805 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbaJVOTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:19:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,769,1406617200"; 
   d="scan'208";a="623221933"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 07/20] perf: Add api for pmus to write to AUX area
In-Reply-To: <20141022140207.GN12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-8-git-send-email-alexander.shishkin@linux.intel.com> <20141022140207.GN12706@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 22 Oct 2014 17:14:05 +0300
Message-ID: <87iojcdweq.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, Oct 13, 2014 at 04:45:35PM +0300, Alexander Shishkin wrote:
>> +	/*
>> +	 * Nesting is not supported for AUX area, make sure nested
>> +	 * writers are caught early
>> +	 */
>> +	if (WARN_ON_ONCE(local_xchg(&rb->aux_nest, 1)))
>> +		goto err_put;
>
> Note that printk() from NMI is prone to making your machine die, not
> that I have a better option though.

Indeed, but if your driver is really attempting nested
perf_aux_output_begin()s, then you had it coming to you anyway.

Regards,
--
Alex
