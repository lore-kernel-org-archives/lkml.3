Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3IFIzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 04:55:45 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57357 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab3IFIzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 04:55:42 -0400
MIME-Version: 1.0
In-Reply-To: <522645D0.3030503@wwwdotorg.org>
References: <1378204768-18013-1-git-send-email-treding@nvidia.com>
	<522645D0.3030503@wwwdotorg.org>
Date: Fri, 6 Sep 2013 10:55:41 +0200
Message-ID: <CACRpkdY4+PxBp_88QB7OrfowQ+6axvaqCj=kviwXmo-aHGwHVg@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: Fix crash in gpiod_set_debounce()
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 10:25 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

>>       chip = desc->chip;
>>       if (!chip->set || !chip->set_debounce) {
>>         pr_warn("%s: missing set() or set_debounce() operations\n",
>>                 __func__);
>> +             return -EIO;
>>       }
>
> BTW, I'm not sure that error-path should pr_warn(). For example, if this
> error-patch is taken due to a call from
> gpio_keys.c:gpio_keys_setup_key(), then a timer will be used for
> debounce instead, which is all perfectly valid, and probably not
> something that should be spewed to the kernel log.

You're right, I wasn't aware of the fallback use-case,
so I've proposed a separate patch fixing this.

Yours,
Linus Walleij
