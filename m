Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3FYBKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:10:55 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54444 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3FYBKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:10:54 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 24 Jun 2013 18:10:46 -0700
From: Josh Triplett <josh@freedesktop.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 29/32] rcu: delete __cpuinit usage from all rcu files
Message-ID: <20130625011045.GA2912@leaf>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
 <1372102237-8757-30-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372102237-8757-30-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 03:30:34PM -0400, Paul Gortmaker wrote:
> The __cpuinit type of throwaway sections might have made sense
> some time ago when RAM was more constrained, but now the savings
> do not offset the cost and complications.  For example, the fix in
> commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
> is a good example of the nasty type of bugs that can be created
> with improper use of the various __init prefixes.
> 
> After a discussion on LKML[1] it was decided that cpuinit should go
> the way of devinit and be phased out.  Once all the users are gone,
> we can then finally remove the macros themselves from linux/init.h.
> 
> This removes all the drivers/rcu uses of the __cpuinit macros
> from all C files.
> 
> [1] https://lkml.org/lkml/2013/5/20/589
> 
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@freedesktop.org>
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
