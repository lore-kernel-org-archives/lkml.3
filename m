Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3LURxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 12:53:09 -0500
Received: from mail.active-venture.com ([67.228.131.205]:60298 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3LURxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 12:53:08 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52B5D582.8060303@roeck-us.net>
Date: Sat, 21 Dec 2013 09:53:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Anthony Olech <anthony.olech.opensource@diasemi.com>,
        lm-sensors@lm-sensors.org, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation in da9052
  power driver
References: <201312181524.rBIFOv96017094@swsrvapps-02.lan>	<20131218163234.714a166c@endymion.delvare>	<24DF37198A1E704D9811D8F72B87EB51847ABF61@NB-EX-MBX02.diasemi.com>	<20131218172402.GA18892@roeck-us.net>	<24DF37198A1E704D9811D8F72B87EB51847AC2C3@NB-EX-MBX02.diasemi.com>	<20131219155454.40100f4d@endymion.delvare>	<20131219181049.GA6854@roeck-us.net> <20131221183037.2ad91f86@endymion.delvare>
In-Reply-To: <20131221183037.2ad91f86@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2013 09:30 AM, Jean Delvare wrote:
> Hi Guenter, hi Anthony,
>
> On Thu, 19 Dec 2013 10:10:49 -0800, Guenter Roeck wrote:
>> On Thu, Dec 19, 2013 at 03:54:54PM +0100, Jean Delvare wrote:
>>> BTW, you (and we) probably shouldn't waste too much energy on this.
>>> ADCs are only accurate to some degree anyway. If you take the
>>> components connected to the input into consideration, the accuracy gets
>>> even worse. For example, if the input voltage must be scaled down to
>>> fit in the ADC's range, you need at least one resistor, which in best
>>> cases will have a 1% accurate value (known as tolerance.) That's ten
>>> times the LSB of your 10-bit ADC, at which point / 1023 or / 1024
>>> really makes no practical difference. Sub-percent tolerant resistors are
>>> expensive and rare in consumer electronics in my experience.
>>
>> True, but on the other side (and after looking into the datasheet)
>> the driver already calculated the voltage on adc4..6 correctly,
>> so unless you disagree I would like to apply the hwmon patch to -next
>> for consistency.
>
> The datasheet isn't the best quality I've seen. The gain values
> mentioned to not even match the formulas in the same cell... But I can't
> object to implementing conversions the way the datasheet says, no
> matter how suspicious.
>
> I don't really know what tree the patch is based on. Anthony said
> linux-next but I can't see ichg_reg_to_mA there.
>
I didn't check the power patch, but the hwmon patch applied cleanly to
the current upstream.

> If volt_reg_to_mv is updated then you certainly want to update
> vbbat_reg_to_mv the same way, as it diverges from the datasheet just
> the same.
>
He is doing that in the hwmon patch. I don't see vbbat_reg_to_mv()
in the power driver, at least not in the upstream version.

> Also, please update Documentation/hwmon/da9052 so that the
> documentation matches the actual driver code.
>
You are right, that needs to be updated as well.

> I really would like to hear what David Dajun Chen has to say about
> that. He must have had a reason to use different conversions formulas
> than the datasheet specifies.
>

Hmm ... if this was done on purpose, I'd like to see a comment somewhere
describing why the formula in the datasheet isn't used, to avoid this kind
of back-and-forth in the future.

Thanks,
Guenter

