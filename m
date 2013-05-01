Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab3EAERn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 00:17:43 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:42296 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3EAERf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 00:17:35 -0400
Date: Tue, 30 Apr 2013 21:17:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Colin Cross <ccross@android.com>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: Re: [RFC PATCH] drivers: power: Add watchdog timer to catch drivers
 which lockup during suspend.
Message-ID: <20130501041731.GA24128@kroah.com>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
 <20130430233031.GA32310@kroah.com>
 <CAMbhsRSV+om7w2f1ht6hLmK_BrgjjQZ91iBJzR5ySTytQdndBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRSV+om7w2f1ht6hLmK_BrgjjQZ91iBJzR5ySTytQdndBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 08:36:21PM -0700, Colin Cross wrote:
> On Tue, Apr 30, 2013 at 4:30 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Apr 30, 2013 at 03:28:33PM -0700, Zoran Markovic wrote:
> >> From: Benoit Goby <benoit@android.com>
> >>
> >> Below is a patch from android kernel that detects a driver suspend
> >> lockup and captures dump in the kernel log. Please review and provide
> >> comments.
> >
> > There's this really cool thing called a watchdog driver that does stuff
> > like this :)
> 
> If the watchdog driver worked in this case this patch wouldn't exist.

Great, let's fix the watchdog timer then :)

What's wrong with it?

> >> Rather than hard-lock the kernel, dump the suspend thread stack and
> >> BUG() when a driver takes too long to suspend.  The timeout is set to
> >> 12 seconds to be longer than the usbhid 10 second timeout.
> >>
> >> Exclude from the watchdog the time spent waiting for children that
> >> are resumed asynchronously and time every device, whether or not they
> >> resumed synchronously.
> >
> > No, don't add a driver-core-only timer, use the existing watchdog timers
> > if you are worried about the kernel locking up.
> 
> The watchdog timers are useless here.  For one, they generally stop
> when their driver suspend op is called, so you may not even have one
> running when you lock up.

But you can fix that, right?

> More importantly, the purpose of this patch is to tell you which
> driver locked up and hopefully why, and the watchdog driver will
> usually result in a silent reset.

I thought it was an option as to what the watchdog does when it
triggers.

> This patch will cause a stack trace of the driver suspend op that is
> blocking suspend progress, even if that call does not happen in the
> suspend thread.

But who can see this, the machine is now dead.

greg k-h
