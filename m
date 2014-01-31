Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbaAaQiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:38:24 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36333 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaAaQiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:38:22 -0500
Date: Fri, 31 Jan 2014 17:38:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] nohz: ensure users are aware boot CPU is not NO_HZ_FULL
Message-ID: <20140131163817.GC21061@localhost.localdomain>
References: <1390929049-17758-1-git-send-email-paul.gortmaker@windriver.com>
 <20140129000630.GT9012@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129000630.GT9012@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 04:06:30PM -0800, Paul E. McKenney wrote:
> On Tue, Jan 28, 2014 at 12:10:49PM -0500, Paul Gortmaker wrote:
> > This bit of information is in the Kconfig help text:
> > 
> >   Note the boot CPU will still be kept outside the range to
> >   handle the timekeeping duty.
> > 
> > However neither the variable NO_HZ_FULL_ALL, or the prompt
> > convey this important detail, so lets add it to the prompt
> > to make it more explicitly obvious to the average user.
> > 
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> > ---
> >  kernel/time/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> > index 3ce6e8c5f3fc..76a1fbef1fd8 100644
> > --- a/kernel/time/Kconfig
> > +++ b/kernel/time/Kconfig
> > @@ -124,7 +124,7 @@ config NO_HZ_FULL
> >  endchoice
> > 
> >  config NO_HZ_FULL_ALL
> > -       bool "Full dynticks system on all CPUs by default"
> > +       bool "Full dynticks system on all (but boot) CPUs by default"

Looks good. Now we are all using "boot CPU" to refer to the CPU 0, but it may
not sound that obvious to everyone.

How about: "Full dynticks system on all CPUs by default (expect CPU 0)" ?

Sure this is a temporary behaviour until I get the sysidle detection use patchset in shape,
but indeed worth a big fat warning until we sort it out.

Thanks!

> >         depends on NO_HZ_FULL
> >         help
> >           If the user doesn't pass the nohz_full boot option to
> > -- 
> > 1.8.5.2
> > 
> 
