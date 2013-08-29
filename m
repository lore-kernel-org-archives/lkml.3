Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3H2JqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:46:13 -0400
Received: from 219-118-191-131.cust.bit-drive.ne.jp ([219.118.191.131]:50845
	"EHLO mail.omesemicon.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab3H2JqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:46:12 -0400
Message-ID: <521F1869.1090408@jinso.co.jp>
Date: Thu, 29 Aug 2013 18:46:17 +0900
From: Nguyen Viet Dung <nv-dung@jinso.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com
Subject: Re: [PATCH v3 1/1 resend] i2c: rcar: modify I2C driver
References: <1377590122-9309-1-git-send-email-nv-dung@jinso.co.jp> <1377590122-9309-2-git-send-email-nv-dung@jinso.co.jp> <20130828090246.GC4086@katana>
In-Reply-To: <20130828090246.GC4086@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Thank your for the guide.

I have understood your guide.
And I have released version 4 of I2C patch.

Please check it for me.

Thanks,
Nguyen Viet Dung

On 08/28/2013 06:02 PM, Wolfram Sang wrote:
> On Tue, Aug 27, 2013 at 04:55:22PM +0900, Nguyen Viet Dung wrote:
>> This patch modify I2C driver of rcar-H1 to usable on both rcar-H1 and rcar-H2.
>>
>> Signed-off-by: Nguyen Viet Dung <nv-dung@jinso.co.jp>
> Yes, this is much better. Only minor things...
>
>> +	switch (priv->devtype) {
>> +	default:
>> +	case I2C_RCAR_H1:
>> +		cdf_width = 2;
>> +		break;
>> +	case I2C_RCAR_H2:
>> +		cdf_width = 3;
>> +		break;
>> +	}
>> +
> Please put the default case block at the end.
>
>> @@ -632,6 +649,13 @@ static int rcar_i2c_probe(struct platform_device *pdev)
>>   	bus_speed = 100000; /* default 100 kHz */
>>   	if (pdata && pdata->bus_speed)
>>   		bus_speed = pdata->bus_speed;
>> +
>> +	if (!pdev->id_entry) {
>> +		dev_err(&pdev->dev, "no entry\n");
>> +		return -ENODEV;
>> +	}
> This cannot happen. Since you have 'i2c-rcar' in the id_table, the
> driver core will always match against the id_table and there is always a
> driver_data defined.
>
>
>> +	priv->devtype = pdev->id_entry->driver_data;
> Basically the same, but please use
>
> 	platform_get_device_id(pdev)->driver_data;
>
> Otherwise good!
>
> Thanks,
>
>     Wolfram

