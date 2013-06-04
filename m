Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab3FDHZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:25:17 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:43899 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759456Ab3FDHZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:25:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130603232941.GC18220@jonmason-lab>
References: <1368813243-29547-1-git-send-email-jon.mason@intel.com>
	<CAHp75VfABzMAg7Ue+Mj_wsnXWsCzJrNH1HR-nbAQq5A2i9ncyw@mail.gmail.com>
	<20130603232941.GC18220@jonmason-lab>
Date: Tue, 4 Jun 2013 10:25:12 +0300
Message-ID: <CAHp75VdgKDx8vhTcUD5sBLd7aB=39SFxi-ayioZqE6o_AtZkxA@mail.gmail.com>
Subject: Re: [PATCH] dmatest: add ability to disable pq and xor
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jon Mason <jon.mason@intel.com>
Cc: Dan Williams <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 2:29 AM, Jon Mason <jon.mason@intel.com> wrote:
> On Fri, May 31, 2013 at 11:22:10AM +0300, Andy Shevchenko wrote:
>> On Fri, May 17, 2013 at 8:54 PM, Jon Mason <jon.mason@intel.com> wrote:
>> > dmatest would create a thread to stress XOR and PQ, if the capability is
>> > present in the hardware.  Add the ability to disable XOR and PQ by
>> > disabling it if *_sources are set to zero.
>>
>> Sorry, didn't comment this earlier.
>>
>> Those threads are independent including MEMCPY stuff.
>> I think it's better to have one additional parameter let's say
>> type_of_test where you can set
>> 1 for MEMCPY
>> 2 for XOR
>> 4 for PQ
>>
>> Share this parameter via debugfs and use 0x07 as default value.
>> I doubt we need this as a module parameter.
>
> This is using the existing module parameter, so there is nothing new
> added.

That's why it's a bit confusing. User can more easily forget the
'magic' numbers. And I see no reason to prevent user to enter 0 as a
number of sources.
Moreover, your patch doesn't cover the case when user doesn't want to
run MEMCPY thread.

>  Since the testing is started immediately upon module
> insertion,

It used to be so, but nowadays it's true only when dmatest is compiled in.
If someone wants to compile in that module they probably want to run
stress tests, where XOR and PQ might be useful.

> there needs to be a way to prevent it from ever starting.

My opinion I already shared, new node under debugfs. There is might be
a good reason to add a new module parameter as well.

--
With Best Regards,
Andy Shevchenko
