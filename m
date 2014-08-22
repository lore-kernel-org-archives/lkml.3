Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbaHVRIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:08:23 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:45059 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaHVRIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:08:22 -0400
Message-ID: <53F77902.20506@cogentembedded.com>
Date: Fri, 22 Aug 2014 21:08:18 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
CC: yoshihiro.shimoda.uh@renesas.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/9] usb: allow to supply the PHY in the drivers when
 using HCD
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com> <1408722621-3635-7-git-send-email-antoine.tenart@free-electrons.com> <53F775A1.4070200@cogentembedded.com>
In-Reply-To: <53F775A1.4070200@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 08:53 PM, Sergei Shtylyov wrote:

>> This patch modify the generic code handling PHYs to allow them to be
>> supplied from the drivers. This adds checks to ensure no PHY was already
>> there when looking for one in the generic code. This also makes sure we
>> do not modify its state in the generic HCD functions, it was provided by
>> the driver.

>> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>> ---
>>   drivers/usb/core/hcd.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)

>> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
>> index 6619239baf6d..dc0e46e5e618 100644
>> --- a/drivers/usb/core/hcd.c
>> +++ b/drivers/usb/core/hcd.c
[...]
>> @@ -2666,6 +2666,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
>>                   goto err_phy;
>>               }
>>               hcd->phy = phy;
>> +            hcd->remove_phy = 1;
>>           }
>>       }

>> @@ -2812,7 +2813,7 @@ err_allocate_root_hub:
>>   err_register_bus:
>>       hcd_buffer_destroy(hcd);
>>   err_create_buf:
>> -    if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
>> +    if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->remove_phy && hcd->phy) {

>     The 'hcd->phy' check seems redundant now.

    Oh, sorry, I forgot about USB PHY which also sets this flag.

WBR, Segei

