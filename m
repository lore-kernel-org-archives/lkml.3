Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaLRVV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:21:56 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:56455 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLRVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:21:55 -0500
MIME-Version: 1.0
In-Reply-To: <2110446.Lbe6oKjkNj@wuerfel>
References: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr>
	<alpine.LFD.2.11.1412051251280.470@knanqh.ubzr>
	<2110446.Lbe6oKjkNj@wuerfel>
Date: Thu, 18 Dec 2014 13:21:54 -0800
Message-ID: <CALAqxLVzOAeOj8Rdo9=owEQ8Jy=-J1jQbaPoqxZqYJBdbwFTwA@mail.gmail.com>
Subject: Re: [PATCH] optimize ktime_divns for constant divisors
From: John Stultz <john.stultz@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 1:03 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 05 December 2014 13:00:22 Nicolas Pitre wrote:
>>
>> BTW this is worth applying despite the on-going discussion with Arnd
>> on a separate optimization.
>
> Agreed
>
>> On Wed, 3 Dec 2014, Nicolas Pitre wrote:
>>
>> > At least on ARM, do_div() is optimized to turn constant divisors into
>> > an inline multiplication by the reciprocal value at compile time.
>> > However this optimization is missed entirely whenever ktime_divns() is
>> > used and the slow out-of-line division code is used all the time.
>> >
>> > Let ktime_divns() use do_div() inline whenever the divisor is constant
>> > and small enough.  This will make things like ktime_to_us() and
>> > ktime_to_ms() much faster.
>> >
>> > Signed-off-by: Nicolas Pitre <nico@linaro.org>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>


Ok, I've queued the original patch up for testing.

thanks
-john
