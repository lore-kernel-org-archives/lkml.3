Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaG2JTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:19:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:7812 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbaG2JT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,755,1400050800"; 
   d="scan'208";a="580533493"
Date: Tue, 29 Jul 2014 09:17:13 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140729011713.GD5203@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <20140718153931.GJ8700@e103034-lin>
 <20140727190237.GB22986@intel.com>
 <20140728103812.GP6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728103812.GP6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 12:38:12PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 03:02:37AM +0800, Yuyang Du wrote:
> > > Another thing that might be an issue is that the blocked of a terminated
> > > task lives on for quite a while until has decayed away.
> > 
> > Good point. To do so, if I read correctly, we need to hook do_exit(), but probably
> > we are gonna encounter rq->lock issue.
> > 
> > What is the opinion/guidance from the maintainers/others?
> 
> So the entire point of this per entity tracking was to make sure load
> numbers reflect reality. We account migrations etc., it would be weird
> to then throw all that out the window and let task exit accumulate crap.
> 

Yes. So I will hook up do_exit. Hope I did it right. Likewise, also do group entity
in group destroy and group offline? 
