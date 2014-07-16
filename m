Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaGPXJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:09:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50467 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754155AbaGPXJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:09:30 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
Date: Thu, 17 Jul 2014 01:27:45 +0200
Message-ID: <1961774.JeWiFOnpio@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140716230345.GA3220@kroah.com>
References: <Pine.LNX.4.44L0.1407021002380.874-100000@iolanthe.rowland.org> <1908592.0t6juNfLFj@vostro.rjw.lan> <20140716230345.GA3220@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2014 04:03:45 PM Greg Kroah-Hartman wrote:
> On Thu, Jul 17, 2014 at 12:40:23AM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, July 02, 2014 10:27:06 AM Alan Stern wrote:
> > > Here's a brief summary of the story behind this patch...
> > > 
> > > At one point, I suggested to Dan that instead of doing something
> > > special for these devices, we could simply have the runtime_suspend()
> > > routine always return -EBUSY.  He didn't like that idea because then
> > > the user would see the device was never powering down but would have no
> > > idea why.  The rpm_not_supported flag provides this information to the
> > > user by causing the power/runtime_status attribute to say "not
> > > supported".  (Although to be entirely fair, we could just put a message
> > > in the kernel log during probe if the hardware doesn't support runtime
> > > suspend.)
> > > 
> > > Instead, Dan introduced a messy PM QoS mechanism in commit
> > > e3d105055525.  I didn't like that approach, but Greg merged it before I
> > > objected.
> > 
> > That really looks a bit like a hack to me to be honest.
> > 
> > Greg, what's your plan toward this?
> 
> If I need to revert something that you all find was wrong, I'll be glad
> to do so, sorry for merging something too early.

Alan, what do you think?

I think we're still unsure if the approach taken by that commit is correct,
but then I suppose we don't need to revert it at this point and we can fix
it later.  Is that correct, or would fixing it be difficult for some reason?

Rafael

