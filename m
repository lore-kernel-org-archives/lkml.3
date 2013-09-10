Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3IJRy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:54:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:32877 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3IJRy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:54:56 -0400
Date: Tue, 10 Sep 2013 10:54:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20130910175453.GQ3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130813103202.GB2338@pompeji.miese-zwerge.org>
 <20130818180232.GL29406@linux.vnet.ibm.com>
 <20130818184848.GA2398@pompeji.miese-zwerge.org>
 <20130909215836.GD17483@pompeji.miese-zwerge.org>
 <20130909222751.GL3966@linux.vnet.ibm.com>
 <20130910074550.GE17483@pompeji.miese-zwerge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910074550.GE17483@pompeji.miese-zwerge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091017-8236-0000-0000-000001A1DC01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 09:45:50AM +0200, Jochen Striepe wrote:
> 	Hello,
> 
> On Mon, Sep 09, 2013 at 03:27:51PM -0700, Paul E. McKenney wrote:
> > On Mon, Sep 09, 2013 at 11:58:36PM +0200, Jochen Striepe wrote:
> > > I just got this on 3.10.11 on the same machine. Could that be
> > > related?
> > 
> > Several people helped track down another source of spurious stall
> > warnings on large systems, please see below for the patch.
> [...]
> > This is quite rare, but apparently occurs deterministically
> > on systems with about 6TB of memory.
> 
> Hmm. My system is an ASUS Eee PC netbook with a total of 2G memory.
> The latest stall was just when booting, while /dev was to be filled
> by udev (and taking a really long time on that). So I think this
> patch should not help at my machine, right?
> 
> I tried to reproduce the stall, but without success. Is there anything
> that could help reproducing?

Their stall was due to old-style creation of sysfs entries for memory.
Yours might be having a similar issue with the creation of /dev entries,
so it would be worth trying it.

One thing to try would be to insert delays into the code involved in
creating the /dev entries.  These delays will need to be busy-waits
rather than sleeps.

							Thanx, Paul

