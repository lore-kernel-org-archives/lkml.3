Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbaJXMNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:13:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:41703 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091AbaJXMNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:13:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,780,1406617200"; 
   d="scan'208";a="610580027"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20141024115131.GY21513@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com> <20141022144543.GV12706@worktop.programming.kicks-ass.net> <87tx2t27yb.fsf@ashishki-desk.ger.corp.intel.com> <20141024115131.GY21513@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 24 Oct 2014 15:13:19 +0300
Message-ID: <87wq7pd5sw.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, Oct 24, 2014 at 11:22:20AM +0300, Alexander Shishkin wrote:
>> > The fact that the hardware cannot even tell you the supported mask is
>> > further fail.
>
>> The problem with this is that some bits go in groups, there'd be 2..3..4
>> bit fields encoding desired packet frequency, for example.
>
> OK, so put the magic number in the big model array.

I'm not sure I follow. These bits are reserved for the future, they can
potentially be whatever combinations of whatever. If we want to probe
around for valid combinations is to check everything in the range of
0..2^43 (or something like that, the region reserved for packet enables)
and store all the valid ones, which sounds crazy.

