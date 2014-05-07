Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaEGTZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:25:21 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:44682 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaEGTZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:25:18 -0400
Date: Wed, 7 May 2014 21:25:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140507192514.GB23409@gmail.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140507152640.GR30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507152640.GR30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> How about something like this for the itrace thing?
> 
> You would mmap() the regular buffer; when write ->aux_{offset,size} 
> in the control page. After which you can do a second mmap() with the 
> .pgoff matching the aux_offset you gave and .length matching the 
> aux_size you gave.
> 
> This way the mmap() content still looks like a single linear file 
> (could be sparse if you leave a hole, although we could require the 
> aux_offset to match the end of the data section).
> 
> And there is still the single event->rb, not more.
> 
> Then, when data inside that aux data store changes they should 
> inject an PERF_RECORD_AUX to indicate this did happen, which ties it 
> back into the normal event flow.
> 
> With this there should be no difficult page table tricks or 
> anything.
> 
> The patch is way incomplete but should sketch enough of the idea..
> 
> So the aux_head/tail values should also be in the file space and not 
> start at 0 again, similar for the offsets in the AUX record.

This looks like a pretty good concept to me, to support the buffering 
quirks/constraints that itrace CPUs apparently have.

Thanks,

	Ingo
