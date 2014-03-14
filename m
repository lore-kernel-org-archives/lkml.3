Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaCNKjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:39:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38164 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaCNKjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:39:31 -0400
Date: Fri, 14 Mar 2014 11:38:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140314103832.GQ27965@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140217143340.GR27965@twins.programming.kicks-ass.net>
 <20140218023659.GV12219@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218023659.GV12219@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 06:36:59PM -0800, Andi Kleen wrote:
> > I'm not convinced it needs to be a PERF_RECORD_SAMPLE; but some
> > PERF_RECORD_* type for sure. 
> 
> Adding a header shouldn't be a problem, it's merely wasting 4K.
> 
> > Also it must allow interleaving with other > events.
> 
> But can you describe a concrete use case where interleaving is better?

I really don't want the multi-buffer nonsense proposed. An event gets
_1_ buffer, that's it.

That also means that if someone redirect another event into this buffer,
it needs to just work.

And because its a perf buffer, people expect it to look like one. So
we've got 'wrap' it.


