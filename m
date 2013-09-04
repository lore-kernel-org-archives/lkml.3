Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881Ab3IDUzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:55:00 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48109 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3IDUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:54:57 -0400
Message-ID: <52279E1D.3060907@linaro.org>
Date: Wed, 04 Sep 2013 13:54:53 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Arun Sharma <asharma@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        Kumar Sundararajan <kumar@fb.com>
Subject: Re: clock_gettime_ns
References: <5226FAE1.5070201@fb.com> <CALCETrWify68=_bVmFfnTWH5vY3NgxDChr_cvL7v6VovaSJdKA@mail.gmail.com> <CANcMJZAi_738t-eDUphC6U_25xFS0NqQqdUZAzu7Aijqmrj=wA@mail.gmail.com> <CALCETrVc-3j=7bP13dkYwqxUg77rdauHQ8_KEti0khh-HX220A@mail.gmail.com>
In-Reply-To: <CALCETrVc-3j=7bP13dkYwqxUg77rdauHQ8_KEti0khh-HX220A@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:33 PM, Andy Lutomirski wrote:
> On Wed, Sep 4, 2013 at 12:20 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On Wed, Sep 4, 2013 at 11:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> I think that most of the hangup was a lack of agreement on how the API
>>> should work wrt leap seconds.
>> I don't recall this objection. The interface uses existing clockids,
>> so it probably should keep the existing leap-second behavior of those
>> clockids.
>>
>>> I've always thought that the Right Way to represent a UTC time is
>>> nanoseconds since some epoch, where every potential leap second
>>> counts.
>> Check out the CLOCK_TAI clockid merged in 3.10.
>>
> I never really liked that -- CLOCK_TAI doesn't tell what time it is in
> any format that normal people understand.
>
> I'd advocate for going whole hog and returning, atomically:
>
>  - TAI (nanoseconds from epoch)
>  - UTC - TAI (seconds or nanoseconds) *
>  - TAI - CLOCK_MONOTONIC (nanoseconds)
>  - a leap second flag.
>
> * There are various ways to define this.  My fancy UTC - TAI wouldn't
> actually need the leap-second flag, since the UTC time would indicate
> leap seconds directly.  With the conventional approach, someone would
> have to decide whether the leap second count increments at the
> beginning or the end of the leap second.

Well, adjtimex() gives you UTC & tai offset & leapsecond flag in one go.

thanks
-john

