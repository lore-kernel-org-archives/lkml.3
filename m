Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaJWT4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:56:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32825 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaJWT4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:56:14 -0400
Date: Thu, 23 Oct 2014 12:52:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com, oleg@redhat.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141023195221.GA4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141013173504.GA27955@redhat.com>
 <20141023183232.GW4977@linux.vnet.ibm.com>
 <20141023184018.GA12274@redhat.com>
 <20141023192807.GY4977@linux.vnet.ibm.com>
 <20141023193759.GA14188@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023193759.GA14188@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102319-0033-0000-0000-000000D0DB6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 03:37:59PM -0400, Dave Jones wrote:
> On Thu, Oct 23, 2014 at 12:28:07PM -0700, Paul E. McKenney wrote:
> 
>  > >  > This one will require more looking.  But did you do something like
>  > >  > create a pair of mutually recursive symlinks or something?  ;-)
>  > > 
>  > > I'm not 100% sure, but this may have been on a box that I was running
>  > > tests on NFS. So maybe the server had disappeared with the mount
>  > > still active..
>  > > 
>  > > Just a guess tbh.
>  > 
>  > Another possibility might be that the box was so overloaded that tasks
>  > were getting preempted for 21 seconds as a matter of course, and sometimes
>  > within RCU read-side critical sections.  Or did the box have ample idle
>  > time?
> 
> I fairly recently upped the number of child processes I typically run
> with, so it being overloaded does sound highly likely.

Ah, that could do it!  One way to test extreme loads and not trigger
RCU CPU stall warnings might be to make all of your child processes all
sleep during a given interval of a few hundred milliseconds during each
ten-second interval.  Would that work for you?

							Thanx, Paul

