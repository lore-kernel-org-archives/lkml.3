Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3LLNZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:25:24 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:40056 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3LLNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:25:22 -0500
Date: Thu, 12 Dec 2013 14:25:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/5] timekeeping: Fix CLOCK_TAI timer/nanosleep
 delays
Message-ID: <20131212132518.GB16360@gmail.com>
References: <1386789098-17391-1-git-send-email-john.stultz@linaro.org>
 <1386789098-17391-5-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386789098-17391-5-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> A think-o in the calculation of the monotonic -> tai time offset
> results in CLOCK_TAI timers and nanosleeps to expire late (the
> latency is ~2x the tai offset).
> 
> Fix this by adding the tai offset from the realtime offset instead
> of subtracting.

Hm, it looks like the whole CLOCK_TAI feature was rushed in, with not 
enough testing done.

If the bugs extend to more than this two-liner then for -stable it 
might be better to just disable CLOCK_TAI (userspace can deal with it 
just fine), and queue up the right fixes for the next merge window or 
so.

Thanks,

	Ingo
