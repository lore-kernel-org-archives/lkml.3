Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaEILap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:30:45 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59245 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756584AbaEILak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:30:40 -0400
Message-ID: <536CBC5E.5070202@hurleysoftware.com>
Date: Fri, 09 May 2014 07:30:38 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
CC: Vincent Donnefort <vdonnefort@gmail.com>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.15-rc3] BUG: null ptr dereference in ichx_gpio_request_regions()
References: <536A339D.9030606@hurleysoftware.com> <20140507140558.GA26294@ks3318809.kimsufi.com> <536A4454.5020404@hurleysoftware.com> <CACRpkdZ_Wz2QLbdbXEL9CWy+=tcVwjVjVqQgYw7_dy-5FwxB9Q@mail.gmail.com> <20140509072050.GG5767@lee--X1>
In-Reply-To: <20140509072050.GG5767@lee--X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 03:20 AM, Lee Jones wrote:
> On Thu, 08 May 2014, Linus Walleij wrote:
>
>> On Wed, May 7, 2014 at 4:33 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>>> Hi Vincent,
>>>
>>> On 05/07/2014 10:05 AM, Vincent Donnefort wrote:
>>>>
>>>> Hello Peter,
>>>
>>>
>>>>> This is almost certainly caused by the uninitialized regs ptr
>>>>> in the ich6_desc struct (i3100_desc struct has the same problem)
>>>>> introduced in this commit:
>>>>>
>>>>> commit bb62a35bd5d96e506af0ea8dd145480b9172a2a6
>>>>> Author: Vincent Donnefort <vdonnefort@gmail.com>
>>>>> Date:   Fri Feb 14 15:01:56 2014 +0100
>>>>>
>>>>>       gpio: ich: Add support for multiple register addresses
>>>>>
>>>>>       This patch introduces regs and reglen pointers which allow a chipset
>>>>> to have
>>>>>       register addresses differing from ICH ones.
>>>>>
>>>>>       Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>>>>       Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
>>>>>       Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>>>
>>>>
>>>> Yes indeed, this must be linked to this thread
>>>> https://lkml.org/lkml/2014/4/15/292
>>>
>>>
>>> Thanks for the link.
>>>
>>> I searched through LKML but without the driver name or the offending
>>> function
>>> in the commit message I couldn't find it.
>>>
>>> Linus,
>>>
>>> What tree is this bug fix trapped in? I see it didn't make -rc4 either.
>>
>> Since the last signoff is Lee I guess it's in the MFD tree?
>
> This patch is in Mainline.
>
> Search for $SUBJECT.

Hmmm. Search for '[PATCH] gpio: ich: set regs and reglen for i3100 and ich6 chipset'
(which is the bug fix for the buggy commit) turns up nothing in mainline.

This bug was reported on April 14 in -rc1 by Eric Paris here
http://lkml.iu.edu/hypermail/linux/kernel/1404.1/03833.html
and _fixed_ a day later on April 15 by Vincent Donnefort here
https://lkml.org/lkml/2014/4/15/292
It was signed off by Linus Walleij on the same day here
https://lkml.org/lkml/2014/4/22/1128

Since this bug fix never made it to mainline, I re-discovered
the bug in -rc3 and reported it here
http://lists-archives.com/linux-kernel/28051348-bug-null-ptr-dereference-in-ichx_gpio_request_regions.html
(presumably, you received a copy of that email).
Vincent replied with the link to the previous bug fix.

Since that time, I have been trying to find in which tree that
bug fix is stuck, but I just keep getting replies which show
an uncareful reading of this thread.

Regards,
Peter Hurley
