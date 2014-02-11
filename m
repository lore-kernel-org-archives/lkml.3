Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaBKPYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:24:25 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34551 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaBKPYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:24:23 -0500
Date: Tue, 11 Feb 2014 07:24:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] nohz: ensure users are aware boot CPU is not
 NO_HZ_FULL
Message-ID: <20140211152416.GT4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <52F3D583.9070208@windriver.com>
 <1391711781-7466-1-git-send-email-paul.gortmaker@windriver.com>
 <20140210161933.GB21060@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210161933.GB21060@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021115-8236-0000-0000-000006F7F1FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:19:34PM +0100, Frederic Weisbecker wrote:
> On Thu, Feb 06, 2014 at 01:36:21PM -0500, Paul Gortmaker wrote:
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
> 
> Paul, I guess I can keep your ack on this 2nd version?

Please do!

						Thanx, Paul

> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> Applied, thanks a lot!
> 
> > ---
> > 
> > v2: use "CPU 0" instead of "boot CPU".
> > 
> >  kernel/time/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> > index 3ce6e8c5f3fc..f448513a45ed 100644
> > --- a/kernel/time/Kconfig
> > +++ b/kernel/time/Kconfig
> > @@ -124,7 +124,7 @@ config NO_HZ_FULL
> >  endchoice
> >  
> >  config NO_HZ_FULL_ALL
> > -       bool "Full dynticks system on all CPUs by default"
> > +       bool "Full dynticks system on all CPUs by default (except CPU 0)"
> >         depends on NO_HZ_FULL
> >         help
> >           If the user doesn't pass the nohz_full boot option to
> > -- 
> > 1.8.5.2
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

