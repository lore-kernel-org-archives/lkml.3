Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3I0Rkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:40:36 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:42023 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab3I0Rkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:40:35 -0400
MIME-Version: 1.0
In-Reply-To: <1380279555.28494.171.camel@i7.infradead.org>
References: <20130919194752.GA19975@quad.lixom.net>
	<1379626776.753.164.camel@shinybook.infradead.org>
	<CAN8TOE8j=oosn-5hAdqoTPcuW-sGvDAHd_nK6BZfJpxMwwpisQ@mail.gmail.com>
	<1379632757.12963.4.camel@shinybook.infradead.org>
	<CAN8TOE8Xf9fv9zyY6wof3b9QhqgV=s-cK4V4D6n+Gw4HgacT0g@mail.gmail.com>
	<1380279555.28494.171.camel@i7.infradead.org>
Date: Fri, 27 Sep 2013 10:40:34 -0700
Message-ID: <CAN8TOE9wyXdCSBWJhf-XnzzxGd+x=ux4oJcjq1n5b5E0rW1gyA@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SoC fixes for 3.12-rc
From: Brian Norris <computersforpeace@gmail.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Olof Johansson <olof@lixom.net>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 3:59 AM, Woodhouse, David
<david.woodhouse@intel.com> wrote:
> On Thu, 2013-09-19 at 17:44 -0700, Brian Norris wrote:
>> > Does that m25p80 'fix 4 byte addressing' fix for Micron not also want to
>> > go in?
>>
>> I suppose the m25p80 one can go in as well. It's not so much a bugfix
>> as augmenting my original patch to support more devices. But it is
>> safe enough.
>
> You say 'support more devices', but AFAICT the code in -rc1 will already
> *attempt* to enable 4-byte addressing on those devices, and fail.

As will the code in every release since 3.7-rc1 (commit
8da28681eb1430fb6715c7aef67001acfbbbcba5).

> (It looks like set_4byte() can return failure, but its return code isn't
> checked, and anyway it's only a SPI write so there's no feedback from
> the *chip* if it fails due to lack of WREN; it can only indicate failure
> if the SPI connection falls over.)
>
> So I'm inclined to think of it as a bug fix and include it.

Sure, it's a bug fix. Just a long-standing bug. We were sending
invalid commands to Micron devices, so no n25q256a devices could have
possibly been supported properly before the 3.12-rc cycle [*]. I'm not
sure who actually tested these flash way back in 3.7. I still would
qualify them as "new devices" for 3.12, but that's just semantics now.
Please, do include it.

Brian

[*] Under special circumstances they could have been supported. For
instance, some n25q256a packages defaulted to 4-byte addressing mode.
