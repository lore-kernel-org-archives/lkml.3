Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaELFjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 01:39:40 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64243 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaELFjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 01:39:39 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53705E93.803@roeck-us.net>
Date: Sun, 11 May 2014 22:39:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] powerpc: Fix "attempt to move .org backwards" error (again)
References: <1399680478-4970-1-git-send-email-linux@roeck-us.net>	 <1399867920.17624.73.camel@pasglop> <1399873020.17624.79.camel@pasglop>
In-Reply-To: <1399873020.17624.79.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 10:37 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2014-05-12 at 14:12 +1000, Benjamin Herrenschmidt wrote:
>> On Fri, 2014-05-09 at 17:07 -0700, Guenter Roeck wrote:
>>> Commit 4e243b7 (powerpc: Fix "attempt to move .org backwards" error) fixes the
>>> allyesconfig build by moving machine_check_common to a different location.
>>> While this fixes most of the errors, both allmodconfig and allyesconfig still
>>> fail as follows.
>>>
>>> arch/powerpc/kernel/exceptions-64s.S:1315: Error: attempt to move .org backwards
>>>
>>> Fix by moving machine_check_common after the offending address.
>>
>> This suffers from the same problem as previous attempts, on some of my
>> test configs I get:
>>
>> arch/powerpc/kernel/head_64.o:(__ftr_alt_97+0xb0): relocation truncated to fit: R_PPC64_REL14 against `.text'+1c90
>> make[1]: *** [vmlinux] Error 1
>> make: *** [sub-make] Error 2
>>
>> IE, it breaks currently working configs.
>>
>> So we need to move more things around and I haven't had a chance to
>> sort it out.
>
> Ok, I think I sorted it out for now. It's a mess and likely to break
> again until we do something more drastic like moving everything that's
> after 0x8000 to a separate file but for now that will do. Patch on its
> way, I'll also shoot it to Linus today along with a few other things.
>

Great, thanks a lot!

Guenter

