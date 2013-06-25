Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3FYTct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:32:49 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49486 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3FYTcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:32:48 -0400
Date: Tue, 25 Jun 2013 12:32:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@freedesktop.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 29/32] rcu: delete __cpuinit usage from all rcu files
Message-ID: <20130625193237.GF3828@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
 <1372102237-8757-30-git-send-email-paul.gortmaker@windriver.com>
 <20130625011045.GA2912@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625011045.GA2912@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062519-7408-0000-0000-0000118153AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 06:10:46PM -0700, Josh Triplett wrote:
> On Mon, Jun 24, 2013 at 03:30:34PM -0400, Paul Gortmaker wrote:
> > The __cpuinit type of throwaway sections might have made sense
> > some time ago when RAM was more constrained, but now the savings
> > do not offset the cost and complications.  For example, the fix in
> > commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
> > is a good example of the nasty type of bugs that can be created
> > with improper use of the various __init prefixes.
> > 
> > After a discussion on LKML[1] it was decided that cpuinit should go
> > the way of devinit and be phased out.  Once all the users are gone,
> > we can then finally remove the macros themselves from linux/init.h.
> > 
> > This removes all the drivers/rcu uses of the __cpuinit macros
> > from all C files.
> > 
> > [1] https://lkml.org/lkml/2013/5/20/589
> > 
> > Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > Cc: Josh Triplett <josh@freedesktop.org>
> > Cc: Dipankar Sarma <dipankar@in.ibm.com>
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > ---
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Queued for 3.12 with Josh's Reviewed-by.  Thank you both!

							Thanx, Paul

