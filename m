Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaETEcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 00:32:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51589 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaETEcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 00:32:52 -0400
Message-ID: <537ADAEF.9060105@ti.com>
Date: Tue, 20 May 2014 10:02:47 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bin Liu <binmlist@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <zonque@gmail.com>, <b-liu@ti.com>
Subject: Re: [PATCH v4 1/6] usb: musb: core: Handle Babble condition only
 in HOST mode
References: <1400506776-2816-1-git-send-email-george.cherian@ti.com>	<1400506776-2816-2-git-send-email-george.cherian@ti.com> <CADYTM3bd8Bq5QTn-HC4jYX-owEw_sF1DOtXsc-cMDqKHGJHXjQ@mail.gmail.com>
In-Reply-To: <CADYTM3bd8Bq5QTn-HC4jYX-owEw_sF1DOtXsc-cMDqKHGJHXjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bin,
On 5/19/2014 9:24 PM, Bin Liu wrote:
> Hi,
>
> On Mon, May 19, 2014 at 8:39 AM, George Cherian <george.cherian@ti.com> wrote:
>> BABBLE and RESET share the same interrupt. The interrupt
>> is considered to be RESET if MUSB is in peripheral mode and
>> as a BABBLE if MUSB is in HOST mode.
>>
>> Handle babble condition iff MUSB is in HOST mode.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   drivers/usb/musb/musb_core.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
>> index 61da471..eff3c5c 100644
>> --- a/drivers/usb/musb/musb_core.c
>> +++ b/drivers/usb/musb/musb_core.c
>> @@ -849,7 +849,7 @@ b_host:
>>          }
>>
>>          /* handle babble condition */
>> -       if (int_usb & MUSB_INTR_BABBLE)
>> +       if (int_usb & MUSB_INTR_BABBLE && is_host_active(musb))
>>                  schedule_work(&musb->recover_work);
> I guess my following comments are for Daniel's patch as while which
> initially added the babble work.
>
> Should this if statement be merged into the previous 'if(int_usb &
> MUSB_INTR_RESET)' one, which handles the same interrupt and already
> handles host and device mode respectively.

Initially I too had the babble handling as part of  'if(int_usb & 
MUSB_INTR_RESET)'
one. But during my tests I hit a corner case where in we hit a BABBLE 
condition
on disconnect. In such case the babble interrupt can be handled only if 
we have a seperate
check, else its considered as a BUS RESET.

When all devices are disconnected  MUSB_DEVCTL_HM = 0 and the code 
always enter the
else path. In this path it treats the BABBLE as a BUS RESET.

> Regards,
> -Bin.
>
>>   #if 0
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
-George

