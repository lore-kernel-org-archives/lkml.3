Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaKKNUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:20:14 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48048 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaKKNUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:20:12 -0500
Date: Tue, 11 Nov 2014 14:20:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141111132000.GM10501@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20141022143241.GT12706@worktop.programming.kicks-ass.net>
 <8738a4crgg.fsf@ashishki-desk.ger.corp.intel.com>
 <20141104155734.GL12706@worktop.programming.kicks-ass.net>
 <87wq72asjo.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wq72asjo.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 01:24:43PM +0200, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:

> > Now I'm not sure we want to export all the bits you're using though.
> > Like the topa_multiple_entires, that appears an implementation detail
> > userspace should not really care about either way.
> 
> Actually, userspace can make assumptions about lost data from this
> bit.

Do explain; it feels entirely wrong to expose something like this, esp.
since this crappy single TOPA thing is going away.

> But there are others, such as encoded address length. In future
> there will also be several "caps" with allowed values for certain bit
> fields in RTIT_CTL, such as timing packet frequencies.

No, those should not be caps, those should be in the format description.
