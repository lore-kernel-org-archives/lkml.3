Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3KZDbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:31:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46795 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3KZDbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:31:35 -0500
Message-ID: <52941611.8070509@wwwdotorg.org>
Date: Mon, 25 Nov 2013 20:31:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Florian Meier <florian.meier@koalo.de>, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] I2C: BCM2835: Linking platform nodes to adapter nodes
References: <527CB3A1.7050808@koalo.de> <527D1870.8080302@wwwdotorg.org>
In-Reply-To: <527D1870.8080302@wwwdotorg.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 09:59 AM, Stephen Warren wrote:
> On 11/08/2013 02:49 AM, Florian Meier wrote:
>> In order to find I2C devices in the device tree, the platform nodes
>> have to be known by the I2C core. Analogous to the i2c-omap driver
>> this requires setting the dev.of_node parameter of the adapter.
> 
> (CCing the I2C maintainers...)
> 
>> diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
> 
>> @@ -299,6 +299,7 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
>>  	strlcpy(adap->name, "bcm2835 I2C adapter", sizeof(adap->name));
>>  	adap->algo = &bcm2835_i2c_algo;
>>  	adap->dev.parent = &pdev->dev;
>> +	adap->dev.of_node = pdev->dev.of_node;
> 
> Ah, that makes sense. Thinking about it now, I'd only ever used i2cget
> etc. to access I2C devices, rather than instantiating drivers from DT.
> 
> That all said, I wonder if the I2C core shouldn't do something like the
> following inside i2c_add_adapter():
> 
> if (!adap->dev.of_node && adap->dev.parent)
> 	adap->dev.of_node = adap->dev.parent->of_node;
> 
> That would save every single I2C driver from having to set up this field
> manually.

BTW, this should probably be:
Cc: stable@vger.kernel.org
