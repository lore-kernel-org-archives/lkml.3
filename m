Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab3BOUwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:52:25 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:38647 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3BOUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:52:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAHp75VcT-3UUYZSc_iopH8M7z0GoYKhkf-O1yTsqSODRHaCHdw@mail.gmail.com>
References: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1360666720-19006-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<CACRpkdZ=9pmutR2G+z5kQpjx2O6995OnDU8iN3cqar3TWoX=Lg@mail.gmail.com>
	<CAHp75VcT-3UUYZSc_iopH8M7z0GoYKhkf-O1yTsqSODRHaCHdw@mail.gmail.com>
Date: Fri, 15 Feb 2013 21:52:23 +0100
Message-ID: <CACRpkdYVG6pHJ-_MQ2bTmk-rd7XUDkx1aXUW-Eqf6z2O16irYw@mail.gmail.com>
Subject: Re: [PATCH 3/6] dma: coh901318_lli: avoid unbalanced locking
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 3:56 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Feb 15, 2013 at 4:52 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Tue, Feb 12, 2013 at 11:58 AM, Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com> wrote:
>>
>>> I have not checked the code but there is a possibility that custom pool->lock
>>> is not needed at all due to dma_pool contains it's own lock.
>>
>> Can you please change the description to something like:
>>
>> "The coh901318_lli allocator releases a lock on the exit path without
>> taking it first".
>
> In v2 (that by fact already applied) I put following description:
>
>     In case the len is 0 we must return without trying to unlock the
> lock that was
>     not locked.
>
> Does it fit your suggestion?

Sure, acked-by.

Thanks,
Linus Walleij
