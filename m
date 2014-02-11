Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaBKIzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:55:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35089 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaBKIzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:55:00 -0500
Message-ID: <52F9E55E.2050708@ti.com>
Date: Tue, 11 Feb 2014 10:54:54 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Colin King <colin.king@canonical.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: omap-usb-tll: allocate correct size for ch_clk
References: <1392059407-15452-1-git-send-email-colin.king@canonical.com> <20140210195421.GB31864@lee--X1>
In-Reply-To: <20140210195421.GB31864@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

On 02/10/2014 09:54 PM, Lee Jones wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> ch_clk was erroneously being allocated the incorrect size which
>> can be problematic for larger sizes of tll->nch

The code fix is good but the subject and description aren't right.

You could instead mention about the cppcheck warning and hard to read
code.

>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/mfd/omap-usb-tll.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
>> index 5ee50f7..532eacab 100644
>> --- a/drivers/mfd/omap-usb-tll.c
>> +++ b/drivers/mfd/omap-usb-tll.c
>> @@ -252,7 +252,7 @@ static int usbtll_omap_probe(struct platform_device *pdev)
>>  		break;
>>  	}
>>  
>> -	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk * [tll->nch]),
>> +	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk *) * tll->nch,
>>  						GFP_KERNEL);
>>  	if (!tll->ch_clk) {
>>  		ret = -ENOMEM;
> 
> Thanks Colin, patch looks good to me.
> 
> Roger, fancy finishing this off with an Acked-by?
> 

cheers,
-roger
