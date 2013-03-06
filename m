Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3CFRRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:17:43 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:41094 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3CFRRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:17:39 -0500
Date: Wed, 6 Mar 2013 09:16:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Threaded irqs + 100% CPU RT task = RCU stall
Message-ID: <20130306171648.GO3268@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130306154917.GA15249@windriver.com>
 <alpine.LFD.2.02.1303061651360.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303061651360.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030617-7606-0000-0000-0000091E4BCF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 04:58:54PM +0100, Thomas Gleixner wrote:
> On Wed, 6 Mar 2013, Paul Gortmaker wrote:
> > So, I guess the question is, whether we want to try and make the system
> > fail in a more meaningful way -- kind of like the rt throttling message
> > does - as it lets users know they've hit the wall?  Something watching
> 
> That Joe Doe should have noticed the throttler message, which came
> before the stall, shouldn't he?
> 
> > for kstat_incr_softirqs traffic perhaps?  Or other options?
> 
> The rcu stall detector could use the softirq counter and if it did not
> change in the stall period print: "Caused by softirq starvation" or
> something like that.

The idea is to (at grace-period start) take a snapshot of the CPU's
value of kstat.softirqs[RCU_SOFTIRQ], then check it at stall time, right?

Or do I have the wrong softirq counter?

							Thanx, Paul

