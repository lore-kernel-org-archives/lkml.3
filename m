Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaLTXjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 18:39:37 -0500
Received: from senator.holtmann.net ([87.106.208.187]:41648 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaLTXjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 18:39:35 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: bluetooth: Add hci_h4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141220154850.GA28390@amd>
Date: Sun, 21 Dec 2014 00:39:31 +0100
Cc: =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5AC947DA-87BA-48B7-ABB8-7663B3D3E844@holtmann.org>
References: <20141213223727.GA13894@amd> <97C706D6-765B-446A-8180-600F5FB6C68B@holtmann.org> <20141219095000.GA24703@amd> <7DC7F8DF-CBC7-47CE-8B6F-5BA19ADBB3B6@holtmann.org> <20141220154850.GA28390@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>>> I have trouble understanding... h4p_hci_open() seems to be called as
>>> soon as I insmod the driver. Who does that? Is it some kind of udev
>>> magic?
>> 
>> As soon as you do hci_register_dev, it will bring up the device and run the basic initialization. That is needed to get the address, version information and features. Otherwise the mgmt interface can not work. We need basic information about the device.
>> 
>> So what the kernel will do internally when you find a device is bring it up, get the basics and then bring it back down (in case nobody uses it). See hci_power_on work.
>> 
> 
> Aha, slightly unexpected, but it matches observations. Good.

we are at Bluetooth 4.2 specification now. Thinks got a lot more complicated these days.

> 
>>> To use __hci_cmd_sync()
>>> 
>>>>> +
>>>>> +	SET_HCIDEV_DEV(hdev, info->dev);
>>>>> +
>>>>> +	if (hci_register_dev(hdev) >= 0)
>>>>> +		return 0;
>>>>> +
>>>>> +	dev_err(info->dev, "hci_register failed %s.\n", hdev->name);
>>>>> +	hci_free_dev(info->hdev);
>>>>> +	return -ENODEV;
>>>>> +}
>>>> 
>>>> And normally this is folded into the probe handling and not in a
>>>> separate function.
>>> 
>>> The probe function is too long, already...
>> 
>> Have you compared it to other functions. Normally probe() functions in general are all pretty long since they have to do tons of stuff. Having all in one function means you can read through it at once.
>> 
> 
> Ok.
> 
>>>>> +#include "hci_h4p.h"
>>>> 
>>>> Why is this a separate file? And if so, why not all UART specific details are in this file. Including bunch of the defines you have in the header.
>>>> 
>>> 
>>> Well, you wanted less global functions, so I moved some as inlines to
>>> headers. I guess I can merge nokia_core and nokia_uart if really wanted.
>> 
>> Would this become easier when some of the OMAP specific stuff is moved out of this driver? If that is possible.
>> 
> 
> Yes, I can investigate further cleanups. But original plan was to
> merge it and then clean up the rest. Could we do that, please?

You need to fix all these small details. There are tons of whitespace damages, indentation issues, trailing whitespaces and what not. Even if they were in the original driver to begin this, they can not be in a driver submitted these days.

Regards

Marcel

