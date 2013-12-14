Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3LNUOT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:14:19 -0500
Received: from mail.active-venture.com ([67.228.131.205]:64811 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab3LNUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:14:18 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52ACBC18.6020301@roeck-us.net>
Date: Sat, 14 Dec 2013 12:14:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Jonas Jensen <jonas.jensen@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com> <52AC7E41.7050201@roeck-us.net> <CACmBeS3Xse5KkFqkM5Ye+qaaxpVCjyeGz7Oc9sr0PN+pZ9sztQ@mail.gmail.com> <201312141950.09447.arnd@arndb.de>
In-Reply-To: <201312141950.09447.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 10:50 AM, Arnd Bergmann wrote:
> On Saturday 14 December 2013, Jonas Jensen wrote:
>>>
>>> Conceptually it might be cleaner to write a separate driver, for example
>>> in drivers/power/restart, than plugging the functionality into
>>> the watchdog driver, at least if you don't want it in architecture
>>> or platform code. The xgene restart driver is a good example.
>>>
>>
>> Moving it to a new power/restart driver seems reasonable to me, I'm
>> really just looking for a home for it, I would have preferred a
>> hardware with reset in a separate register though.
>>
>> I now plan to remove it for v5 and submit a separate driver.
>
> I still think it's better to leave it in the watchdog driver: This
> driver attaches to the watchdog device, and adding a separate driver
> for reset means we have to trick the core Linux code into attaching
> two drivers to one device in some way, or the device tree has to fake
> a second device that doesn't exist in hardware but is only needed
> because of Linux implementation details.
>

Hmm ... not sure I agree. I don't see a problem with something like "arm,moxart-reboot".
There are already vexpress-reboot and xgene-reboot properties which do pretty much
the same.

Actually, you don't even need that; the reset driver could simply re-use the
"moxa,moxart-watchdog" property. After all, all that specifies is that there
is a compatible driver. Look for "samsung,s3c2410-wdt" for an example of another
reset handler doing just that.

Attaching it to the watchdog device seems to be more problematic given the
(currently) optional nature of the watchdog driver and its different scope.

Thanks,
Guenter

