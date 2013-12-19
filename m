Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab3LSFtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 00:49:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58720 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3LSFtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 00:49:47 -0500
Message-ID: <52B288ED.80904@ti.com>
Date: Thu, 19 Dec 2013 11:19:33 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <jcbian@pixcir.com.cn>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 7/9] Input: pixcir_i2c_ts: Implement Type B Multi Touch
 reporting
References: <1387358480-8313-1-git-send-email-rogerq@ti.com> <1387358480-8313-8-git-send-email-rogerq@ti.com> <20131218141841.GE28504@core.coreip.homeip.net>
In-Reply-To: <20131218141841.GE28504@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 12/18/2013 07:48 PM, Dmitry Torokhov wrote:
> On Wed, Dec 18, 2013 at 02:51:18PM +0530, Roger Quadros wrote:
>> Some pixcir controllers e.g. tangoC family report finger IDs with
>> the co-ordinates and are more suitable for Type-B MT protocol.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
>> ---
>>  drivers/input/touchscreen/pixcir_i2c_ts.c | 202 +++++++++++++++++++++++-------
>>  1 file changed, 155 insertions(+), 47 deletions(-)
>>
>> diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
>> index ff68246..9e14415 100644
>> --- a/drivers/input/touchscreen/pixcir_i2c_ts.c
>> +++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
>> @@ -23,84 +23,173 @@
>>  #include <linux/slab.h>
>>  #include <linux/i2c.h>
>>  #include <linux/input.h>
>> +#include <linux/input/mt.h>
>>  #include <linux/input/pixcir_ts.h>
>>  #include <linux/gpio.h>
>>  #include <linux/of.h>
>>  #include <linux/of_gpio.h>
>>  #include <linux/of_device.h>
>>  
>> +#define MAX_FINGERS	5	/* Maximum supported by the driver */
>> +
>>  struct pixcir_i2c_ts_data {
>>  	struct i2c_client *client;
>>  	struct input_dev *input;
>>  	const struct pixcir_ts_platform_data *pdata;
>>  	bool exiting;
>> +	u8 max_fingers;		/* Maximum supported by the chip */
>>  };
>>  
>> -static void pixcir_ts_poscheck(struct pixcir_i2c_ts_data *data)
>> +static void pixcir_ts_typea_report(struct pixcir_i2c_ts_data *tsdata)
> 
> Hmm, I do not think we should keep Type A reports if we can do Type B.
> The protocols are not new and userspace should be able to handle MT-B by
> now.
> 

It seems the controller the original driver was written for does not report
touch ID and just reports 2 touch co-ordinates. I'm not sure how this fits into
Type B reporting model.

cheers,
-roger
