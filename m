Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaG3K5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:57:13 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:47961 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751223AbaG3K5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:57:12 -0400
Date: Wed, 30 Jul 2014 11:57:07 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuyang Du <yuyang.du@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
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
Message-ID: <20140730105707.GC3001@e103034-lin>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <20140718153931.GJ8700@e103034-lin>
 <20140727190237.GB22986@intel.com>
 <20140730101331.GB15761@e103687>
 <20140730102128.GJ19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730102128.GJ19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:21:28AM +0100, Peter Zijlstra wrote:
> On Wed, Jul 30, 2014 at 11:13:31AM +0100, Morten Rasmussen wrote:
> > It is a very real problem when user-space uses priorities extensively
> > like Android does. Tasks related to audio run at very high priorities
> > but only for a very short amount of time, but due the to priority
> > scaling their load ends up being several times higher than tasks running
> > all the time at normal priority. Hence task load is a very poor
> > indicator of utilization.
> 
> FWIW Android (which I think does this through binder) is utterly insane
> in this regard. But yes, we have to live with it.

I agree that its use of priorities seems a bit extreme. I'm not trying
to defend it in any way :-) 
