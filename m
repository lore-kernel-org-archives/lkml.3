Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3EBKe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:34:58 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:54507 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3EBKe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:34:57 -0400
Message-ID: <5182414F.1000201@atmel.com>
Date: Thu, 2 May 2013 12:34:55 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Grant Likely <grant.likely@linaro.org>
CC: Richard Genoud <richard.genoud@gmail.com>,
        "Yang, Wenyou" <Wenyou.Yang@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after xfer->speed_hz
 set
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com> <1362626815-6628-1-git-send-email-wenyou.yang@atmel.com> <CAGhQ9VwW18LXY5Jn0FUFCaAzKxP1W3QADG=JBp9JbgaAwo=F2Q@mail.gmail.com> <B256D81BAE5131468A838E5D7A24364154236AB5@penmbx02> <CACQ1gAhZO3stjrwf5SiZf7jOO8T5bAJZiz97M7+7vwFmk2e65g@mail.gmail.com>
In-Reply-To: <CACQ1gAhZO3stjrwf5SiZf7jOO8T5bAJZiz97M7+7vwFmk2e65g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 10:12, Richard Genoud :
> 2013/5/2 Yang, Wenyou <Wenyou.Yang@atmel.com>:
>> Hi, Joachim,
>>
>>> -----Original Message-----
>>> From: Joachim Eastwood [mailto:manabian@gmail.com]
>>> Sent: 2013年3月7日 20:31
>>> To: Yang, Wenyou
>>> Cc: linux-arm-kernel@lists.infradead.org; grant.likely@secretlab.ca; Ferre,
>>> Nicolas; plagnioj@jcrosoft.com; richard.genoud@gmail.com; Lin, JM;
>>> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
>>> Subject: Re: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
>>> xfer->speed_hz set
>>>
>>> On 7 March 2013 04:26, Wenyou Yang <wenyou.yang@atmel.com> wrote:
>>>> commit: 059b8ffeee5b427949872bb6ed5db5ae0788054e
>>>> cause the atmel spi probing failure.
>>>>
>>>> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
>>>> Cc: spi-devel-general@lists.sourceforge.net
>>>> Cc: linux-kernel@vger.kernel.org
>>>> ---
>>>>   drivers/spi/spi-atmel.c |    6 +++---
>>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
>>>> index 656d137..1eca815 100644
>>>> --- a/drivers/spi/spi-atmel.c
>>>> +++ b/drivers/spi/spi-atmel.c
>>>> @@ -846,9 +846,9 @@ static int atmel_spi_transfer(struct spi_device *spi,
>>> struct spi_message *msg)
>>>>                          }
>>>>                  }
>>>>
>>>> -               /* FIXME implement these protocol options!! */
>>>> -               if (xfer->speed_hz) {
>>>> -                       dev_dbg(&spi->dev, "no protocol options
>>> yet\n");
>>>> +               if (xfer->speed_hz < spi->max_speed_hz) {
>>>> +                       dev_dbg(&spi->dev,
>>>> +                               "speed in transfer less than bus
>>> speed\n");
>>>>                          return -ENOPROTOOPT;
>>>>                  }
>>>
>>> I sent a similar patch to spi-devl a while ago, which Grant said he applied.
>>> https://patchwork.kernel.org/patch/2165301/
>>>
>>> Can't find the patch in any upstream git tree so I guess Grant hasn't
>>> pushed it yet.
>> This patch hasn't still applied in any upstream git tree, so Atmel spi master doesn't work.
>> Could you help do some ping it?
>
> it's in linux-next:
> 3d3522604a5557e80fdcab61c54bd04eaf15b525
> merged from spi-current/spi/merge

Thanks Richard, yes I can find it here:
http://git.secretlab.ca/?p=linux.git;a=commit;h=3d3522604a5557e80fdcab61c54bd04eaf15b525

Grant, Mark,

Can you tell us if this SPI patch will be merged upstream using one of 
your paths?

Best regards,
-- 
Nicolas Ferre
