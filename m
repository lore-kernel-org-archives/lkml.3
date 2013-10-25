Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3JYJPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:15:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3JYJPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:15:39 -0400
Date: Fri, 25 Oct 2013 10:17:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
Message-ID: <20131025091717.GA10636@kroah.com>
References: <525BD08C.2080101@t-online.de>
 <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
 <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
 <CA+55aFyPffR=kt4njmB7oG012kayrKJPsP-u5JR+s7rERjofCg@mail.gmail.com>
 <20131025090809.GZ4118@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025090809.GZ4118@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 02:08:09AM -0700, Paul E. McKenney wrote:
> On Fri, Oct 25, 2013 at 10:02:22AM +0100, Linus Torvalds wrote:
> > Adding more people, so quoting the whole email for them.
> > 
> > We definitely have some module unload issues. Guys, try the following
> > a few times to unload modules:
> > 
> >     lsmod | grep ' 0 '| cut -d' ' -f1 | xargs sudo rmmod
> > 
> > (a few times because unloading one module will then potentially make
> > other modules unloadable).
> 
> Isn't it still the user's responsibility to ensure that a module will
> no longer being used before rmmod-ing it?  Or were all those race
> conditions fixed?

If the module count is allowing the unload to happen, then the driver
should handle the issues.  Userspace shouldn't have to "know" if it can
unload it or not.

thanks,

greg k-h
