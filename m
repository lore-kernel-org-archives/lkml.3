Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab3D3Xah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:30:37 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38381 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705Ab3D3Xae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:30:34 -0400
Date: Tue, 30 Apr 2013 16:30:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>, Todd Poynor <toddpoynor@google.com>,
        San Mehat <san@google.com>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>
Subject: Re: [RFC PATCH] drivers: power: Add watchdog timer to catch drivers
 which lockup during suspend.
Message-ID: <20130430233031.GA32310@kroah.com>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 03:28:33PM -0700, Zoran Markovic wrote:
> From: Benoit Goby <benoit@android.com>
> 
> Below is a patch from android kernel that detects a driver suspend
> lockup and captures dump in the kernel log. Please review and provide
> comments.

There's this really cool thing called a watchdog driver that does stuff
like this :)

> Rather than hard-lock the kernel, dump the suspend thread stack and
> BUG() when a driver takes too long to suspend.  The timeout is set to
> 12 seconds to be longer than the usbhid 10 second timeout.
> 
> Exclude from the watchdog the time spent waiting for children that
> are resumed asynchronously and time every device, whether or not they
> resumed synchronously.

No, don't add a driver-core-only timer, use the existing watchdog timers
if you are worried about the kernel locking up.

thanks,

greg k-h
