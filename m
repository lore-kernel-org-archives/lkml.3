Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631Ab3IDXU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:20:58 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46121 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab3IDXU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:20:56 -0400
Message-ID: <5227C056.1020604@linaro.org>
Date: Wed, 04 Sep 2013 16:20:54 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>, Arun Sharma <asharma@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>
Subject: Re: clock_gettime_ns
References: <5226FAE1.5070201@fb.com> <CALCETrWify68=_bVmFfnTWH5vY3NgxDChr_cvL7v6VovaSJdKA@mail.gmail.com> <CANcMJZAi_738t-eDUphC6U_25xFS0NqQqdUZAzu7Aijqmrj=wA@mail.gmail.com> <CALCETrVc-3j=7bP13dkYwqxUg77rdauHQ8_KEti0khh-HX220A@mail.gmail.com> <52279E1D.3060907@linaro.org> <5227B432.8070205@zytor.com> <5227BB50.7000301@linaro.org> <5227BC71.6000907@zytor.com>
In-Reply-To: <5227BC71.6000907@zytor.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 04:04 PM, H. Peter Anvin wrote:
> On 09/04/2013 03:59 PM, John Stultz wrote:
>> Also, there's been talk of a slewed-leap-second clockid, basically UTC
>> but around the leapsecond it slows down to absorb the extra second. This
>> means that clockid would have a subsecond offset from TAI.
>>
> Most of what I have heard seem to center around abolishing leap seconds
> entirely.  Now, I know that some users do slewed leap seconds as a
> unofficial policy to avoid rare events.
Well, Google does their own slewed leap-seconds internally (using a
modified ntp server to slow CLOCK_REALTIME on clients), and I believe
AIX also provides similar behavior w/ their CLOCK_REALTIME clockid (they
also provide CLOCK_UTC for those who have the need for UTC/leapseconds).
And there's also some occasional talk of trying to standardizing a
leap-second free UTC.

I suspect we have to have an all-of-the-above policy with the kernel. So
we now (as of 3.10) support CLOCK_TAI, as well as the UTC-based
CLOCK_REALTIME. If we can get some agreement on what the
slewed-leapsecond adjustment should look like (have to decide what the
slewing rate/range is: do we absorb the second over the last-hour,
half-hour, 15-minutes before and after?), then we can add such a clockid
(CLOCK_UTC_SLS?) to the kernel as well.

thanks
-john



