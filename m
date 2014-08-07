Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaHGGuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:50:37 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51766 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaHGGuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:50:35 -0400
Message-ID: <53E321B0.9040701@gmail.com>
Date: Thu, 07 Aug 2014 08:50:24 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: cap1106 - allow changing key mapping from userspace
References: <20140721012045.GA4395@core.coreip.homeip.net> <20140807062033.GD651@core.coreip.homeip.net>
In-Reply-To: <20140807062033.GD651@core.coreip.homeip.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 08/07/2014 08:20 AM, Dmitry Torokhov wrote:
> On Sun, Jul 20, 2014 at 06:20:49PM -0700, Dmitry Torokhov wrote:
>> Wire up support for EVIOC{G|S}KEYCODE to allow users change key mappings
>> from userspace.
>>
>> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> ---
>>
>> Just compiled, not tested.
> 
> *ping* Any chance you could give it a try? Thanks!

Oh, sorry, I didn't realize you're waiting for me on this.

Unfortunately, I can't test it myself anymore, as I had to return the
board I found this chip on. But as the change looks very straight
forward, I'd suggest you just apply that patch and I ask the vendor to
give it a quick try. In case of any problems, I'll let you know. Does
that sound feasible?


Thanks,
Daniel


> 
>>
>>  drivers/input/keyboard/cap1106.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/input/keyboard/cap1106.c b/drivers/input/keyboard/cap1106.c
>> index f7d7a0d..180b184 100644
>> --- a/drivers/input/keyboard/cap1106.c
>> +++ b/drivers/input/keyboard/cap1106.c
>> @@ -64,7 +64,7 @@ struct cap1106_priv {
>>  	struct input_dev *idev;
>>  
>>  	/* config */
>> -	unsigned int keycodes[CAP1106_NUM_CHN];
>> +	unsigned short keycodes[CAP1106_NUM_CHN];
>>  };
>>  
>>  static const struct reg_default cap1106_reg_defaults[] = {
>> @@ -272,6 +272,12 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
>>  	for (i = 0; i < CAP1106_NUM_CHN; i++)
>>  		__set_bit(priv->keycodes[i], priv->idev->keybit);
>>  
>> +	__clear_bit(KEY_RESERVED, priv->idev->keybit);
>> +
>> +	priv->idev->keycode = priv->keycodes;
>> +	priv->idev->keycodesize = sizeof(priv->keycodes[0]);
>> +	priv->idev->keycodemax = ARRAY_SIZE(priv->keycodes);
>> +
>>  	priv->idev->id.vendor = CAP1106_MANUFACTURER_ID;
>>  	priv->idev->id.product = CAP1106_PRODUCT_ID;
>>  	priv->idev->id.version = rev;
>> -- 
>> 2.0.0.526.g5318336
>>
>>
>> -- 
>> Dmitry
> 

