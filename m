Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029AbaHIEDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 00:03:16 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:54714 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaHIEDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 00:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140809003217.GS25145@thunk.org>
References: <CALAqxLWAXU0hS8si-CmkOObBOHGv_skMVfPnUsdmLcZzkdUsWA@mail.gmail.com>
	<53E53DCD.2020707@linaro.org>
	<CAGXu5j+Q8F8TKy8sxCL6pxD-cni4RKxy46HwsCSZE+mWpuyn-g@mail.gmail.com>
	<53E568B2.40206@linaro.org>
	<20140809003217.GS25145@thunk.org>
Date: Fri, 8 Aug 2014 21:03:14 -0700
Message-ID: <CALAqxLWGH60wnqYcV30=Ovv4pRSU_VtJ_Lyz=QS4HBdHUqS52w@mail.gmail.com>
Subject: Re: [Regression] 3.15 mmc related ext4 corruption with qemu-system-arm
From: John Stultz <john.stultz@linaro.org>
To: "Theodore Ts'o" <tytso@mit.edu>, John Stultz <john.stultz@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Johan Rudholm <jrudholm@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 5:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Aug 08, 2014 at 05:17:54PM -0700, John Stultz wrote:
>> On 08/08/2014 05:15 PM, Kees Cook wrote:
>> > On Fri, Aug 8, 2014 at 2:14 PM, John Stultz <john.stultz@linaro.org> wrote:
>> >> I sunk a couple of weeks bisecting to try to narrow down the more
>> >> sporadic issue, but was unsuccessful past the initial commit above.
>> >> Since then I've been far too swamped to spend any more time on it. Even
>> >> so, its a *major* pain for testing but it seems like no one else really
>> >> cares?
>> > I'm in the same boat as far as poor bisection results. :(
>> >
>> > However, I keep using the 3-patch mmci fix series from Ulf, and
>> > haven't hit any trouble with them. Though perhaps I'm just getting
>> > lucky?
>> >
>> > http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=arm/fix-mmci
>>
>> I guess I'll give that another shot
>
> There was an ext4 bug that might have caused this problem.  It was
> fixed in v3.15.6 and v3.16-rc5.

Sweet! Many thanks to Eric for chasing that down (I spent a ton of
time with no results, so I can't imagine how much effort it took him)
and you for pointing it out.

So yes, so far I'm not seeing any filesystem panics w/ Linus' head  +
with Ulf's patches in Kees tree above. That makes me *very* happy.

Ulf: Are you planning to push those upstream (and to -stable) soon?

thanks
-john
