Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaG1SC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:02:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48206 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaG1SC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:02:26 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [v2] input: drv260x: Add TI drv260x haptics driver
Thread-Topic: [v2] input: drv260x: Add TI drv260x haptics driver
Thread-Index: AQHPqoRzccs1z7hlMk6AmjOpJP7QQQ==
Date: Mon, 28 Jul 2014 18:02:23 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DAF68F@DFLE09.ent.ti.com>
References: <1406566403-1436-1-git-send-email-dmurphy@ti.com>
 <20140728174334.GD8982@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry

Thanks for the comments

On 07/28/2014 12:43 PM, Dmitry Torokhov wrote:
> Hi Dan,
> 
> On Mon, Jul 28, 2014 at 11:53:23AM -0500, Dan Murphy wrote:
>> Add the TI drv260x haptics/vibrator driver.
>> This device uses the input force feedback
>> to produce a wave form to driver an
>> ERM or LRA actuator device.
>>
>> The initial driver supports the devices
>> real time playback mode.  But the device
>> has additional wave patterns in ROM.
> 
> As it presented the device appears to be a memoryless device, however
> you present it to the rest of the system as if it can support playback
> of multiple effects simultaneously, which is incorrect.
> 
> My guess that you need to engage the memoryless input library to schedule
> handling multiple effects for your device, including ramping up, ramping
> down, stopping playback when effects runs out, etc.
> 
> Thanks.
>  
> 


I had written the driver originally to be a memless device.

But when calling the driver from user space I was not getting the duration,
strength of any information from the ff_device structure except the type.
The values in the structure were all being passed as 0's.

I will attempt it again as a memless device.

Dan

-- 
------------------
Dan Murphy
