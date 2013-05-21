Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3EURYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:24:24 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:50771 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab3EURYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:24:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130521151143.GH10453@mudshark.cambridge.arm.com>
References: <20130516153553.GI11706@mudshark.cambridge.arm.com>
	<1369139597-24446-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130521151143.GH10453@mudshark.cambridge.arm.com>
Date: Tue, 21 May 2013 20:24:15 +0300
Message-ID: <CAHp75VdRn8baf0ak57HpoJKNues6vEsjBp1uOQ2Zpvwa+B5rjA@mail.gmail.com>
Subject: Re: [PATCH] dmatest: abort transfers immediately when asked for
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, "djbw @ fb . com" <djbw@fb.com>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel @ lists . infradead . org" 
	<linux-arm-kernel@lists.infradead.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 6:11 PM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Andy,
>
> On Tue, May 21, 2013 at 01:33:17PM +0100, Andy Shevchenko wrote:
>> When thread is going to be stopped we have to unconditionally terminate all
>> ongoing transfers. Otherwise it would be possible that callback function will
>> be called on the next interrupt and will try to access to already freed
>> structures.
>>
>> The patch introduces specific error message for this, though it doesn't
>> increase the counter of the failed tests.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Reported-by: Will Deacon <will.deacon@arm.com>
>
> Thanks for persevering with this! Although this patch definitely fixes the
> panic I was seeing, I now observe buffer verification failures in subsequent
> test runs after an aborted run:

I think the description to the commit adfa543e "dmatest: don't use
set_freezable_with_signal()" may shed light on this.

The background (if  I got it correctly) is in race with done flag. So,
we got a callback call from the DMA engine, but we don't know which
transfer triggers it.
I might be wrong. This is just an assumption.

Have you ever see such behaviour on pre v3.10-rc1 kernels? (I mean
with old dmatest module)

--
With Best Regards,
Andy Shevchenko
