Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaFBOa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:30:26 -0400
Received: from mout.gmx.net ([212.227.17.20]:63318 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbaFBO36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:29:58 -0400
Message-ID: <538C8A59.2070907@gmx.de>
Date: Mon, 02 Jun 2014 16:29:45 +0200
From: Michael Lawnick <ml.lawnick@gmx.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>
CC: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] i2c: Make I2C ID tables non-mandatory for DT'ed and/or
 ACPI'ed devices
References: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>	<1401452797-29521-2-git-send-email-lee.jones@linaro.org>	<20140530123656.GC2742@katana>	<20140530133405.GB29731@lee--X1>	<20140530174800.GA4917@katana>	<20140530192516.GA4319@lee--X1>	<20140531134805.GA3287@katana> <CACRpkdZvyfA0aaJe3YuevXfA2pTZLRPZ3mQpitL6qD7=qE0Xyg@mail.gmail.com>
In-Reply-To: <CACRpkdZvyfA0aaJe3YuevXfA2pTZLRPZ3mQpitL6qD7=qE0Xyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:RAu86f+/iUC3o9KwDvULdQ2sCEAN1CSI6gxSV+V8NnzT8dpp+AW
 ETKRmymnhyq7g9jlOdnPgRZhC3VbwKt3IE1ibkYb100KY4Xpq3hDIuQW4aP21dZfkIwC0PB
 RQXIWBbkTzWyW/XWfDIOpv6IQXTPf6TIPkQphhOuTEfccqO6EW7a7fv3tWnSvVUTfSjBnmp
 1bEeVLhXFGSOiMFt+K9+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.06.2014 14:16, schrieb Linus Walleij:
> On Sat, May 31, 2014 at 3:48 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>>
>>> Right, I read the function which provides the functionality, but my
>>> point is; I don't think my patch changes the semantics in a way which
>>> would adversely affect this option.  If you think that it does, can you
>>> specify how please?
>>
>> Currently, if a driver would be DT only and does not provide a seperate
>> i2c_device_id table, then the driver is unusable with method 4. I don't
>> like to have some drivers being capable of it and some not.
>>
>>> Does the sysfs method create a i2c_device_id table?  If not, how does
>>> it probe successfully pre-patch?
>>
>> The sysfs method creates a device. Its name is matched against
>> i2c_device_ids only since it does not have a node pointer for DT to be
>> matched against.
>
> Is this really so useful on embedded systems?
>
> I was under the impression that this method was something used
> on say PC desktops with temperature monitors and EEPROMs
> on some I2C link on the PCB, usage entirely optional and fun
> for userspace hacks.
>
We use it for dynamic instantiating whole subsystems with multiplexers, 
sensors, controllers in an embedded system. The device list is taken 
from an I2C eeprom which gets read on hotplug.

KR
Michael


