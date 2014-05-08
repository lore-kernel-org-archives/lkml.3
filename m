Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaEHOg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:36:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42633 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753238AbaEHOg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:36:26 -0400
Date: Thu, 8 May 2014 10:36:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ulf Hansson <ulf.hansson@linaro.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of
 runtime-suspended devices
In-Reply-To: <CAPDyKFoPxXVYfK2ytGVJ8fYQDJXiSuaRX_6QtRYzffZVtKJfeA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405081028370.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Ulf Hansson wrote:

> >> Should we not depend on PM_RUNTIME only? Thus we don't need the new
> >> Kconfig,
> >
> > Well, OK.  I guess we can tolerate one useless statement in rpm_resume()
> > in case CONFIG_PM_SLEEP is unset.

It isn't a big deal.  However, Ulf, you need to understand that this 
API belongs to _both_ PM_SLEEP _and_ PM_RUNTIME.  It doesn't mean 
anything unless both are present.

But as Rafael said, the extra overhead if !CONFIG_PM_SLEEP is minimal.  
(Although I would move the new flag to be next to the other bitflags, 
so that it doesn't add an entire extra word to the dev_pm_info 
structure.)

> >> and then we could rename the new APIs to pm_runtime_* instead.
> >
> > That would just make the name longer - for what value?
> 
> Only "__set_leave_runtime_suspended" will be a bit longer.
> 
> The idea I had was to clearly indicate, these functions is a part of
> PM_RUNTIME API.

Not so.  They are part of both PM_SLEEP and PM_RUNTIME, which means
they are really just part of PM.  You can tell by the fact that they 
are used in both main.c and runtime.c.

Alan Stern

