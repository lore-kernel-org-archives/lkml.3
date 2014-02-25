Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaBYLbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:31:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38617 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaBYLbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:31:05 -0500
Date: Tue, 25 Feb 2014 12:31:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Dave P Martin <Dave.Martin@arm.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 7/7] perf: kill perf_event_context::pmu
Message-ID: <20140225113100.GN9987@twins.programming.kicks-ass.net>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <1392054264-23570-8-git-send-email-mark.rutland@arm.com>
 <20140210181026.GD27965@twins.programming.kicks-ass.net>
 <20140211175651.GA15200@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211175651.GA15200@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:56:51PM +0000, Mark Rutland wrote:
> Another option would be to have a context per-pmu. Each context's pmu
> pointer would be valid, and (other than the case of software events) it
> doesn't make sense to place events from disparate PMUs into the same
> group anyway. Then you don't need a fixed sized pmu list in the context
> or some arcane list structs.

No it does make sense; for example on hardware that doesn't have a PMI
you can create a software event + hardware event group and have the
software interrupt read the hardware counter and still get 'some'
sampling.
