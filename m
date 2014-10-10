Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaJJJah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:30:37 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:47761 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaJJJae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:30:34 -0400
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="48120885"
Message-ID: <5437A737.2030509@broadcom.com>
Date: Fri, 10 Oct 2014 11:30:31 +0200
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Guenter Roeck <linux@roeck-us.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bcma: Add dependency on OF_ADDRESS
References: <1412872877-1771-1-git-send-email-linux@roeck-us.net> <CACna6rzOeGcKrrftLx_3uWe_bAXQaQMmWb3wWHP0CjtdO8D0eg@mail.gmail.com> <5436C2B4.6030801@broadcom.com> <5436C367.5080908@broadcom.com> <20141009172924.GD2410@roeck-us.net> <5436D3CF.2030506@hauke-m.de> <20141009192520.GA6552@roeck-us.net> <54370298.2040502@hauke-m.de>
In-Reply-To: <54370298.2040502@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/14 23:48, Hauke Mehrtens wrote:
> On 10/09/2014 09:25 PM, Guenter Roeck wrote:
>> On Thu, Oct 09, 2014 at 08:28:31PM +0200, Hauke Mehrtens wrote:
>>> On 10/09/2014 07:29 PM, Guenter Roeck wrote:
>>>> On Thu, Oct 09, 2014 at 07:18:31PM +0200, Arend van Spriel wrote:
>>>>> On 10/09/14 19:15, Arend van Spriel wrote:
>>>>>> On 10/09/14 18:54, Rafał Miłecki wrote:
>>>>>>> On 9 October 2014 18:41, Guenter Roeck<linux@roeck-us.net>  wrote:
>>>>>>>> Commit 2101e533f41a ("bcma: register bcma as device tree driver")
>>>>>>>> introduces a hard dependency on OF_ADDRESS into the bcma driver.
>>>>>>>> OF_ADDRESS is specifically disabled for the sparc architecture.
>>>>>>>> This results in the following error when building sparc64:allmodconfig.
>>>>>>
>>>>>> Does this mean on sparc (using allmodconfig) you will get CONFIG_OF and
>>>>>> !CONFIG_OF_ADDRESS? Does that makes sense?
>>>>>
>>>>> Is CONFIG_OF is used on sparc to access OpenBoot information?
>>>>>
>>>> I have no idea. All I know is that the driver doesn't build anymore with OF
>>>> enabled and OF_ADDRESS disabled.
>>>
>>> Device tree support in bcma is only needed on some SoC, when this is
>>> used on a PCIe card it is not needed.
>>>
>>> I would just deactivate the parts that are using device tree in bcma
>>> when it is not available. I will send a patch after having something to eat.
>>>
>> Devicetree dependency is already covered with #ifdef CONFIG_OF. Problem is
>> that it really needs #ifdef CONFIG_OF_ADDRESS. Though even that might be
>> better than my patch, since it would at least build the driver on sparc
>> as it used to do.
>>
>>> Is there a better method which is compatible with SPARC than using
>>> of_translate_address() to get the reg address and also take the ranges
>>> attribute of the bus into account?
>>>
>> No idea, sorry. Can you by any chance use pcie device information
>> instead of depending on devicetree data ?
>
> Device tree is not used for PCIe devices in bcma. We only use it when
> bcma is used for the system bus on some Broadcom SoCs, currently there
> is no plan to use device tree for PCIe devices in bcma. I think bcma is
> only used on wifi cards connected via PCIe on Sparc systems.

When we mainlined I verified the brcmsmac was working on a sparc system. 
However, at that time we were not using BCMA. I do not recall whether or 
not we tested on sparc with BCMA support. I might give it a spin again.

Regards,
Arend
