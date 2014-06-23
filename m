Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaFWGRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:17:41 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62980 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaFWGRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:17:40 -0400
Message-ID: <53A7C67F.3080409@gmail.com>
Date: Mon, 23 Jun 2014 11:47:35 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tushar Behera <tushar.b@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: misc: usb3503: Update error code in print message
References: <1403003330-17553-1-git-send-email-tushar.b@samsung.com> <53A0256A.2000904@samsung.com>
In-Reply-To: <53A0256A.2000904@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 04:54 PM, Marek Szyprowski wrote:
> Hello,
> 
> On 2014-06-17 13:08, Tushar Behera wrote:
>> 'err' is uninitialized, rather print the error code directly.
>>
>> This also fixes following warning.
>> drivers/usb/misc/usb3503.c: In function ‘usb3503_probe’:
>> drivers/usb/misc/usb3503.c:195:11: warning: ‘err’ may be used
>> uninitialized
>> in this function [-Wmaybe-uninitialized]
>>      dev_err(dev, "unable to request refclk (%d)\n", err);
>>
>> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
> 
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 

Greg,

Would you please pick up this patch?

>> ---
>>
>> Based on next-20140616.
>>
>>   drivers/usb/misc/usb3503.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
>> index f43c619..652855b 100644
>> --- a/drivers/usb/misc/usb3503.c
>> +++ b/drivers/usb/misc/usb3503.c
>> @@ -192,7 +192,8 @@ static int usb3503_probe(struct usb3503 *hub)
>>             clk = devm_clk_get(dev, "refclk");
>>           if (IS_ERR(clk) && PTR_ERR(clk) != -ENOENT) {
>> -            dev_err(dev, "unable to request refclk (%d)\n", err);
>> +            dev_err(dev, "unable to request refclk (%ld)\n",
>> +                    PTR_ERR(clk));
>>               return PTR_ERR(clk);
>>           }
>>   
> 
> Best regards


-- 
Tushar Behera
