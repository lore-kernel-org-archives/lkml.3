Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaIJJFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:05:50 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45579 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaIJJF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:05:28 -0400
MIME-Version: 1.0
In-Reply-To: <54100FB0.1000308@imgtec.com>
References: <1410263575-26720-1-git-send-email-markos.chandras@imgtec.com>
 <20140909191736.GA7467@kroah.com> <54100AE5.6050401@imgtec.com>
 <CAPybu_128PsDN7wywntyTuCCfenBWTiS60P2g6_Hk68EMQc1CQ@mail.gmail.com> <54100FB0.1000308@imgtec.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 10 Sep 2014 11:05:07 +0200
Message-ID: <CAPybu_03BDC5+d5-Wmwz+x==5sbKHgU8Rr0JimK16yRnN65x8Q@mail.gmail.com>
Subject: Re: [PATCH linux-next] MIPS: ioctls: Add missing TIOC{S,G}RS485 definitions
To: Markos Chandras <Markos.Chandras@imgtec.com>
Cc: Greg KH <greg@kroah.com>, linux-mips@linux-mips.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Markos

Sorry for the mess. I have already send a new patch for mips using the
_IO* macros

Just to put things a bit into context:

I did made the patch for serial and tested it only in x86. I wrongly
infer that the IOCTLS were defined for all the arches (sorry :S)

Then when the patch was applied on tty-next the build-bot throw some
errors for xtensa, that I fixed without using the IO_ macros

Then you came with your patch,

I realized that this could be wrong for mor arches, so I check the
rest and make patches for them.

Greg then pointed out that I should use _IO instead of numbers, so I
remade my patches using the _IO macros. I did not want to step into
your patch so I did not prepare a new one for mips

All the _IO patches (except mips) are now merged into tty-next.

Hopefully that one also get merged soon :)


Thanks for your help and sorry for any disturbance.


On Wed, Sep 10, 2014 at 10:45 AM, Markos Chandras
<Markos.Chandras@imgtec.com> wrote:
> On 09/10/2014 09:39 AM, Ricardo Ribalda Delgado wrote:
>> Hello Greg
>>
>> Sorry, Probably my bad :). I did resend a new patch using the _IO*
>> macros, that has been now merged to tty-next
>>
>> Regards!
>>
>> On Wed, Sep 10, 2014 at 10:25 AM, Markos Chandras
>> <Markos.Chandras@imgtec.com> wrote:
>>> On 09/09/2014 08:17 PM, Greg KH wrote:
>>>> On Tue, Sep 09, 2014 at 12:52:55PM +0100, Markos Chandras wrote:
>>>>> Commit e676253b19b2d269cccf67fdb1592120a0cd0676
>>>>> (serial/8250: Add support for RS485 IOCTLs) added cases for the
>>>>> TIOC{S,G}RS485 commands but this broke the build for MIPS:
>>>>>
>>>>> drivers/tty/serial/8250/8250_core.c: In function 'serial8250_ioctl':
>>>>> drivers/tty/serial/8250/8250_core.c:2874:7: error: 'TIOCSRS485' undeclared
>>>>> (first use in this function)
>>>>> drivers/tty/serial/8250/8250_core.c:2886:7: error: 'TIOCGRS485' undeclared
>>>>> (first use in this function)
>>>>>
>>>>> This patch adds these missing definitions
>>>>>
>>>>> Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>>>> Cc: <linux-next@vger.kernel.org>
>>>>> Cc: <linux-kernel@vger.kernel.org>
>>>>> Cc: <linux-serial@vger.kernel.org>
>>>>> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
>>>>> ---
>>>>>  arch/mips/include/uapi/asm/ioctls.h | 2 ++
>>>>>  1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/arch/mips/include/uapi/asm/ioctls.h b/arch/mips/include/uapi/asm/ioctls.h
>>>>> index b1e637757fe3..34050cb6b631 100644
>>>>> --- a/arch/mips/include/uapi/asm/ioctls.h
>>>>> +++ b/arch/mips/include/uapi/asm/ioctls.h
>>>>> @@ -76,6 +76,8 @@
>>>>>
>>>>>  #define TIOCSBRK    0x5427  /* BSD compatibility */
>>>>>  #define TIOCCBRK    0x5428  /* BSD compatibility */
>>>>> +#define TIOCGRS485  0x542E
>>>>> +#define TIOCSRS485  0x542F
>>>>
>>>> Any reason you aren't using the _IOR() type macros here?
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>> Hi Greg,
>>>
>>> Not really. I am being consistent with what
>>> include/uapi/asm-generic/ioctls.h is using, and with the xtensa patch
>>> that was posted yesterday
>>>
>>> https://lkml.org/lkml/2014/9/9/27
>>>
>>> --
>>> markos
>>
>>
>>
> Hi Ricardo,
>
> Since you are taking care of the same problem on the other
> architectures, could you also make a similar patch for MIPS so they can
> all get merged via the same tree? Because, right now, MIPS is still broken.
>
> --
> markos



-- 
Ricardo Ribalda
