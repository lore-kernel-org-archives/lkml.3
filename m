Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab3DYEtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 00:49:20 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49752 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3DYEtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 00:49:18 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 24 Apr 2013 21:49:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Li Zefan <lizefan@huawei.com>
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] hrtimer, add expiry time overflow check in
 hrtimer_interrupt
Message-ID: <20130425044952.GA17412@roeck-us.net>
References: <1365425235-26191-1-git-send-email-prarit@redhat.com>
 <5163264B.3050707@linaro.org>
 <516329D2.1050003@redhat.com>
 <20130424224218.GA7767@roeck-us.net>
 <5178890E.9090201@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5178890E.9090201@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 09:38:22AM +0800, Li Zefan wrote:
> On 2013/4/25 6:42, Guenter Roeck wrote:
> > On Mon, Apr 08, 2013 at 04:34:26PM -0400, Prarit Bhargava wrote:
> >>
> >>
> >> On 04/08/2013 04:19 PM, John Stultz wrote:
> >>> On 04/08/2013 05:47 AM, Prarit Bhargava wrote:
> >>
> >>>>
> >>>> A simple check for an overflow can resolve this problem.  Using KTIME_MAX
> >>>> instead of the overflow value will result in the hrtimer function being run,
> >>>> and the reprogramming of the timer after that.
> >>>>
> >>>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> >>>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>>> Cc: John Stultz <john.stultz@linaro.org>
> >>>
> >>> Prarit: Should this be tagged for -stable?
> >>
> >> John,
> >>
> >> Yes, this should go to -stable.  cc'd.
> >>
> > Hi,
> > 
> > I am a bit surprised that this patch has not found its way into mainline yet,
> > as everyone seems to agree that it is a candidate for -stable.
> > 
> > I hit this problem very reliably (ie with each boot) with 3.8.x on systems
> > which have no RTC and run systemd. Seen with Freescale P5040 as well as
> > a Broadcom MIPS based system.
> > 
> 
> FYI, we also hit this warning with 3.4-rt.
> 
You are lucky if it is just a warning for you. In my case the system is
reliably dead. Guess there are not (yet) many users out there using
systemd (or something similar) on a system with no RTC.

While I am not too happy about the delay to get the patch integrated,
I am glad that Prarit found and fixed the problem. Saved me a lot of time.

Guenter
