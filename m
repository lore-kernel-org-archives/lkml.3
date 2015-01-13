Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbbAMPLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:11:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:53431 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbbAMPLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:11:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="636642165"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org
Subject: Re: [PATCH v8 12/14] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20150109124824.GL3337@twins.programming.kicks-ass.net>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com> <1415972627-37514-13-git-send-email-alexander.shishkin@linux.intel.com> <20150109124824.GL3337@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 13 Jan 2015 17:09:58 +0200
Message-ID: <87sifen2d5.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, Nov 14, 2014 at 03:43:45PM +0200, Alexander Shishkin wrote:
>> +static void pt_event_stop(struct perf_event *event, int mode)
>> +{
>> +	struct pt *pt = this_cpu_ptr(&pt_ctx);
>> +
>> +	ACCESS_ONCE(pt->handle_nmi) = 0;
>
> Why is this needed? Will the hardware still generate interrupts if you
> stop the PT thing?

Actually, it turns out that the interrupt condition can race with the
wrmsr that disables tracing and the PT bit remains set in the global
status register, causing the next PMI to go into the PT PMI handler,
which then may decide to re-enable the counter that should be disabled.

Regards,
--
Alex
