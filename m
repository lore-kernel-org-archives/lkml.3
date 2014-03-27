Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbaC0AJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:09:22 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58374 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaC0AJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKE163O3Kcdy-WCCEesJMCQ-fcLe8Op5f=VE7ZovFptqA@mail.gmail.com>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com> <CAAVeFuKE163O3Kcdy-WCCEesJMCQ-fcLe8Op5f=VE7ZovFptqA@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 26 Mar 2014 17:08:55 -0700
Message-ID: <CAK5ve-K7-Qk-VX33ZMWh3WEYOQND_o_TG6Hk28Y7r8dVgVtg9A@mail.gmail.com>
Subject: Re: [PATCH 0/2] pwm-backlight: switch to gpiod interface (part 1)
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 10:01 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> Ping Thierry, can you have a look at this series? It is quite similar
> to the same change you merged for panel-simple (although I cannot see
> it in -next neither).
>

I think Jingoo can help to review this as well. Jingoo, can you help
to review. Actually it looks good to me.

-Bryan

> On Thu, Feb 27, 2014 at 2:53 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> These two patches initiate the switch of the pwm-backlight driver to
>> the gpiod GPIO interface, as it considerably simplifies the code.
>>
>> For compatibility with current users of the driver, it is still possible
>> to pass the enable GPIO number as platform data. Two platforms are still
>> relying on this feature (pxa/palmtc and shmobile/armadillo800eva) which
>> will be removed as soon as its last users are switched to GPIO mapping
>> tables.
>>
>> Alexandre Courbot (2):
>>   ARM: SAMSUNG: remove gpio flags in dev-backlight
>>   pwm-backlight: switch to gpiod interface
>>
>>  arch/arm/plat-samsung/dev-backlight.c |  2 -
>>  drivers/video/backlight/pwm_bl.c      | 72 +++++++++++++++--------------------
>>  include/linux/pwm_backlight.h         |  5 +--
>>  3 files changed, 32 insertions(+), 47 deletions(-)
>>
>> --
>> 1.9.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-gpio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
