Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaDXEgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:36:25 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37725 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaDXEgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:36:24 -0400
Message-ID: <5358951A.3080507@kernel.org>
Date: Thu, 24 Apr 2014 05:37:46 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, Milo.Kim@ti.com,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Russ.Dill@ti.com,
        alexandre.belloni@free-electrons.com, oleksandr.kozaruk@ti.com,
        B38611@freescale.com, johannes.thumshirn@men.de, sre@debian.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: adc: Nothing in ADC should be a bool CONFIG
References: <1398125031-5826-1-git-send-email-dianders@chromium.org>	<5358288C.6030205@kernel.org> <CAD=FV=Ws7R0+nJagXswnqowxFvrxh6vTmKM_jwz8mnGbKr_aSg@mail.gmail.com>
In-Reply-To: <CAD=FV=Ws7R0+nJagXswnqowxFvrxh6vTmKM_jwz8mnGbKr_aSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/04/14 22:54, Doug Anderson wrote:
> Jonathan,
>
> On Wed, Apr 23, 2014 at 1:54 PM, Jonathan Cameron <jic23@kernel.org> wrote:
>> On 22/04/14 01:03, Doug Anderson wrote:
>>>
>>> The whole IIO subsystem can be moved to a module.  If you make it a
>>> module then stuff marked as "Y" in the adc directory simply won't be
>>> linked in properly.
>>>
>>> The two configs that were wrong were EXYNOS_ADC and LP8788_ADC.  I
>>> know for a fact that EXYNOS_ADC will work as a module (though it
>>> appears to crash when you unload it--that needs to be addressed
>>> separately).
>>
>> I'd really like to see this pinned down before taking this patch.
>> I can see you argument that the current approach is clearly wrong,
>> but swapping one issue for another is not an approach I'd particularly
>> like to take...
>>
>> I can't immediately spot the cause of the crash, but there are certainly
>> some interesting order issues in this driver.  Not enabling the vdd
>> regulator until after the userspace interfaces are exposed (by the
>> iio_device_register call) is interesting for a start.
>>
>> The remove doesn't run in the reverse of the probe order (see clocks
>> vs regulators for example.)
>>
>> Gah, my reviewing for one clearly missed some things in this driver.
>
> OK, fair enough.  I took a quick look and couldn't spot anything
> either.  I've requested that Samsung dig into these problems.  If they
> are unable to I will take a crack at it as time permits.  ;)
>
Cool and good luck (either way ;)
> Thanks!
>
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

