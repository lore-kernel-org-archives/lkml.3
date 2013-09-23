Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3IWMQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:16:58 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:65012 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3IWMQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:16:56 -0400
Message-ID: <52403136.2080503@atmel.com>
Date: Mon, 23 Sep 2013 14:16:54 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Thomas Meyer <thomas@m3y3r.de>, <jic23@cam.ac.uk>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/10] iio: at91_adc: Cocci spatch "noderef"
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de> <1379604755852-604229709-3-diffsplit-thomas@m3y3r.de> <523BF89E.4000508@atmel.com> <523C95B0.6070906@kernel.org> <523C971E.5090809@kernel.org>
In-Reply-To: <523C971E.5090809@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/09/2013 20:42, Jonathan Cameron :
> On 09/20/13 19:36, Jonathan Cameron wrote:
>> On 09/20/13 08:26, Nicolas Ferre wrote:
>>> On 19/09/2013 23:42, Thomas Meyer :
>>>> sizeof when applied to a pointer typed expression gives the size of the
>>>> pointer.
>>>> Found by coccinelle spatch "misc/noderef.cocci"
>>>>
>>>> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
>>>
>>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Applied to the fixes-togreg branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git
>
> Actually, change of plan. Applied to the togreg branch of that
> tree.  Whilst technically more correct to have it as you say,
> we are dealing with the size of a struct iio_trig ** vs
> a struct iio_trig *  so it isn't actually a bug, just a
> less than ideal bit of code ;)

Absolutely.

> It was so obviously a fix I didn't initially check if it
> was a 'real' bug or not. oops.

Yes, I took this path myself as well ;-)

Bye,


>>>> ---
>>>>
>>>> diff -u -p a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
>>>> --- a/drivers/iio/adc/at91_adc.c
>>>> +++ b/drivers/iio/adc/at91_adc.c
>>>> @@ -279,7 +279,7 @@ static int at91_adc_trigger_init(struct
>>>>        int i, ret;
>>>>
>>>>        st->trig = devm_kzalloc(&idev->dev,
>>>> -                st->trigger_number * sizeof(st->trig),
>>>> +                st->trigger_number * sizeof(*st->trig),
>>>>                    GFP_KERNEL);
>>>>
>>>>        if (st->trig == NULL) {
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Nicolas Ferre
