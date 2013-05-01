Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577Ab3EAQY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:24:59 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49275 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761542Ab3EAQYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:24:51 -0400
Date: Wed, 1 May 2013 09:24:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Colin Cross <ccross@android.com>
Cc: Pavel Machek <pavel@ucw.cz>, Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: Re: [RFC PATCH] drivers: power: Add watchdog timer to catch drivers
 which lockup during suspend.
Message-ID: <20130501162448.GA6245@kroah.com>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
 <20130501003058.GB20042@amd.pavel.ucw.cz>
 <CAMbhsRQkYFvOzDDn4zmbZAEsVs6iSy4mPVq5w=MzQ7p9STBDew@mail.gmail.com>
 <20130501105630.GA22552@amd.pavel.ucw.cz>
 <CAMbhsRTtYSLpAmB0hsanBH3ez4bm8BgbcH1xEBQsZSj4dc069g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRTtYSLpAmB0hsanBH3ez4bm8BgbcH1xEBQsZSj4dc069g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 09:10:49AM -0700, Colin Cross wrote:
> I'm not saying this patch as is is right for everyone (it probably at
> least needs to be configurable to be turned off, change the delay, and
> change the panic to just a stack trace),

Those changes would be nice.

> but from a mobile perspective
> this patch is far more debuggable than without this patch.  We work
> very hard to make sure that panic's are highly debuggable, in fact we
> often prefer panics over any other behavior when the device is in a
> bad state, because it immediately gets the user's device working again
> while still giving us useful information in our automatic log
> collection.
> 
> With an mdelay(100000) in the suspend path, users in our debug device
> pool are likely to just pull the battery because their screen won't
> turn on, in which case I get no debugging information.  With this
> patch, the device will automatically reboot due to the panic, and I
> will get captured logs after reboot that show a stack trace ending
> with mdelay, which tells me exactly where to look for this
> mdelay(100000).

All of that information would be _great_ to have in the changelog for
the patch, as it explains exactly why you need this.  {hint}

thanks,

greg k-h
