Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3EITER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:04:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41451 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab3EITEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:04:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Guenter Roeck <linux@roeck-us.net>
Cc: Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 0/3] pm: Introduce __pm to mark power management code
Date: Thu, 09 May 2013 21:12:40 +0200
Message-ID: <7892029.RG9lO6NoN5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1305091426070.1796-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1305091426070.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 09, 2013 02:31:46 PM Alan Stern wrote:
> On Thu, 9 May 2013, Guenter Roeck wrote:
> 
> > On Thu, May 09, 2013 at 01:38:36PM -0400, Alan Stern wrote:
> > > On Thu, 9 May 2013, Guenter Roeck wrote:
> > > 
> > > > The following patch series introduces a marker for power management functions
> > > > and data. This this marker, #ifdef CONFIG_PM and #ifdef CONFIG_PM_SLEEP
> > > > can be removed from most of the code. This ensures that the conditional code
> > > > still compiles but is not included in the object file.
> > > > 
> > > > As a side effect, drivers declaring struct dev_pm_ops unconditionally
> > > > get a bit smaller if CONFIG_PM_SLEEP is not configured.
> > > 
> > > What about code that depends on CONFIG_PM_RUNTIME?  Or code that 
> > > depends on CONFIG_PM_SLEEP but not on CONFIG_PM_RUNTIME?
> > > 
> > Should we also introduce __pm_sleep and __pm_runtime ?
> 
> If you want to implement this correctly, I think you have to.
> 
> As for whether the additional complication is desirable ... I'll leave 
> that up to Rafael to decide.

Well, if that had been so easy to do, we would have done it already before.

I think that we first should try to combine PM_SLEEP with PM_RUNTIME (plus
some other power management options related to CPU PM) and then introduce
something like __pm.  Otherwise, it's going to be a mess.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
