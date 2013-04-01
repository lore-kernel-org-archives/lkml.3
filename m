Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab3DAHeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:34:16 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:57421 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab3DAHeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:34:15 -0400
MIME-Version: 1.0
X-Originating-IP: [114.39.109.172]
In-Reply-To: <CAMPhdO_EHEs82ffKGTuJ1j=ruOHYd0HCYPash9xNu9gdkX2=YQ@mail.gmail.com>
References: <1364746327.12810.1.camel@phoenix>
	<CAMPhdO_EHEs82ffKGTuJ1j=ruOHYd0HCYPash9xNu9gdkX2=YQ@mail.gmail.com>
Date: Mon, 1 Apr 2013 15:34:14 +0800
Message-ID: <CAFRkauCYgsig00u2XY_fAzm9s6VWZtwbAuZ=UZZ1MJRDUeXT9g@mail.gmail.com>
Subject: Re: [PATCH] pwm: pxa: Use driver_data field to store pwm_nr
From: Axel Lin <axel.lin@ingics.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1 Eric Miao <eric.y.miao@gmail.com>:
> On Mon, Apr 1, 2013 at 12:12 AM, Axel Lin <axel.lin@ingics.com> wrote:
>> The driver_data field was used to store information about PWM_ID_BASE and
>> HAS_SECONDARY_PWM. PWM_ID_BASE is not used now after convert to pwm framework.
>> This patch stores the pwm_nr in driver_data field to simplify the code.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> ---
>>  drivers/pwm/pwm-pxa.c |   11 ++++-------
>>  1 file changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
>> index b789882..019a8e0 100644
>> --- a/drivers/pwm/pwm-pxa.c
>> +++ b/drivers/pwm/pwm-pxa.c
>> @@ -22,13 +22,10 @@
>>
>>  #include <asm/div64.h>
>>
>> -#define HAS_SECONDARY_PWM      0x10
>> -#define PWM_ID_BASE(d)         ((d) & 0xf)
>> -
>>  static const struct platform_device_id pwm_id_table[] = {
>> -       /*   PWM    has_secondary_pwm? */
>> -       { "pxa25x-pwm", 0 },
>> -       { "pxa27x-pwm", 0 | HAS_SECONDARY_PWM },
>> +       /*   PWM    pwm_nr */
>> +       { "pxa25x-pwm", 1 },
>> +       { "pxa27x-pwm", 2 },
>>         { "pxa168-pwm", 1 },
>>         { "pxa910-pwm", 1 },
>>         { },
>> @@ -145,7 +142,7 @@ static int pwm_probe(struct platform_device *pdev)
>>         pwm->chip.dev = &pdev->dev;
>>         pwm->chip.ops = &pxa_pwm_ops;
>>         pwm->chip.base = -1;
>> -       pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
>> +       pwm->chip.npwm = id->driver_data;
>
> I'd rather keep the flag for a bit more readability?

Well, I'd send a patch to just remove PWM_ID_BASE which is not used now.

Regards,
Axel
