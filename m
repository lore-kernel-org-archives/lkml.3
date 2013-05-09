Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab3EISbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:31:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39770 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751059Ab3EISbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:31:47 -0400
Date: Thu, 9 May 2013 14:31:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Guenter Roeck <linux@roeck-us.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, Jean Delvare <khali@linux-fr.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 0/3] pm: Introduce __pm to mark power management code
In-Reply-To: <20130509174822.GA30549@roeck-us.net>
Message-ID: <Pine.LNX.4.44L0.1305091426070.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 May 2013, Guenter Roeck wrote:

> On Thu, May 09, 2013 at 01:38:36PM -0400, Alan Stern wrote:
> > On Thu, 9 May 2013, Guenter Roeck wrote:
> > 
> > > The following patch series introduces a marker for power management functions
> > > and data. This this marker, #ifdef CONFIG_PM and #ifdef CONFIG_PM_SLEEP
> > > can be removed from most of the code. This ensures that the conditional code
> > > still compiles but is not included in the object file.
> > > 
> > > As a side effect, drivers declaring struct dev_pm_ops unconditionally
> > > get a bit smaller if CONFIG_PM_SLEEP is not configured.
> > 
> > What about code that depends on CONFIG_PM_RUNTIME?  Or code that 
> > depends on CONFIG_PM_SLEEP but not on CONFIG_PM_RUNTIME?
> > 
> Should we also introduce __pm_sleep and __pm_runtime ?

If you want to implement this correctly, I think you have to.

As for whether the additional complication is desirable ... I'll leave 
that up to Rafael to decide.

Alan Stern

