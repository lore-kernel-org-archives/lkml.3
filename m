Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab3IJUi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:38:59 -0400
Received: from imap.thunk.org ([74.207.234.97]:57834 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab3IJUi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:38:57 -0400
Date: Tue, 10 Sep 2013 16:38:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: John Stultz <john.stultz@linaro.org>
Cc: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130910203853.GG29237@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	John Stultz <john.stultz@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
References: <10005394.BRCyBMYWy3@tauon>
 <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 12:38:56PM -0700, John Stultz wrote:
> So the end of timekeeping_init() may not be what you want here. This
> only means we've started up the timekeping core with only the default
> clocksource (with only few exceptions, this is almost always jiffies).
> Then as clocksource drivers are initialized, they are registered and
> the timekeeping core will switch over to the best available
> clocksource.  Also, to avoid the churn at boot of switching to every
> clocksource registered, we queue them up and wait until fs_init time
> to switch to whatever is the best available then.

Is there any indication in the clocksource structures where we can
determine what the cost (in CPU, time, bus overhead, etc.) for a
particular clock source, verus the granularity of the clock source?

Also, is it always safe to read from a clock source from an interrupt
handler?

Thanks,

					- Ted
