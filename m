Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3CAXnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 18:43:11 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:41856 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab3CAXnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 18:43:00 -0500
Message-ID: <51313CEA.4050300@slimlogic.co.uk>
Date: Fri, 01 Mar 2013 23:42:34 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH v2 2/2] mfd: palmas add variant and OTP detection
References: <1361637341-22214-1-git-send-email-ian@slimlogic.co.uk> <1361637341-22214-2-git-send-email-ian@slimlogic.co.uk> <512CBE50.4050206@nvidia.com>
In-Reply-To: <512CBE50.4050206@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/13 13:53, Laxman Dewangan wrote:
> On Saturday 23 February 2013 10:05 PM, Ian Lartey wrote:
>> From: Graeme Gregory <gg@slimlogic.co.uk>
>>
>> Read the chip varient and the OTP information from the chip and display
>> this on probe to aid in debugging of issues.
>>
>> Older palmas chips do not have the USB_ID programmed and will therefore
>> return 0x0000 for this field.
>
>> +
>>       /* Change IRQ into clear on read mode for efficiency */
>>       slave = PALMAS_BASE_TO_SLAVE(PALMAS_INTERRUPT_BASE);
>> -    addr = PALMAS_BASE_TO_REG(PALMAS_INTERRUPT_BASE, PALMAS_INT_CTRL);
>>       reg = PALMAS_INT_CTRL_INT_CLEAR;
>> -    regmap_write(palmas->regmap[slave], addr, reg);
>> +    ret = palmas_write(palmas, PALMAS_INTERRUPT_BASE,
>> PALMAS_INT_CTRL, reg);
>
> I think this is unrelated change and can be on another patch.

This is the change  which you requested earlier "Can you please use the 
api palmas_* for reading register which I added recently."

>
>>
>> -    slave = PALMAS_BASE_TO_SLAVE(PALMAS_PU_PD_OD_BASE);
>> -    addr = PALMAS_BASE_TO_REG(PALMAS_PU_PD_OD_BASE,
>> -            PALMAS_PRIMARY_SECONDARY_PAD1);
>> -
>>       if (pdata->mux_from_pdata) {
>>           reg = pdata->pad1;
>> -        ret = regmap_write(palmas->regmap[slave], addr, reg);
>> +        ret = palmas_write(palmas, PALMAS_PU_PD_OD_BASE,
>> +                PALMAS_PRIMARY_SECONDARY_PAD1, reg);
>
> Same, in another patch and elsewhere which was part of cleanups.

ditto.

>
>
> otherwise it looks good.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

