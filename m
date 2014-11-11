Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaKKOR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:17:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:13826 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaKKORz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:17:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="635067386"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20141111132000.GM10501@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com> <20141022143241.GT12706@worktop.programming.kicks-ass.net> <8738a4crgg.fsf@ashishki-desk.ger.corp.intel.com> <20141104155734.GL12706@worktop.programming.kicks-ass.net> <87wq72asjo.fsf@ashishki-desk.ger.corp.intel.com> <20141111132000.GM10501@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 11 Nov 2014 16:17:15 +0200
Message-ID: <87tx25bz4k.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Nov 11, 2014 at 01:24:43PM +0200, Alexander Shishkin wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>
>> > Now I'm not sure we want to export all the bits you're using though.
>> > Like the topa_multiple_entires, that appears an implementation detail
>> > userspace should not really care about either way.
>> 
>> Actually, userspace can make assumptions about lost data from this
>> bit.
>
> Do explain; it feels entirely wrong to expose something like this, esp.
> since this crappy single TOPA thing is going away.

At the very least, it gives you the minimal amount of memory you can ask
for the aux buffer. With multiple entry topa it is one page, with single
entry topa it is two pages. You can leave it up to the userspace to find
out by trial and error, of course.

>> But there are others, such as encoded address length. In future
>> there will also be several "caps" with allowed values for certain bit
>> fields in RTIT_CTL, such as timing packet frequencies.
>
> No, those should not be caps, those should be in the format description.

Format description gives a bit field, within which not all combinations
may be valid. That is,

format/blah_freq: config:16-19
caps/blah_freq: 81

which means that on this cpu you can only set blah_freq to either 0 or
7. Figuring out these things by trial and error from userspace is not
really nice.

Regards,
--
Alex
