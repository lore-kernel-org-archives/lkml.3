Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab3DYVCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:02:37 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:36836 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab3DYVCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:02:35 -0400
Date: Thu, 25 Apr 2013 15:02:31 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Alexander Holler <holler@ahsoftware.de>, Kay Sievers <kay@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
Message-ID: <20130425210231.GE31863@obsidianresearch.com>
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
 <517746E4.908@linaro.org>
 <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
 <51774F44.2060704@linaro.org>
 <517769A9.5060308@ahsoftware.de>
 <51780348.6090202@linaro.org>
 <5178D719.2060405@ahsoftware.de>
 <5179562C.3000903@linaro.org>
 <20130425183301.GA31863@obsidianresearch.com>
 <51798BF4.5020602@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51798BF4.5020602@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 01:03:00PM -0700, John Stultz wrote:
> On 04/25/2013 11:33 AM, Jason Gunthorpe wrote:
> >John mentioned they might be kept for embedded - eg size reduction.
> >The issue with that idea is if you do not enable the class RTC
> >subsystem then there is no way for a small embedded userspace to set
> >the RTC. The /dev/rtc* device obviously goes away, but it also turns
> >out that that CONFIG_GENERIC_CMOS_UPDATE only works when combined with
> >a heavy weight userspace NTPD that runs the kernel PLL properly. The
> >kernel NTP code is enormously conservative and it is actually quite
> >hard to get it to write to the RTC. An RTC that cannot be set is
> >useless, so these days I feel CONFIG_RTC is pragmatically mandatory -
> >and my space constrained embedded systems do set it, for these
> >reasons.
> 
> So I mentioned that the size-reduciton focused folks might not like
> the generic rtc core over the persistent_clock code, but I'm not
> convinced that's a reason to keep the persistent clock code (which

What I mean is you can't actually choose to use persistent_clock over
rtc core, that is not a choice. The only choice these days it to omit
the user space interface to the RTC (eg rtc core). On some platforms
the RTC will still get *read* during boot via persisent_clock, but no
platform has a way for userspace to *set* via
persisent_clock. update_persisent_clock is not connected to userspace
anymore.

An unsettable RTC is useless, IMHO.

> I only noted it, because it has come up prior as a complaint when
> switching to the RTC core was proposed.

Sure, but, AFAIK, that was a general concern of /dev/rtc vs /dev/rtc0
- however since then we have lost /dev/rtc completely. That means
there is no longer any way to access the persistent_clock functions
from userspace.

Jason
