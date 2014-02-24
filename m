Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaBXHkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:40:36 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:25114 "EHLO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265AbaBXHkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:40:33 -0500
Message-ID: <530AF761.2020107@gaisler.com>
Date: Mon, 24 Feb 2014 08:40:17 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH 1/6] usb: gadget: gr_udc: Make struct platform_device
 variable name clearer
References: <1389264858-32664-1-git-send-email-andreas@gaisler.com> <1389264858-32664-2-git-send-email-andreas@gaisler.com> <20140218155253.GC9878@saruman.home>
In-Reply-To: <20140218155253.GC9878@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-18 16:52, Felipe Balbi wrote:
> On Thu, Jan 09, 2014 at 11:54:13AM +0100, Andreas Larsson wrote:
>> Rename struct platform_device pointers from ofdev to pdev for clarity.
>> Suggested by Mark Rutland.
>>
>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>> ---
>>   drivers/usb/gadget/gr_udc.c |   18 +++++++++---------
>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
>> index 914cbd8..e66dcf0 100644
>> --- a/drivers/usb/gadget/gr_udc.c
>> +++ b/drivers/usb/gadget/gr_udc.c
>> @@ -2071,9 +2071,9 @@ static int gr_udc_init(struct gr_udc *dev)
>>   	return 0;
>>   }
>>
>> -static int gr_remove(struct platform_device *ofdev)
>> +static int gr_remove(struct platform_device *pdev)
>>   {
>> -	struct gr_udc *dev = dev_get_drvdata(&ofdev->dev);
>> +	struct gr_udc *dev = dev_get_drvdata(&pdev->dev);
>
> you can use platform_get_drvdata()
>
>> @@ -2083,7 +2083,7 @@ static int gr_remove(struct platform_device *ofdev)
>>   	gr_dfs_delete(dev);
>>   	if (dev->desc_pool)
>>   		dma_pool_destroy(dev->desc_pool);
>> -	dev_set_drvdata(&ofdev->dev, NULL);
>> +	dev_set_drvdata(&pdev->dev, NULL);
>
> and platform_set_drvdata()
>

Yes, but wouldn't that be better handled in a separate patch?

Best regards,
Andreas Larsson
