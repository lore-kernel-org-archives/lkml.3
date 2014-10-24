Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaJXHr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:47:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:11245 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbaJXHr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:47:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,778,1406617200"; 
   d="scan'208";a="610477671"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 11/20] x86: perf: Intel PT and LBR/BTS are mutually exclusive
In-Reply-To: <20141022141547.GO12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-12-git-send-email-alexander.shishkin@linux.intel.com> <20141022141547.GO12706@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 24 Oct 2014 10:47:16 +0300
Message-ID: <87bnp13o57.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, Oct 13, 2014 at 04:45:39PM +0300, Alexander Shishkin wrote:
>> Intel PT cannot be used at the same time as LBR or BTS and will cause a
>> general protection fault if they are used together. In order to avoid
>> fixing up GPs in the fast path, instead we use flags to indicate that
>> that one of these is in use so that the other avoids MSR access altogether.
>> 
>
> Yeah, don't like this. Like I've said many times before we should simply
> disallow creating PT events when there are LBR events and vice versa.

Ok, I must have misunderstood you before. This makes things a bit
easier.

Regards,
--
Alex
