Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaLBOVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:21:00 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:47491 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaLBOU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:20:59 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdY3vHHNSovaEf1UysuQD5gSHM-n6DUSdF372hYMyr9e8g@mail.gmail.com>
References: <CAAVeFuJm_UXHioENBg6himgZkEmopr=T8iCbt0xD6-ds6AHyxA@mail.gmail.com>
 <1417527724-24960-1-git-send-email-acourbot@nvidia.com> <CACRpkdY3vHHNSovaEf1UysuQD5gSHM-n6DUSdF372hYMyr9e8g@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 2 Dec 2014 23:20:27 +0900
Message-ID: <CAAVeFuJrLth2bT20i0MoPYhLFidNbUEfoUjqdb0oNg6ARCZryg@mail.gmail.com>
Subject: Re: [PATCH] gpio: fix deferred probe detection for legacy API
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 11:19 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Dec 2, 2014 at 2:42 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>
>> Commit 14e85c0e69d5 ("gpio: remove gpio_descs global array") changed
>> gpio_to_desc()'s behavior to return NULL not only for GPIOs numbers
>> not in the valid range, but also for all GPIOs whose controller has not
>> been probed yet. Although this behavior is more correct (nothing hints
>> that these GPIO numbers will be populated later), this affects
>> gpio_request() and gpio_request_one() which call gpiod_request() with a
>> NULL descriptor, causing it to return -EINVAL instead of the expected
>> -EPROBE_DEFER for a non-probed GPIO.
>>
>> gpiod_request() is only called with a descriptor obtained from
>> gpio_to_desc() from these two functions, so address the issue there.
>>
>> Other ways to obtain GPIOs rely on well-defined mappings and can thus
>> return -EPROBE_DEFER only for relevant GPIOs, and are thus not affected
>> by this issue.
>>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>
> Patch applied with Geert's tested tag.

I just send a v2 which only prints the warning if the GPIO is outside
of the valid range (better for legacy API).
