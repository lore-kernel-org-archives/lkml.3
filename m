Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3IBD1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 23:27:37 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28749 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab3IBD1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 23:27:36 -0400
X-Spam-Score: -100.9
Message-ID: <52240566.3040201@asianux.com>
Date: Mon, 02 Sep 2013 11:26:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] h8300/kernel/setup.c: add "linux/initrd.h" to pass
 compiling
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com> <5220254E.3050704@roeck-us.net> <52203CF0.5040600@asianux.com> <52207F74.6000702@roeck-us.net> <CAFLxGvyExTMSWOppheCwDA8RorSu_mLqW9a3f3GKFrsA2xbkfA@mail.gmail.com> <52208DFD.20105@roeck-us.net>
In-Reply-To: <52208DFD.20105@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 08:20 PM, Guenter Roeck wrote:
> On 08/30/2013 04:44 AM, richard -rw- weinberger wrote:
>> On Fri, Aug 30, 2013 at 1:18 PM, Guenter Roeck <linux@roeck-us.net>
>> wrote:
>>> On 08/29/2013 11:34 PM, Chen Gang wrote:
>>>>
>>>> On 08/30/2013 12:53 PM, Guenter Roeck wrote:
>>>>>
>>>>> On 08/29/2013 08:59 PM, Chen Gang wrote:
>>>>>>
>>>>>> The related error (allmodconfig for h8300):
>>>>>>
>>>>>>      arch/h8300/kernel/setup.c: In function 'setup_arch':
>>>>>>      arch/h8300/kernel/setup.c:103:3: error: 'initrd_start'
>>>>>> undeclared
>>>>>> (first use in this function)
>>>>>>         initrd_start = memory_start;
>>>>>>         ^
>>>>>>      arch/h8300/kernel/setup.c:103:3: note: each undeclared
>>>>>> identifier
>>>>>> is reported only once for each function it appears in
>>>>>>      arch/h8300/kernel/setup.c:104:3: error: 'initrd_end' undeclared
>>>>>> (first use in this function)
>>>>>>         initrd_end = memory_start += be32_to_cpu(((unsigned long *)
>>>>>> (memory_start))[2]);
>>>>>>         ^
>>>>>>
>>>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>>>> ---
>>>>>
>>>>>
>>>>> Maybe an odd question, but is there a way to actually compile the
>>>>> h8300
>>>>> target
>>>>
>>>>
>>>> Firstly, at least for me, I don't think it is an odd question.  :-)
>>>>
>>>> For the tool-chain:
>>>>
>>>>     I compiled the cross-compiler from the gcc and binutils source
>>>> code.
>>>>     GCC has too many bugs to compile kernel with -Os (normal make will
>>>> fail).
>>>>     If without -Os (no optimization), it can work correctly which is
>>>> enough
>>>> for my goal: "let h8300 pass allmodconfig".  ;-)
>>>>
>>>>>  From building with allmodconfig for h8300:
>>>>
>>>>
>>>>     I can find more chances to provide contributes (both for h8300
>>>> and for
>>>> others).
>>>>     I can learn more in kernel wide.
>>>>     I can familiar the gcc and binutils step by step (especially to
>>>> familiar with their issues).
>>>>
>>>> Next:
>>>>
>>>>     I will communicate/work with the gcc guys for the gcc issues which
>>>> found by building kernel.
>>>>
>>>>     :-)
>>>>
>>>>
>>>>
>>>>> in the first place ? The cross compiler on kernel.org doesn't work,
>>>>> nor
>>>>> does
>>>>> the one available through Ubuntu.
>>>>>
>>>>> Guenter
>>>>>
>>>>
>>>> For binutils, no release under Ubuntu, and the Fedora17's is incorrect
>>>> (can not use), but the binutils-2.22 from gnu is OK.
>>>>
>>>> For gcc, no release under Ubuntu, for Fedora17's, gcc-4.9, gcc-4.8,
>>>> gcc-4.7.4, and gcc-4.4.7 all have bugs for compiling kernel(their bugs
>>>> are different too).
>>>>
>>>> It is really not easy to fix these bugs (gcc guys have too many issues
>>>> to fix), even if really find the root cause, it is still difficult to
>>>> fix (fix one bug is very easy to cause another more issues).
>>>>
>>>
>>> I have to wonder ... is this all worth it ? It almost looks like no one
>>> is using this architecture anymore. Do you have target hardware to test
>>> any of your changes ?
>>

No, I have no related hardwares.

Hmm... but I still think it is worth to do:

  1. until now, we do not get confirmation that "h8300 is useless, need remove it from kernel".

  2. it is an architecture which may cause more issues (no MMU, but has IOMAP; support ISA, but not support PCI; has gpio, but not use gpio lib, ...).
     so can have more chances to fine another related sub-systems' issues.

  3. It is worth to scan all architectures one by one, and let all of them pass compiling with allmodconfig, h8300 is part of them.
       

>> Chen has to achieve his 10 patches/month quota. :-\
>>

Yeah, it is a basic requrement to me (which I made by myself, it is not
my company's requirement).

It is a protection goal:

  if I finish them or more, does not mean I am well done (more patches may not mean more contributes).
  if I can not finish them, that means I should improve myself in time.

> 
> I don't mind that, but there might be more valuable targets to achieve
> that goal
> than a potentially dead architecture.
> 

Yeah, in fact, I feel each architecture can archieve that goal (e.g.
with srandconfig, or find issues only by reading source code).

And now I am scanning all architectures by cross-compiling with
allmodconfig, h8300 is just one of them.

:-)


> A more useful change may be to remove the code from the kernel if there
> is no plan
> to fix it (for real, I mean).
> 

Hmm... if we are sure about it, that sounds reasonable to me (but
excuse me, I can not sure about it).

Welcome any other members' suggestions or completions.


> Guenter
> 
> 
> 


Thanks.
-- 
Chen Gang
