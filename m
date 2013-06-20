Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab3FTMaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:30:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56768 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757631Ab3FTMaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:30:21 -0400
Message-ID: <51C2F5C2.5040004@ti.com>
Date: Thu, 20 Jun 2013 15:29:54 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <stern@rowland.harvard.edu>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC PATCH 1/6] mfd: omap-usb-host: move initialization to module_init()
References: <1371650753-11452-1-git-send-email-rogerq@ti.com> <1371650753-11452-2-git-send-email-rogerq@ti.com> <20130620120746.GC9817@arwen.pp.htv.fi>
In-Reply-To: <20130620120746.GC9817@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 03:07 PM, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Jun 19, 2013 at 05:05:48PM +0300, Roger Quadros wrote:
>> We no longer need to be initialized in any particular order
>> so move driver initialization to the standard place i.e. module_init()
>>
>> CC: Samuel Ortiz <sameo@linux.intel.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  drivers/mfd/omap-usb-host.c |   10 +---------
>>  drivers/mfd/omap-usb-tll.c  |    8 +-------
>>  2 files changed, 2 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>> index 759fae3..6601a49 100644
>> --- a/drivers/mfd/omap-usb-host.c
>> +++ b/drivers/mfd/omap-usb-host.c
>> @@ -908,15 +908,7 @@ static int __init omap_usbhs_drvinit(void)
>>  {
>>  	return platform_driver_probe(&usbhs_omap_driver, usbhs_omap_probe);
>>  }
>> -
>> -/*
>> - * init before ehci and ohci drivers;
>> - * The usbhs core driver should be initialized much before
>> - * the omap ehci and ohci probe functions are called.
>> - * This usbhs core driver should be initialized after
>> - * usb tll driver
>> - */
>> -fs_initcall_sync(omap_usbhs_drvinit);
>> +module_init(omap_usbhs_drvinit);
>>  
>>  static void __exit omap_usbhs_drvexit(void)
>>  {
>> diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
>> index e59ac4c..fb7c73e 100644
>> --- a/drivers/mfd/omap-usb-tll.c
>> +++ b/drivers/mfd/omap-usb-tll.c
>> @@ -482,13 +482,7 @@ static int __init omap_usbtll_drvinit(void)
>>  {
>>  	return platform_driver_register(&usbtll_omap_driver);
>>  }
>> -
>> -/*
>> - * init before usbhs core driver;
>> - * The usbtll driver should be initialized before
>> - * the usbhs core driver probe function is called.
>> - */
>> -fs_initcall(omap_usbtll_drvinit);
>> +module_init(omap_usbtll_drvinit);
> 
> since you're doing that, could just move to module_platform_driver.
> 
sounds good.

cheers,
-roger
