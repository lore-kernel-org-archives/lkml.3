Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3LDHQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:16:27 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:52860 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab3LDHQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:16:25 -0500
Message-ID: <529ED6C5.3000608@gtsys.com.hk>
Date: Wed, 04 Dec 2013 15:16:21 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb: phy-generic: Add ULPI VBUS support
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk> <1385967919-13258-4-git-send-email-chris.ruehl@gtsys.com.hk> <20131203081556.GA26423@xps8300>
In-Reply-To: <20131203081556.GA26423@xps8300>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 03, 2013 04:15 PM, Heikki Krogerus wrote:
> On Mon, Dec 02, 2013 at 03:05:19PM +0800, Chris Ruehl wrote:
>> @@ -154,6 +164,27 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv *nop,
>>   {
>>   	int err;
>>
>> +	if (nop->ulpi_vbus>  0) {
>> +		unsigned int flags = 0;
>> +
>> +		if (nop->ulpi_vbus&  0x1)
>> +			flags |= ULPI_OTG_DRVVBUS;
>> +		if (nop->ulpi_vbus&  0x2)
>> +			flags |= ULPI_OTG_DRVVBUS_EXT;
>> +		if (nop->ulpi_vbus&  0x4)
>> +			flags |= ULPI_OTG_EXTVBUSIND;
>> +		if (nop->ulpi_vbus&  0x8)
>> +			flags |= ULPI_OTG_CHRGVBUS;
>> +
>> +		nop->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, flags);
>> +		if (!nop->ulpi) {
>> +			dev_err(dev, "Failed create ULPI Phy\n");
>> +			return -ENOMEM;
>> +		}
>> +		dev_dbg(dev, "Create ULPI Phy\n");
>> +		nop->ulpi->io_priv =  nop->viewport;
>> +	}
>
> This is so wrong. You are registering one kind of usb phy driver from
> an other. Change drivers/usb/phy/ulpi.c to be a platform device. The
> whole flag system in it is pretty horrid. While you are at it, change
> that so it sets the values based on boolean flags from OF properties
> or platform data.
>
> NAK for the whole set.
>
>

Heikki,

Thanks for your comments, even not much positive to me.. any how.
My intention on the "horrid" path was to reduce kernel code where
one of_read32 vs. four of_boolean. And mentioned logic is simple. But that's 
history.

On my way to find a solution for my board I'd look around and found using of
phy-ulpi.c functions in phy-tegra-usb.c and don't mind to use them too.

I accept your NAK and will work on a patch to make phy-ulpi.c working as 
platform device.

Last question to you. What you don't like on the patch to support chip-select 
gpio of my patch-set.. I ask because you NAK the whole set.
I really need the ChipSelect function to make my hardware work!

Chris

-- 
GTSYS Limited RFID Technology
A01 24/F Gold King Industrial Bld
35-41 Tai Lin Pai Road, Kwai Chung, Hong Kong
Fax (852) 8167 4060 - Tel (852) 3598 9488

Disclaimer: http://www.gtsys.com.hk/email/classified.html
