Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3ISPxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:53:49 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16869 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3ISPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:53:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Sep 2013 08:53:46 -0700
Message-ID: <523B1E08.6050003@nvidia.com>
Date: Thu, 19 Sep 2013 11:53:44 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Manish Badarkhe <badarkhe.manish@gmail.com>
CC: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] drivers: power: Add support for bq24735 charger
References: <1379452259-3499-1-git-send-email-rklein@nvidia.com> <CAKDJKT4D7VV1pxC1Bme5wptEW=2uyWBccVCv06tTwgrW20diVA@mail.gmail.com>
In-Reply-To: <CAKDJKT4D7VV1pxC1Bme5wptEW=2uyWBccVCv06tTwgrW20diVA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/2013 9:56 AM, Manish Badarkhe wrote:
> Hi
> 
>> +               ret = gpio_request(charger_device->pdata->status_gpio, name);
>> +               if (ret) {
>> +                       dev_err(&client->dev, "Failed gpio request: %d\n", ret);
>> +                       goto err_free_name;
>> +               }
>> +       }
> 
> snip ...
> 
>> +err_free_name:
>> +       if (name && name != charger_device->pdata->name)
>> +               kfree(name);
>> +
>> +       return ret;
>> +}
> 
> Like to know, Is there a need to free gpio which has been requested previously?
> Alternatively, this can be get requested using "devm_" function so
> that it will get
> freed automatically during removal.

As a matter of fact yes, I meant to use the devm_ variant, which is why
I don't have the cleanup. Thanks for catching this! Will fix in V2.

> 
>> +static int bq24735_charger_remove(struct i2c_client *client)
>> +{
>> +       struct bq24735_charger *charger_device = i2c_get_clientdata(client);
>> +
>> +       if (charger_device->irq)
>> +               devm_free_irq(charger_device->dev, charger_device->irq,
>> +                               &charger_device->charger);
>> +
>> +       power_supply_unregister(&charger_device->charger);
>> +
>> +       if (charger_device->charger.name != charger_device->pdata->name)
>> +               kfree(charger_device->charger.name);
>> +
>> +       return 0;
> 
> Ditto, If go with free_gpio.
> 
> 
> Regards
> Manish Badarkhe
> 

Thanks!

-rhyland

-- 
nvpublic
