Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaIPRWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:22:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33775 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753000AbaIPRWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:22:12 -0400
Date: Tue, 16 Sep 2014 13:22:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vinod Koul <vinod.koul@intel.com>
cc: "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: Add helper to mark last busy and autosuspend
In-Reply-To: <20140916153635.GS3131@intel.com>
Message-ID: <Pine.LNX.4.44L0.1409161318510.1166-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, Vinod Koul wrote:

> > > > What's the advantage?  Removing a few bytes of source code?  There will 
> > > > no change to the object code.  (Not to mention that your patch didn't 
> > > > actually change _any_ of the places where both routines get called!)
> > > Yes we didnt change users, as we need this for one of our drivers we are
> > > trying to push.
> > 
> > Why do you need it?  Just change your driver to call
> > 
> > 	pm_runtime_mark_last_busy(dev);
> > 	pm_runtime_put_autosuspend(dev);
> > 
> > instead of
> > 
> > 	pm_runtime_last_busy_and_autosuspend(dev);
> > 
> > Or create a subroutine in your driver to do this.
> Well since this is common why not add a helper in framework!

You said this was common, but you didn't change any of the other places
these routines get used.  I asked why and you didn't asnwer; all you
said was that you needed it for one of your drivers.

I then pointed out that you don't need it.  You didn't asnwer.

I asked what advantage this change brings.  You didn't answer.

Alan Stern

