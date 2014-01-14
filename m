Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaANK2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:28:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56669 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaANK2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:28:02 -0500
Date: Tue, 14 Jan 2014 11:27:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        markgross@thegnar.org, vincent.guittot@linaro.org,
        catalin.marinas@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [3/11] issue 3: No understanding of potential cpu capacity
Message-ID: <20140114102753.GT7572@laptop.programming.kicks-ass.net>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-4-git-send-email-morten.rasmussen@arm.com>
 <3700155.hLuCBAXQoy@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3700155.hLuCBAXQoy@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 10:07:12PM +0100, Rafael J. Wysocki wrote:
> > Currently, the CFS scheduler has no knowledge about frequency scaling.
> > Frequency scaling governors generally try to match the frequency to
> > the load, which means that the idle time has no absolute meaning. The
> > potential spare cpu capacity may be much higher than indicated by the
> > idle time if the cpu is running at a low P-state.
> > 
> > The energy trade-off may justify putting another task on a loaded cpu
> > even if it causes a change to a higher P-state to handle the extra load.
> > Related issues are frequency (and cpu micro architecture) invariant task
> > load and power topology information, which are both needed to enable the
> > scheduler for energy-aware task placement. This is covered in more
> > detail in issue 5.
> > 
> > The potential cpu capacity cannot be assumed to be constant as thermal
> > management may restrict the usage of high performance P-states
> > dynamically.
> 
> That's correct.  Moreover, all of the above seems to assume that we can get
> exact power numbers for all of the involved C-states and P-states.  What if
> we can't?

On average more or less correct should be fine; in which case the
result will on average still be better.

Obviously the more reliable the input to the model the better the
results, but as long as the input numbers are more or less in the right
ballpark the model should still more or less do the right thing.
