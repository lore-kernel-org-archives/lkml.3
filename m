Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3ICPeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:34:31 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34694 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab3ICPea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:34:30 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZyQQ0io9dPsmAs1xyoFgo0u262SZd3B=oUgh8gdWiGFQ@mail.gmail.com>
References: <1378204768-18013-1-git-send-email-treding@nvidia.com>
	<CACRpkdZyQQ0io9dPsmAs1xyoFgo0u262SZd3B=oUgh8gdWiGFQ@mail.gmail.com>
Date: Tue, 3 Sep 2013 08:34:28 -0700
Message-ID: <CAGa+x86TdSzzUrrnmkCtRk2HqPdeG30kETeicR+z+Dzs-FsXNQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: Fix crash in gpiod_set_debounce()
From: Kevin Hilman <khilman@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+Olof who had mentioned lock recursion BUG in -next]

On Tue, Sep 3, 2013 at 5:10 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Sep 3, 2013 at 12:39 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>
>> Return an error if neither the ->set() nor the ->set_debounce() function
>> is implemented by the chip. Furthermore move locking further down so the
>> lock doesn't have to be unlocked on error. This is safe to do because at
>> this point the lock doesn't protect anything.
>>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>> ---
>> Linus,
>>
>> Feel free to squash this into the commit that introduced these:
>>
>>         fc9bbfb: gpio: improve error path in gpiolib
>
> Hm I fixed part of this bug yesterday, but screwed up and left the dangling
> spinlock in there, what is wrong with me :-(
>
> Anyway, fixed it _finally_ now, thanks to you.

Exiting without unlocking was causing a lock recurision lockup in
next-20130903 on exynos5/arndale.  I just verified that moving the
spinlock down as propsed here fixes the problem in -next.

Thanks,

Kevin
