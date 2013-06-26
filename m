Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab3FZPFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:05:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26172 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3FZPFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:05:05 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=JeMnKzm8Z7MA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vXuyrZPK3zMA:10 a=D19gQVrFAAAA:8 a=b4KrJKo_AAAA:8 a=-qwhw_xnys7Ca05oJrcA:9 a=QEXdDO2ut3YA:10 a=_H-fYMU3ovgA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372259103.18733.260.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH RT] rcu,rt: Allow rcu_read_lock_sched() to schedule
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Date: Wed, 26 Jun 2013 11:05:03 -0400
In-Reply-To: <1372259000.18733.258.camel@gandalf.local.home>
References: <1372254133.18733.252.camel@gandalf.local.home>
	 <20130626144045.GO3828@linux.vnet.ibm.com>
	 <1372259000.18733.258.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 11:03 -0400, Steven Rostedt wrote:

> > I tried this approach in early 2005, and testing did not go well:
> > 
> > https://lkml.org/lkml/2005/3/17/199
> > 
> > For one thing, a lock acquired both within and surrounding an
> > RCU-sched read-side critical section would result in deadlock.
> > 
> > Or have things changed so that this now somehow works?
> 
> Well, so far lockdep hasn't splatted on this. But that's not saying much
> because I'm currently fighting the lockdep splats from other workqueue
> related stuff.
> 
> Seems that Tejun really doesn't like us RT folks ;-)

If there are issues, we could make a rcu_read_lock_sched_rt() which for
mainline will be rcu_read_lock_sched(), but for -rt will grab the lock.
That way we can pick and choose the locations that this is required.

-- Steve


