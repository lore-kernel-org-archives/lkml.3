Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaICBwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:52:55 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50482 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaICBwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:52:54 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <54067473.3060900@roeck-us.net>
Date: Tue, 02 Sep 2014 18:52:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Xuetao Guan <gxt@pku.edu.cn>
CC: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFJlOiDlm57lpI3vvJogU3RhdHVzIG9mICd1bmk=?=
 =?UTF-8?B?Y29yZTMyJyBhcmNoaXRlY3R1cmUgaW4gTGludXgga2VybmVs?=
References: <717685015.32253.1409702968099.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <717685015.32253.1409702968099.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 05:09 PM, Xuetao Guan  wrote:
>
> [...]
>>>
>>>>
>>>> unicore32: Add ocd console and qemu-defconfig to support qemu simulator
>>>> 	This patch adds a primitive OCD console to communicate with qemu.
>>>> 	The same code is already used for early console support.
>>>
>>> Do you mean there's the same/similar code in QEMU.
>>>
>> No, I mean that the ocd functions in the linux kernel (such as ocd_putc) are
>> used by both earlyprintk and the ocd console code.
> Yes. By the way, it's only for qemu and fpga debug.
>
>>
>>>>
>>>> With this patch added, and with qemu_defconfig as provided by the same patch,
>>>> it is possible to build and load a unicore32 image in qemu using the following
>>>> qemu command line.
>>>>
>>>> qemu-system-unicore32 -curses -M puv3 -m 512 -kernel arch/unicore32/boot/zImage
>>>>
>>>> Caveats:
>>>> - The use of -nographic instead of -curses causes a qemu crash
>>> Yes, since qemu curses code was modified to meet the simple OCD console requirement.
>>>
>> The lack of support for -nographic is a problem for scripted testing.
>> The issue is that we have to interpret console output for scripted testing,
>> and having to go through curses makes that a bit difficult.
>>
>> Wonder if '-nographic' can be modeled as '-curses' with no available terminal
>> configuration. At least in theory that should work, but executing the above
>> command with TERM=dumb yields no output. Wonder how difficult it would be to
>> change that.
>
> I see. I'll try to make -nographic work anyway.
>
Another possibility would be to support "-display none". Unfortunately that also
causes qemu to crash :-(.

Guenter

