Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbaICRPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:15:00 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43238 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbaICRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:14:59 -0400
Date: Wed, 3 Sep 2014 10:14:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
Message-ID: <20140903171409.GZ5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.11.1409021513490.26284@gentwo.org>
 <20140902203743.GL5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021545370.32690@gentwo.org>
 <20140902211517.GO5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021819500.5437@gentwo.org>
 <20140903021152.GA14069@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409030846310.9372@gentwo.org>
 <20140903144349.GT5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031043540.24085@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409031043540.24085@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090317-3532-0000-0000-000004578170
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:51:13AM -0500, Christoph Lameter wrote:
> On Wed, 3 Sep 2014, Paul E. McKenney wrote:
> 
> > You would prefer that I instead allocated an NR_CPUS-sized array?
> 
> Well, a shared data structure would be cleaner in general but there are
> certainly other approaches.

Per-CPU variables -are- a shared data structure.

> But lets focus on the dynticks_idle case we are discussing here rather
> than tackle the more difficult other atomics. What is checked in the loop
> over the remote cpus is the dynticks_idle value plus
> dynticks_idle_jiffies. So it seems that memory ordering is only used to
> ensure that the jiffies are seen correctly.
> 
> In that case both the dynticks_idle and dynticks_idle_jiffies could be
> placed in one 64 bit value. If this is stored and retrieved as one then
> there is no issue with ordering anymore and the barriers would no longer
> be needed.

If there was an upper bound on the propagation of values through a system,
I could buy this.

But Mike Galbraith checked the overhead of ->dynticks_idle and found
it to be too small to measure.  So doesn't seem to be a problem worth
extraordinary efforts, especially given that many systems can avoid
it simply by leaving CONFIG_NO_HZ_SYSIDLE=n.

							Thanx, Paul

