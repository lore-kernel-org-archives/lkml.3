Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3EUVm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:42:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3EUVm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:42:27 -0400
Date: Tue, 21 May 2013 14:42:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 3/4] rtc: rtc-hid-sensor-time: add option hctosys to set
 time at boot
Message-Id: <20130521144225.c42faaacf8aba55691cde5b7@linux-foundation.org>
In-Reply-To: <1367752887-2927-4-git-send-email-holler@ahsoftware.de>
References: <51765FB9.2050009@ahsoftware.de>
	<1367752887-2927-1-git-send-email-holler@ahsoftware.de>
	<1367752887-2927-4-git-send-email-holler@ahsoftware.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  5 May 2013 13:21:26 +0200 Alexander Holler <holler@ahsoftware.de> wrote:

> drivers/rtc/hctosys (CONFIG_RTC_HCTOSYS) doesn't work for
> rtc-hid-sensor-time because it will be called in late_init, and thus before
> rtc-hid-sensor-time gets loaded. To set the time through
> rtc-hid-sensor-time at startup, the module now checks by default if the
> system time is before 1970-01-02 and sets the system time (once) if this is
> the case.
> 
> To disable this behaviour, set the module option hctosys to zero, e.g. by
> using rtc-hid-sensor-time.hctosys=0 at the kernel command line if the
> driver is statically linked into the kernel.

I still find this rather unpleasant.  Partly because it's hacky, mainly
because it only solves the problem for one driver.

Can we please try harder to find a more general fix?

For example: if hctosys finds there are no drivers available, it sets a
flag.  Later when drivers are registered(?), that flag is queried and,
if set, we set the system time at this time.

Or something.
