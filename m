Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaIDRsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:48:46 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52216 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaIDRsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:48:45 -0400
Date: Thu, 4 Sep 2014 18:48:40 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
Message-ID: <20140904174840.GB14822@e102568-lin.cambridge.arm.com>
References: <CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
 <53FE5B09.2020403@codeaurora.org>
 <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
 <53FE7E3B.1010500@codeaurora.org>
 <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
 <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
 <20140828093505.GC14650@leverpostej>
 <CAPz6YkUZkqgEBsPtX0uGpU+OzF5qdv1hGMXLo4iThUv-7B-Jbw@mail.gmail.com>
 <20140829100414.GA19424@leverpostej>
 <CAPz6YkVv1nbEumt9Q8gHAWddmECOm7DL=WLWfZKxBmzTfLQ00A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPz6YkVv1nbEumt9Q8gHAWddmECOm7DL=WLWfZKxBmzTfLQ00A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 04 Sep 2014 17:48:41.0174 (UTC) FILETIME=[76C3EF60:01CFC868]
X-MC-Unique: 114090418484303001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 06:01:27PM +0100, Sonny Rao wrote:

[...]

> > If an OS is booted at PL2 it can access the physical counters, and
> > should do so in case something like KVM will be used later. The OS can
> > write to CNTVOFF at PL2, and if it sets CNTVOFF to zero the physical and
> > virtual counters are equivalent. Thus it can use the virtual counters
> > and doesn't need to have additional code in several places (including
> > the VDSO) where it needs to choose to read which counters to read.
> >
> > The problem only exists where PL2 exists and the firmware/bootloader
> > skipped PL2 without initialising the necessary PL2 state. This is in
> > general a stupid thing to do; it introduces a problem that need not
> > exist and throws away the option of using the features PL2 provides.
> > This is a firmware/bootloader bug.
> 
> Well it's not quite that simple, this is actually an issue with the
> hardware that the CNTVOFF comes up with different values on different
> cores.  This happens not only at boot, but any time the core is
> powered on, which could include deep sleep or CPU hotplug and suspend
> to ram.  The firmware may not be involved in all these cases, so we
> cannot rely on it to fix this problem.

And why isn't firmware involved in those cases if it _is_ involved in
cold boot ? Resuming from low-power means resuming the machine/core as it
was when it was running before power down, anything that deviates from that
behaviour is a programming bug.

Lorenzo

