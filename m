Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3LLSbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:31:11 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52999 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3LLSbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:31:07 -0500
Message-ID: <52AA00E6.2040700@linaro.org>
Date: Thu, 12 Dec 2013 10:31:02 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/5] timekeeping: Fix CLOCK_TAI timer/nanosleep delays
References: <1386789098-17391-1-git-send-email-john.stultz@linaro.org> <1386789098-17391-5-git-send-email-john.stultz@linaro.org> <20131212132518.GB16360@gmail.com>
In-Reply-To: <20131212132518.GB16360@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 05:25 AM, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
>> A think-o in the calculation of the monotonic -> tai time offset
>> results in CLOCK_TAI timers and nanosleeps to expire late (the
>> latency is ~2x the tai offset).
>>
>> Fix this by adding the tai offset from the realtime offset instead
>> of subtracting.
> Hm, it looks like the whole CLOCK_TAI feature was rushed in, with not 
> enough testing done.

I wouldn't say rushed (I sat on the patches for awhile), but there was a
hole in my testing and the order that I ran my automated tests had made
it seem that all was well.

To avoid this in the future, I've already committed improvements to my
test set, and will be adding additional timer latency checks soon.

> If the bugs extend to more than this two-liner then for -stable it 
> might be better to just disable CLOCK_TAI (userspace can deal with it 
> just fine), and queue up the right fixes for the next merge window or 
> so.

I don't foresee further issues (famous last words, eh), but since I was
planning on keeping patch #4 and #5 for 3.14 anyway, we can wait till
those land upstream to decide if the two-liner is sufficient or if
disabling CLOCK_TAI in older -stable kernels is the right approach. That
sound ok?

thanks
-john


