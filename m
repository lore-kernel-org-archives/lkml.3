Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaEHWLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:11:38 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47844 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755745AbaEHWLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:11:37 -0400
Message-ID: <536C010F.3060504@hurleysoftware.com>
Date: Thu, 08 May 2014 18:11:27 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>
CC: Vincent Donnefort <vdonnefort@gmail.com>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.15-rc3] BUG: null ptr dereference in ichx_gpio_request_regions()
References: <536A339D.9030606@hurleysoftware.com>	<20140507140558.GA26294@ks3318809.kimsufi.com>	<536A4454.5020404@hurleysoftware.com> <CACRpkdZ_Wz2QLbdbXEL9CWy+=tcVwjVjVqQgYw7_dy-5FwxB9Q@mail.gmail.com>
In-Reply-To: <CACRpkdZ_Wz2QLbdbXEL9CWy+=tcVwjVjVqQgYw7_dy-5FwxB9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 05:48 PM, Linus Walleij wrote:
> On Wed, May 7, 2014 at 4:33 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> Hi Vincent,
>>
>> On 05/07/2014 10:05 AM, Vincent Donnefort wrote:
>>>
>>> Hello Peter,
>>
>>
>>>> This is almost certainly caused by the uninitialized regs ptr
>>>> in the ich6_desc struct (i3100_desc struct has the same problem)
>>>> introduced in this commit:
>>>>
>>>> commit bb62a35bd5d96e506af0ea8dd145480b9172a2a6
>>>> Author: Vincent Donnefort <vdonnefort@gmail.com>
>>>> Date:   Fri Feb 14 15:01:56 2014 +0100
>>>>
>>>>       gpio: ich: Add support for multiple register addresses
>>>>
>>>>       This patch introduces regs and reglen pointers which allow a chipset
>>>> to have
>>>>       register addresses differing from ICH ones.
>>>>
>>>>       Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>>>       Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
>>>>       Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>>
>>>
>>> Yes indeed, this must be linked to this thread
>>> https://lkml.org/lkml/2014/4/15/292
>>
>>
>> Thanks for the link.
>>
>> I searched through LKML but without the driver name or the offending
>> function
>> in the commit message I couldn't find it.
>>
>> Linus,
>>
>> What tree is this bug fix trapped in? I see it didn't make -rc4 either.
>
> Since the last signoff is Lee I guess it's in the MFD tree?

The commit above is the buggy commit. I don't have a commit id for
the bug fix since I don't know what tree it's stuck in. Looking over
Lee's tree, I don't see it.

Below is your signoff on LKML of the fix.

On 04/22/2014 05:15 PM, Linus Walleij wrote:
 > On Tue, Apr 15, 2014 at 2:21 PM, Vincent Donnefort <vdonnefort@gmail.com> wrote:
 >
 >> From: Vincent Donnefort <vdonnefort@gmail.com>
 >>
 >> This patch fixes kernel NULL pointer BUG introduced by the following commit:
 >> b667cf488aa9476b0ab64acd91f2a96f188cfd21
 >> gpio: ich: Add support for multiple register addresses.
 >>
 >> Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
 >
 > Patch applied for fixes with Eric's tested-by tag.

Please expedite this fix as it has already missed -rc3 & -rc4.

Regards,
Peter Hurley
