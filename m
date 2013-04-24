Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab3DXWls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:41:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63251 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272Ab3DXWlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:41:46 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 24 Apr 2013 15:42:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] hrtimer, add expiry time overflow check in
 hrtimer_interrupt
Message-ID: <20130424224218.GA7767@roeck-us.net>
References: <1365425235-26191-1-git-send-email-prarit@redhat.com>
 <5163264B.3050707@linaro.org>
 <516329D2.1050003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516329D2.1050003@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 04:34:26PM -0400, Prarit Bhargava wrote:
> 
> 
> On 04/08/2013 04:19 PM, John Stultz wrote:
> > On 04/08/2013 05:47 AM, Prarit Bhargava wrote:
> 
> >>
> >> A simple check for an overflow can resolve this problem.  Using KTIME_MAX
> >> instead of the overflow value will result in the hrtimer function being run,
> >> and the reprogramming of the timer after that.
> >>
> >> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: John Stultz <john.stultz@linaro.org>
> > 
> > Prarit: Should this be tagged for -stable?
> 
> John,
> 
> Yes, this should go to -stable.  cc'd.
> 
Hi,

I am a bit surprised that this patch has not found its way into mainline yet,
as everyone seems to agree that it is a candidate for -stable.

I hit this problem very reliably (ie with each boot) with 3.8.x on systems
which have no RTC and run systemd. Seen with Freescale P5040 as well as
a Broadcom MIPS based system.

Guenter
