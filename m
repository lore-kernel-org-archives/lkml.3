Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3JBI5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:57:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3JBI5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:57:48 -0400
Date: Wed, 2 Oct 2013 10:57:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        mingo@kernel.org, eranian@google.com
Subject: Re: [PATCH 11/11] perf: Avoid uninitialized sample type reference in
 __perf_event__output_id_sample
Message-ID: <20131002085730.GD12926@twins.programming.kicks-ass.net>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-12-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380572952-30729-12-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 01:29:12PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> __perf_event__output_id_sample looks at data->type to decide
> what to output.
> 
> A lot of of the custom output functions, for example perf_log_throttle
> start with perf_event_header__init_id, which only initializes
> the header when event->attr.sample_id_all is true.
> 
> But when this is false the output function is still called,
> and will look at an uninitialized header.
> 
> I changed all the callers to perf_event_header__init_id
> to __perf_event_header__init_id which unconditionally
> initializes the header.
> 
> FWIW I'm not fully sure this is the correct fix and what the
> exact semantics of sample_id_all are supposed to be.
> Should it disable all throttling etc. messages?
> Please review carefully.

Why are you doing this; also what's up with 11/11?
