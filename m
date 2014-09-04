Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbaIDV5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:57:34 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:57069 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaIDV5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:57:32 -0400
MIME-Version: 1.0
Reply-To: zoobab@gmail.com
In-Reply-To: <20140904173521.GA20343@localhost.localdomain>
References: <20140831152456.GA25207@udknight>
	<20140904173521.GA20343@localhost.localdomain>
Date: Thu, 4 Sep 2014 23:57:31 +0200
Message-ID: <CANjd3nc5==yDpRVMxP+bzhqhEqyK4SUam=Ood4RMpsN5esuG4A@mail.gmail.com>
Subject: Re: [PATCH v8] usb:serial:pl2303: add GPIOs interface on PL2303
From: Benjamin Henrion <zoobab@gmail.com>
To: Wang YanQing <udknight@gmail.com>, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, Johan Hovold <jhovold@gmail.com>,
        andi@lisas.de, dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Henrion <zoobab@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 7:35 PM, Wang YanQing <udknight@gmail.com> wrote:
> On Sun, Aug 31, 2014 at 11:24:56PM +0800, Wang YanQing wrote:
>> PL2303 USB Serial devices may has GPIOs, this patch add
>> basic PL2303 gpio support.
>>
>> Known issue:
>> If gpios are in use(export to userspace through sysfs interface, etc),
>> then call pl2303_release(unplug usb-serial convertor, modprobe -r, etc),
>> will cause trouble, so we need to make sure there is no gpio user before
>> call pl2303_release.
>>
>> Signed-off-by: Wang YanQing <udknight@gmail.com>
>> ---
>>  Note: I sniffed office HXD gpio test program to get
>>        gpios control protocol with PL2303 RA, so I only
>>        test it with PL2303 RA and HXA, I don't have HXD,
>>        but because it is *office* HXD gpio test program,
>>        so if it doesn't work with HXD, I will feel surprise.

I can confirm your patch is working fine on the HXD:

http://www.zoobab.com/pl2303hxd-gpio

I am still hunting for a simple C program to test the speed of the
GPIOs and sysfs, if you have a good reference.

Best,

-- 
Benjamin Henrion <bhenrion at ffii.org>
FFII Brussels - +32-484-566109 - +32-2-4148403
"In July 2005, after several failed attempts to legalise software
patents in Europe, the patent establishment changed its strategy.
Instead of explicitly seeking to sanction the patentability of
software, they are now seeking to create a central European patent
court, which would establish and enforce patentability rules in their
favor, without any possibility of correction by competing courts or
democratically elected legislators."
