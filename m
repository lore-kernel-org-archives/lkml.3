Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaGMPCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 11:02:43 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41764 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaGMPCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 11:02:34 -0400
Message-ID: <53C29F84.6010108@gmail.com>
Date: Sun, 13 Jul 2014 23:02:28 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Richard Weinberger <richard@nod.at>, Lennox Wu <lennox.wu@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmitry.torokhov@gmail.com, thierry.reding@gmail.com, jic23@kernel.org,
        wim@iguana.be, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kys@microsoft.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        teg@jklm.no, Mischa.Jonker@synopsys.com, msalter@redhat.com,
        knaack.h@gmx.de, rdunlap@infradead.org, linux-input@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-watchdog@vger.kernel.org,
        Liqin Chen <liqin.linux@gmail.com>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <53C1F7DE.3060102@gmail.com>	<201407130545.23004.marex@denx.de> <CAF0htA60juBVkPo2HQKMDGcEr-wRzRVL_6JgHAa+7WVE_E8M0Q@mail.gmail.com> <53C25551.1050909@nod.at> <53C288F0.3070001@metafoo.de> <53C28C4A.70907@nod.at> <53C29015.5070607@metafoo.de> <53C291C8.6050303@nod.at> <53C296C2.30304@metafoo.de>
In-Reply-To: <53C296C2.30304@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2014 10:25 PM, Lars-Peter Clausen wrote:
> On 07/13/2014 04:03 PM, Richard Weinberger wrote:
>> Am 13.07.2014 15:56, schrieb Lars-Peter Clausen:
>>> On 07/13/2014 03:40 PM, Richard Weinberger wrote:
>>>> Am 13.07.2014 15:26, schrieb Lars-Peter Clausen:
>>>>> On 07/13/2014 11:45 AM, Richard Weinberger wrote:
>>>>>> Am 13.07.2014 11:27, schrieb Lennox Wu:
>>>>>>> As I said before, some configurations don't make sense.
>>>>>>
>>>>>> If such a configuration can be achieved using allmod/yesconfig it has to be fixed.
>>>>>> Chen's fixes seem reasonable as not all architectures support iomem.
>>>>>
>>>>> Maybe we should stub out ioremap() and friends when COMPILE_TEST is enabled to avoid these linker errors. That's in my opinion better than turning most of the 'depends on
>>>>> COMPILE_TEST' into 'depends on COMPILE_TEST && HAS_IOMEM'. The issue comes up quite a lot and it is often overlooked when adding a driver that can be build when COMPILE_TEST is
>>>>> enabled.
>>>>
>>>> And what should this stub do?
>>>> Except calling BUG()...
>>>
>>> return NULL;
>>>
>>> It's for compile testing, it's not meant to work at runtime.
>>
>> Hm, I really don't like the idea of having a non-working kernel.
>> IMHO either it should build _and_ run and nothing else.
>> Greg, what do you think?
> 
> The kernel will still be working fine and you can run it on a system. The drivers which use ioremap() or similar are probably not instantiated on a system that does not provide HAS_IOMEM. But even if it was the driver should handle ioremap() returning NULL gracefully and abort the driver probe. That said you'll probably not run a kernel that was built with COMPILE_TEST on your real hardware since it contains so many drivers that are completely useless on your hardware. The idea of COMPILE_TEST is to have as much compile test exposure as possible to the code that is enabled by COMPILE_TEST. Stubbing out ioremap() and friends when HAS_IOMEM is not set and COMPILE_TEST is set makes it easier to get there.
> 

For me, welcome Greg's idea or suggestion for it.

And also if the reply contents are wrapped (e.g. within 80 or less), that
will generate a better display under other members' email clients.


Thanks
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
