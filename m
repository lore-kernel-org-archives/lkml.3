Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3H3LSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:18:15 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55850 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3H3LSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:18:14 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52207F74.6000702@roeck-us.net>
Date: Fri, 30 Aug 2013 04:18:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2]  h8300/kernel/setup.c: add "linux/initrd.h" to pass
 compiling
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com> <5220254E.3050704@roeck-us.net> <52203CF0.5040600@asianux.com>
In-Reply-To: <52203CF0.5040600@asianux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 11:34 PM, Chen Gang wrote:
> On 08/30/2013 12:53 PM, Guenter Roeck wrote:
>> On 08/29/2013 08:59 PM, Chen Gang wrote:
>>> The related error (allmodconfig for h8300):
>>>
>>>     arch/h8300/kernel/setup.c: In function 'setup_arch':
>>>     arch/h8300/kernel/setup.c:103:3: error: 'initrd_start' undeclared
>>> (first use in this function)
>>>        initrd_start = memory_start;
>>>        ^
>>>     arch/h8300/kernel/setup.c:103:3: note: each undeclared identifier
>>> is reported only once for each function it appears in
>>>     arch/h8300/kernel/setup.c:104:3: error: 'initrd_end' undeclared
>>> (first use in this function)
>>>        initrd_end = memory_start += be32_to_cpu(((unsigned long *)
>>> (memory_start))[2]);
>>>        ^
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> ---
>>
>> Maybe an odd question, but is there a way to actually compile the h8300
>> target
>
> Firstly, at least for me, I don't think it is an odd question.  :-)
>
> For the tool-chain:
>
>    I compiled the cross-compiler from the gcc and binutils source code.
>    GCC has too many bugs to compile kernel with -Os (normal make will fail).
>    If without -Os (no optimization), it can work correctly which is enough for my goal: "let h8300 pass allmodconfig".  ;-)
>
>>From building with allmodconfig for h8300:
>
>    I can find more chances to provide contributes (both for h8300 and for others).
>    I can learn more in kernel wide.
>    I can familiar the gcc and binutils step by step (especially to familiar with their issues).
>
> Next:
>
>    I will communicate/work with the gcc guys for the gcc issues which found by building kernel.
>
>    :-)
>
>
>
>> in the first place ? The cross compiler on kernel.org doesn't work, nor
>> does
>> the one available through Ubuntu.
>>
>> Guenter
>>
>
> For binutils, no release under Ubuntu, and the Fedora17's is incorrect
> (can not use), but the binutils-2.22 from gnu is OK.
>
> For gcc, no release under Ubuntu, for Fedora17's, gcc-4.9, gcc-4.8,
> gcc-4.7.4, and gcc-4.4.7 all have bugs for compiling kernel(their bugs
> are different too).
>
> It is really not easy to fix these bugs (gcc guys have too many issues
> to fix), even if really find the root cause, it is still difficult to
> fix (fix one bug is very easy to cause another more issues).
>

I have to wonder ... is this all worth it ? It almost looks like no one
is using this architecture anymore. Do you have target hardware to test
any of your changes ?

Thanks,
Guenter

