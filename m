Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaJHDYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:24:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51593 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaJHDYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:24:17 -0400
Date: Tue, 7 Oct 2014 20:24:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] workqueue: add quiescent state between work items
Message-ID: <20141008032411.GG4880@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
 <1412529862-17954-2-git-send-email-joe.lawrence@stratus.com>
 <20141005192119.GE8549@htj.dyndns.org>
 <20141005194748.GG8549@htj.dyndns.org>
 <20141006042158.GW5015@linux.vnet.ibm.com>
 <20141007072942.GA2088@nanopsycho.orion>
 <20141007134329.GA4880@linux.vnet.ibm.com>
 <20141007134528.1a59f31b@jlaw-desktop.mno.stratus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007134528.1a59f31b@jlaw-desktop.mno.stratus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100803-0017-0000-0000-0000056AF8B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 01:45:28PM -0400, Joe Lawrence wrote:
> On Tue, 7 Oct 2014 06:43:29 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Tue, Oct 07, 2014 at 09:29:42AM +0200, Jiri Pirko wrote:
> [ ... snip ... ]
> > > 
> > > Paul, Tehun, how do you propose to fix this on older kernels which do
> > > not have rcu_note_voluntary_context_switch? I'm particullary interested
> > > in 3.10.
> > 
> > Hello, Jiri,
> > 
> > Older kernels can instead use rcu_note_context_switch().
> 
> Hi Paul,
> 
> Does 4a81e8328d37 ("rcu: Reduce overhead of cond_resched() checks for
> RCU") affect a backport to 3.10?
> 
> I noticed that rcu_note_context_switch added a call to
> rcu_momentary_dyntick_idle in that change, which is only present in
> v3.16+.
> 
> Would rcu_note_context_switch be effective by itself on a 3.10 kernel?

Should be fine.  There is more overhead than current mainline, but that
should not be in the noise compared to executing a work-queue item.

							Thanx, Paul

