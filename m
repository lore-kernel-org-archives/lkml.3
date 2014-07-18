Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbaGRAaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:30:39 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51518 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754520AbaGRAai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:30:38 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
Date: Fri, 18 Jul 2014 02:48:55 +0200
Message-ID: <1631950.JQ8G2kkfYE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1407171021250.1517-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1407171021250.1517-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 17, 2014 10:27:44 AM Alan Stern wrote:
> On Thu, 17 Jul 2014, Rafael J. Wysocki wrote:
> 
> > On Wednesday, July 16, 2014 04:03:45 PM Greg Kroah-Hartman wrote:
> > > On Thu, Jul 17, 2014 at 12:40:23AM +0200, Rafael J. Wysocki wrote:
> > > > On Wednesday, July 02, 2014 10:27:06 AM Alan Stern wrote:
> > > > > Here's a brief summary of the story behind this patch...
> > > > > 
> > > > > At one point, I suggested to Dan that instead of doing something
> > > > > special for these devices, we could simply have the runtime_suspend()
> > > > > routine always return -EBUSY.  He didn't like that idea because then
> > > > > the user would see the device was never powering down but would have no
> > > > > idea why.  The rpm_not_supported flag provides this information to the
> > > > > user by causing the power/runtime_status attribute to say "not
> > > > > supported".  (Although to be entirely fair, we could just put a message
> > > > > in the kernel log during probe if the hardware doesn't support runtime
> > > > > suspend.)
> > > > > 
> > > > > Instead, Dan introduced a messy PM QoS mechanism in commit
> > > > > e3d105055525.  I didn't like that approach, but Greg merged it before I
> > > > > objected.
> > > > 
> > > > That really looks a bit like a hack to me to be honest.
> 
> My thought exactly.

I'm also wondering why it unregisters the device if dev_pm_qos_add_request()
fails instead simply avoiding to enable runtime PM in that case (just a side
note).

> > > > Greg, what's your plan toward this?
> > > 
> > > If I need to revert something that you all find was wrong, I'll be glad
> > > to do so, sorry for merging something too early.
> > 
> > Alan, what do you think?
> 
> I'm in favor of reverting that commit and putting something else in its 
> place.  But first we have to figure out an approach that will satisfy 
> everyone.
> 
> I've been hoping that Dan would contribute to this thread.  He has
> spear-headed this whole line of development, and he wrote the commit in
> question.
> 
> Maybe he would be happy with the simplest approach: If the device
> doesn't support runtime PM, write a message in the kernel log and make
> ->runtime_suspend() always return -EBUSY.

And I wonder how commit e3d105055525 allows the user to check that the
device is in the "always active" mode.  I guess by the fact that the
PM QoS flags are not visible in sysfs then, but that's far from obvious
in my view.

Rafael

