Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaEGOeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:34:06 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33049 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752169AbaEGOeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:34:04 -0400
Message-ID: <536A4454.5020404@hurleysoftware.com>
Date: Wed, 07 May 2014 10:33:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Donnefort <vdonnefort@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Lee Jones <lee.jones@linaro.org>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.15-rc3] BUG: null ptr dereference in ichx_gpio_request_regions()
References: <536A339D.9030606@hurleysoftware.com> <20140507140558.GA26294@ks3318809.kimsufi.com>
In-Reply-To: <20140507140558.GA26294@ks3318809.kimsufi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On 05/07/2014 10:05 AM, Vincent Donnefort wrote:
> Hello Peter,

>> This is almost certainly caused by the uninitialized regs ptr
>> in the ich6_desc struct (i3100_desc struct has the same problem)
>> introduced in this commit:
>>
>> commit bb62a35bd5d96e506af0ea8dd145480b9172a2a6
>> Author: Vincent Donnefort <vdonnefort@gmail.com>
>> Date:   Fri Feb 14 15:01:56 2014 +0100
>>
>>      gpio: ich: Add support for multiple register addresses
>>
>>      This patch introduces regs and reglen pointers which allow a chipset to have
>>      register addresses differing from ICH ones.
>>
>>      Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>      Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
>>      Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>
> Yes indeed, this must be linked to this thread https://lkml.org/lkml/2014/4/15/292

Thanks for the link.

I searched through LKML but without the driver name or the offending function
in the commit message I couldn't find it.

Linus,

What tree is this bug fix trapped in? I see it didn't make -rc4 either.

Regards,
Peter Hurley
