Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3ITRgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:36:17 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47678 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3ITRgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:36:16 -0400
Message-ID: <523C95B0.6070906@kernel.org>
Date: Fri, 20 Sep 2013 19:36:32 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Thomas Meyer <thomas@m3y3r.de>, jic23@cam.ac.uk, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/10] iio: at91_adc: Cocci spatch "noderef"
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de> <1379604755852-604229709-3-diffsplit-thomas@m3y3r.de> <523BF89E.4000508@atmel.com>
In-Reply-To: <523BF89E.4000508@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/13 08:26, Nicolas Ferre wrote:
> On 19/09/2013 23:42, Thomas Meyer :
>> sizeof when applied to a pointer typed expression gives the size of the
>> pointer.
>> Found by coccinelle spatch "misc/noderef.cocci"
>>
>> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Applied to the fixes-togreg branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Thanks,
> 
>> ---
>>
>> diff -u -p a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
>> --- a/drivers/iio/adc/at91_adc.c
>> +++ b/drivers/iio/adc/at91_adc.c
>> @@ -279,7 +279,7 @@ static int at91_adc_trigger_init(struct
>>       int i, ret;
>>
>>       st->trig = devm_kzalloc(&idev->dev,
>> -                st->trigger_number * sizeof(st->trig),
>> +                st->trigger_number * sizeof(*st->trig),
>>                   GFP_KERNEL);
>>
>>       if (st->trig == NULL) {
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
