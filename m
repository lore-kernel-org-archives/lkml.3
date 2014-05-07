Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaEGAZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 20:25:36 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61805 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaEGAZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 20:25:35 -0400
Message-ID: <53697D7D.4020908@linaro.org>
Date: Tue, 06 May 2014 17:25:33 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Riley <davidriley@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add test to validate udelay
References: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
In-Reply-To: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 05:12 PM, David Riley wrote:
> This change adds a module and a script that makes use of it to
> validate that udelay delays for at least as long as requested
> (as compared to ktime).

Interesting.

So fundamentally, udelay is a good bit fuzzier accuracy wise then
ktime_get(), as it may be backed by relatively coarsely calibrated delay
loops, or very rough tsc freq estimates.

ktime_get on the other hand is as fine grained as we can be, and is ntp
corrected, so that a second can really be a second.

So your comparing the fast and loose interface so we can delay a bit
before hitting some hardware again with a fairly precise interface.
Thus  I'd not be surprised if your test failed on various hardware. I'd
really only trust udelay to be roughly accurate, so you might want to
consider adding some degree of acceptable error to the test.

Really, I'm curious about the backstory that made you generate the test?
I assume something bit you where udelay was way off? Or were you using
udelay for some sort of accuracy sensitive use?

thanks
-john

