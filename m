Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaDPU3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:29:23 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:40607 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaDPU3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:29:21 -0400
MIME-Version: 1.0
In-Reply-To: <534EADF0.1020907@wwwdotorg.org>
References: <1397611505-17917-1-git-send-email-abrestic@chromium.org>
	<534EADF0.1020907@wwwdotorg.org>
Date: Wed, 16 Apr 2014 13:29:20 -0700
X-Google-Sender-Auth: zq71VOn8lHpISW-YlShwLPzh7TM
Message-ID: <CAL1qeaG4e4gFOBLo1ePfSRLGiSaQW4UY7T1jkBHx9fv=yYCCUA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: as3722: fix handling of GPIO invert bit
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 9:21 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/15/2014 07:25 PM, Andrew Bresticker wrote:
>> The AS3722_GPIO_INV bit will always be blindly overwritten by
>> as3722_pinctrl_gpio_set_direction() and will be ignored when
>> setting the value of the GPIO in as3722_gpio_set() since the
>> enable_gpio_invert flag is never set.  This will cause an
>> initially inverted GPIO to toggle when requested as an output,
>> which could be problematic if, for example, the GPIO controls
>> a critical regulator.
>>
>> Instead of setting up the enable_gpio_invert flag, uust leave
>> the invert bit alone and check it before setting the GPIO value.
>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
>
> (not with a 'scope or anything, but an affected system boots in a stable
> fashion with this applied)
>
> Should this be CC: stable?

I think so.  Kernels with venice2 support should probably have this.
I'll resend and fix the typo in the commit message.
