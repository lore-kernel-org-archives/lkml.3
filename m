Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaG2J4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:56:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:47368 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbaG2J4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,756,1400050800"; 
   d="scan'208";a="462621473"
Date: Tue, 29 Jul 2014 09:53:44 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140729015344.GF5203@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
 <20140727173616.GA22986@intel.com>
 <CAKfTPtBR1dK-8nFGAMvEa2AC6ByZgOskkZpWEOXwzDrUD6xBDg@mail.gmail.com>
 <20140729093911.GU20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729093911.GU20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 11:39:11AM +0200, Peter Zijlstra wrote:
> > > For task, assuming its load.weight does not change much, yes, we can. But in theory, task's
> > 
> > I would even say that the load_avg of a task should not be impacted by
> > an old priority value. Once, the priority of a task is changed, we
> > should only take into account this new priority to weight the load_avg
> > of the task
> 
> So for tasks I would immediately agree, and I think for groups too,
> seeing how the group weight is based off of this avg, if you then
> include the old weight we'll get a feedback loop. This might not be
> desired as it would counteract the SMP movement of tasks.

Including the old weight can we get the *right* feedback. Because say until
weight is changed, we are balanced, changed weight leads to imbalance. Without
old weight, the imbalance is multiplied by the history, like we have never been
balanced.
