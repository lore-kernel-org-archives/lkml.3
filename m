Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161600Ab3BONgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:36:05 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:43296 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161418Ab3BONgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 08:36:03 -0500
MIME-Version: 1.0
In-Reply-To: <511E3772.7000605@metafoo.de>
References: <1360843890-28466-1-git-send-email-ch.naveen@samsung.com>
 <1360911394-19873-1-git-send-email-ch.naveen@samsung.com> <511E346C.3060701@metafoo.de>
 <CAHfPSqAQd7TJqX2FVmkvy_aX0yXm25qLu3A9kPoteUGaBLZPQQ@mail.gmail.com> <511E3772.7000605@metafoo.de>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 15 Feb 2013 19:05:41 +0530
Message-ID: <CAHfPSqABgb8P5js8hz2_Xr2vXQ0F3OkTi2B7jZTqiDg_H6Uo4g@mail.gmail.com>
Subject: Re: [PATCH v7] iio: adc: add exynos adc driver under iio framwork
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        dianders@chromium.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 February 2013 18:56, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 02/15/2013 02:17 PM, Naveen Krishna Ch wrote:
>> On 15 February 2013 18:43, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>> On 02/15/2013 07:56 AM, Naveen Krishna Chatradhi wrote:
>>>> This patch adds New driver to support:
>>>> 1. Supports ADC IF found on EXYNOS4412/EXYNOS5250
>>>>    and future SoCs from Samsung
>>>> 2. Add ADC driver under iio/adc framework
>>>> 3. Also adds the Documentation for device tree bindings
>>>>
>>>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>>
>>> Looks good.
>>>
>>> Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
>>>
>>> One minor thing though, there are a couple of places where you break a line
>>> into multiple lines, even though the line fits easily inside the 80 chars
>>> per line limit. In my opinion this doesn't help the legibility of the code.
>>> E.g.:
>>>
>>> +       info->value = readl(ADC_V1_DATX(info->regs)) &
>>> +                                               ADC_DATX_MASK;
>>>
>>> There is no need to respin the patch just for this, but if you happen to
>>> make another version of the patch, that's something to consider.
>>>
>>>> ---
>>>> Changes since v1:
>>>>
>>>> 1. Fixed comments from Lars
>>>> 2. Added support for ADC on EXYNOS5410
>>>>
>>>> Changes since v2:
>>>>
>>>> 1. Changed the instance name for (struct iio_dev *) to indio_dev
>>>> 2. Changed devm_request_irq to request_irq
>>>>
>>>> Few doubts regarding the mappings and child device handling.
>>>> Kindly, suggest me better methods.
>>>>
>>>> Changes since v3:
>>>>
>>>> 1. Added clk_prepare_disable and regulator_disable calls in _remove()
>>>> 2. Moved init_completion before irq_request
>>>> 3. Added NULL pointer check for devm_request_and_ioremap() return value.
>>>> 4. Use number of channels as per the ADC version
>>>> 5. Change the define ADC_V1_CHANNEL to ADC_CHANNEL
>>>> 6. Update the Documentation to include EXYNOS5410 compatible
>>>>
>>>> Changes since v4:
>>>>
>>>> 1. if devm_request_and_ioremap() failes, free iio_device before returning
>>>>
>>>> Changes since v5:
>>>>
>>>> 1. Fixed comments from Olof (ADC hardware version handling)
>>>> 2. Rebased on top of comming OF framework for IIO by "Guenter Roeck".
>>>>
>>>> Changes since v6:
>>>>
>>>> 1. Addressed comments from Lars-Peter Clausen
>>>
>>>
>>> btw. these kind of change logs are not really helpful, it would be better to
>>> list the actual changes made.
>> Hello Lars,
>>
>> No other changes from my side. But, I can send another version.
>> Do you want me to list the latest change alone instead of the whole
>> change list ?
>
> Hi,
>
> No need to resend the patch, this is just something to consider for the
> future. A changelog entry which reads like "Addressed Jon Does comments" is
> not really useful since most people will probably not know or not longer
> remember all the details of those comments, instead a nice list of all the
> changes which have been made is much better. E.g.:
>
> Changes since v6:
>         * Fixed debugfs_read_reg
>         * Introduced timeout when waiting for the data ready IRQ
>         * Slightly reformatted exynos_read_raw for better legibility
>
> - Lars

Thanks for your comments and valuable time.
Sure Lars, Will do it.
>
>



--
Shine bright,
(: Nav :)
