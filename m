Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaA0IbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 03:31:24 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48749 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaA0IbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 03:31:23 -0500
MIME-Version: 1.0
In-Reply-To: <1390811288.4974.4.camel@AMDC1943>
References: <1390732723-7129-1-git-send-email-geert@linux-m68k.org>
	<1390811288.4974.4.camel@AMDC1943>
Date: Mon, 27 Jan 2014 09:31:18 +0100
X-Google-Sender-Auth: Bc7BDiHFxHJkeRkAzBFZ8aQY1HI
Message-ID: <CAMuHMdU8otOO+FdNDJA0WnMz8omH2P0ebQ23sW8KdAfCbb74FQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: max14577: max14577_{suspend,resume}() should
 depend on CONFIG_PM_SLEEP
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 9:28 AM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> On Sun, 2014-01-26 at 11:38 +0100, Geert Uytterhoeven wrote:
>> If CONFIG_PM_SLEEP=n:
>>
>> drivers/mfd/max14577.c:177: warning: ‘max14577_suspend’ defined but not used
>> drivers/mfd/max14577.c:200: warning: ‘max14577_resume’ defined but not used
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  drivers/mfd/max14577.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
>> index ac514fb2b877..71aa14a6bfbb 100644
>> --- a/drivers/mfd/max14577.c
>> +++ b/drivers/mfd/max14577.c
>> @@ -173,6 +173,7 @@ static const struct i2c_device_id max14577_i2c_id[] = {
>>  };
>>  MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
>>
>> +#ifdef CONFIG_PM_SLEEP
>>  static int max14577_suspend(struct device *dev)
>>  {
>>       struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
>> @@ -208,6 +209,7 @@ static int max14577_resume(struct device *dev)
>>
>>       return 0;
>>  }
>> +#endif /* CONFIG_PM_SLEEP */
>>
>>  static struct of_device_id max14577_dt_match[] = {
>>       { .compatible = "maxim,max14577", },
>
> Same here:
> http://thread.gmane.org/gmane.linux.kernel/1615513/focus=1615563
> although I don't mind if your patch comes in :).

Sorry, missed those.
It's a pity these known fixes don't go in together with the code that introduces
them...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
