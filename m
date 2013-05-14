Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab3ENPOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:14:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:40450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3ENPOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:14:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="302300044"
Date: Tue, 14 May 2013 23:11:07 +0800
From: Feng Tang <feng.tang@intel.com>
To: David Vrabel <david.vrabel@citrix.com>,
        John Stultz <john.stultz@linaro.org>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130514151107.GA6661@feng-snb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcc: 
Subject: Re: [PATCH 2/3] timekeeping: sync persistent clock and RTC on system time step changes
Reply-To: 

Hi David,

> From: David Vrabel <david.vrabel@citrix.com>
> Date: 2013/5/14
> Subject: Re: [PATCH 2/3] timekeeping: sync persistent clock and RTC on
> system time step changes
> To: John Stultz <john.stultz@linaro.org>
> Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, Konrad
> Rzeszutek Wilk <konrad.wilk@oracle.com>, Thomas Gleixner
> <tglx@linutronix.de>, "linux-kernel@vger.kernel.org"
> <linux-kernel@vger.kernel.org>
> 
> 
> On 14/05/13 01:40, John Stultz wrote:
> > On 05/13/2013 10:56 AM, David Vrabel wrote:
> >> From: David Vrabel <david.vrabel@citrix.com>
> >>
> >> The persistent clock or the RTC is only synchronized with system time
> >> every 11 minutes if NTP is running.  This gives a window where the
> >> persistent clock may be incorrect after a step change in the time
> >> (such as on first boot).
> >>
> >> This particularly affects Xen guests as until an update to the control
> >> domain's persistent clock, new guests will start with the incorrect
> >> system time.
> >>
> >> When there is a step change in the system time, call
> >> update_persistent_clock or rtc_set_ntp_time() to synchronize the
> >> persistent clock or RTC to the new system time.
> >
> > I'm sorry, this isn't quite making sense to me. Could you further
> > describe the exact problematic behavior you're seeing here, and why its
> > a problem?
> 
> The Xen wallclock is used as the persistent clock for Xen guests.  This
> is initialized (by Xen) with the CMOS RTC at the start of day.  If the
> RTC is incorrect then guests will see an incorrect wallclock time until
> dom0 has corrected it.
> 
> Currently dom0 only updates the Xen wallclock with the 11 min periodic
> work when NTP is synced.  This leaves a window where newly started
> guests will see an incorrect wallclock time.  This can cause guests to
> fail to start correctly if the wallclock is now behind what it was when
> the guest last started. (e.g., fsck of its disk fails as its last mount
> time appears to be far into the future).

Is it possible for Xen to resync its wallclock time from the RTC device
whenever it gets a request of starting a new guest? as usually a new
guest OS needs to get the time base from Xen's wallclock anyway.

Thanks,
Feng

