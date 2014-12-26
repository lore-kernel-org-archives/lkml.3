Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaLZRFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 12:05:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58990 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaLZRFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 12:05:08 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CANCZXo4LbSrUU_=LuXmrJ3=aC6cvtDD77JVa6Hhe1y5GTNuK5g@mail.gmail.com>
References: <1419596562-20679-1-git-send-email-kuleshovmail@gmail.com> <20141226143532.GB28213@newt.localdomain> <CANCZXo4LbSrUU_=LuXmrJ3=aC6cvtDD77JVa6Hhe1y5GTNuK5g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] x86: Remove excess calculations for heap_end_ptr
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 26 Dec 2014 09:04:51 -0800
To: Alexander Kuleshov <kuleshovmail@gmail.com>,
        Jeremiah Mahler <jmmahler@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <60579BEB-2AD0-4A4E-BFC8-FE0BDB688DC7@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, the -512 is not related to STACK_SIZE, so this patch is wrong.  NAK.

On December 26, 2014 9:03:38 AM PST, Alexander Kuleshov <kuleshovmail@gmail.com> wrote:
>Yes, you're right,
>
>At first i thought that it is just typo, and right after that i
>thought about this case when somebody will change STACK_SIZE
>
>2014-12-26 20:35 GMT+06:00 Jeremiah Mahler <jmmahler@gmail.com>:
>> Alexander,
>>
>> On Fri, Dec 26, 2014 at 06:22:42PM +0600, Alexander Kuleshov wrote:
>>> heap_end_ptr default value defined as _end+STACK_SZE-512, but
>>                                             STACK_SIZE
>>
>>> STACK_SIZE is already 512.
>>>
>>> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
>>> ---
>>>  arch/x86/boot/header.S | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
>>> index 16ef025..c69b870 100644
>>> --- a/arch/x86/boot/header.S
>>> +++ b/arch/x86/boot/header.S
>>> @@ -342,7 +342,7 @@ ramdisk_size:     .long   0               # its
>size in bytes
>>>  bootsect_kludge:
>>>               .long   0               # obsolete
>>>
>>> -heap_end_ptr:        .word   _end+STACK_SIZE-512
>>> +heap_end_ptr:        .word   _end
>>>                                       # (Header version 0x0201 or
>later)
>>>                                       # space from here (exclusive)
>down to
>>>                                       # end of setup code can be
>used by setup
>>
>> So right now STACK_SIZE happens to be 512 so STACK_SIZE-512 is zero.
>> What happens if someone changes the size of STACK_SIZE?
>>
>> This change doesn't fix any problem right now and creates potential
>> problems in the future.
>>
>>> --
>>> 2.2.1.201.gbbcefff
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>> --
>> - Jeremiah Mahler

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
