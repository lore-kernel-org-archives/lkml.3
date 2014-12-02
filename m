Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaLBOTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:19:16 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34418 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaLBOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:19:14 -0500
MIME-Version: 1.0
In-Reply-To: <1417527724-24960-1-git-send-email-acourbot@nvidia.com>
References: <CAAVeFuJm_UXHioENBg6himgZkEmopr=T8iCbt0xD6-ds6AHyxA@mail.gmail.com>
	<1417527724-24960-1-git-send-email-acourbot@nvidia.com>
Date: Tue, 2 Dec 2014 15:19:13 +0100
Message-ID: <CACRpkdY3vHHNSovaEf1UysuQD5gSHM-n6DUSdF372hYMyr9e8g@mail.gmail.com>
Subject: Re: [PATCH] gpio: fix deferred probe detection for legacy API
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 2:42 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Commit 14e85c0e69d5 ("gpio: remove gpio_descs global array") changed
> gpio_to_desc()'s behavior to return NULL not only for GPIOs numbers
> not in the valid range, but also for all GPIOs whose controller has not
> been probed yet. Although this behavior is more correct (nothing hints
> that these GPIO numbers will be populated later), this affects
> gpio_request() and gpio_request_one() which call gpiod_request() with a
> NULL descriptor, causing it to return -EINVAL instead of the expected
> -EPROBE_DEFER for a non-probed GPIO.
>
> gpiod_request() is only called with a descriptor obtained from
> gpio_to_desc() from these two functions, so address the issue there.
>
> Other ways to obtain GPIOs rely on well-defined mappings and can thus
> return -EPROBE_DEFER only for relevant GPIOs, and are thus not affected
> by this issue.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied with Geert's tested tag.

Yours,
Linus Walleij
