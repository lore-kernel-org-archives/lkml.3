Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbaCEA6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:58:12 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:50100 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaCEA6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:58:10 -0500
MIME-Version: 1.0
In-Reply-To: <1393917011.5419.12.camel@marge.simpson.net>
References: <1393911500.6415.18.camel@marge.simpson.net>
	<CALAqxLUeb2GuPyULnHL+FHgbdanVxz2JsvD2O0bJWKyN=CJ3UQ@mail.gmail.com>
	<1393917011.5419.12.camel@marge.simpson.net>
Date: Wed, 5 Mar 2014 08:58:08 +0800
Message-ID: <CALAqxLVkDQO8nhFiX3avZ_dGyqH+uXCwLDzEMJbjp4i54Q9KaA@mail.gmail.com>
Subject: Re: [RFC][PATCH] clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()
From: John Stultz <john.stultz@linaro.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "Cc: Salman Qazi" <sqazi@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 3:10 PM, Mike Galbraith <bitbucket@online.de> wrote:
> On Tue, 2014-03-04 at 14:40 +0800, John Stultz wrote:
>> On Tue, Mar 4, 2014 at 1:38 PM, Mike Galbraith <bitbucket@online.de> wrote:
>> > (crap crap crap... M.A.I.N.T.A.I.N.E.R.S _dummy_)
>> >
>> > clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()
>> >
>> > As per 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock",
>> > cycles * mult >> shift is overflow prone. so give it the same treatment.
>> >
>> > Cc: Salman Qazi <sqazi@google.com>
>> > Cc: John Stultz <john.stultz@linaro.org>,
>> > Signed-off-by: Mike Galbraith <bitbucket@online.de>
>>
>> Thanks for sending this in!  Curious exactly how the issue was being
>> triggered?
>
> Dunno that it is.  This is the result of me rummaging around, looking
> for any excuse what-so-ever for a small and identical group of weird a$$
> boxen running old 2.6.32 kernels (w. 208 day fix!) to manage to hop back
> and forth in time by exactly 208 days.  Grep showed me that function, so
> I scurried off and swiped the fix.

So.. this makes me a bit more hesitant to really queue this,
particularly since the timecounter logic is supposed to periodically
accumulate cycles so you don't run into these overflow issues (the
earlier fix was for sched_clock which didn't do any accumulation).

So, if you're seeing time jump around, that's probably clocksource or
timekeping related, and not tied to the cyclecounter code. Do you have
any other info about these systems? What clocksource are they using,
etc?

thanks
-john
