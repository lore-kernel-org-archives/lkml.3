Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3J0Mfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 08:35:30 -0400
Received: from intranet.asianux.com ([58.214.24.6]:58762 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab3J0Mf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 08:35:28 -0400
X-Spam-Score: -100.8
Message-ID: <526D084E.5080007@asianux.com>
Date: Sun, 27 Oct 2013 20:34:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Joern Rennecke <joern.rennecke@embecosm.com>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Takashi Iwai <tiwai@suse.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Sam Ravnborg <sam@ravnborg.org>, Joe Perches <joe@perches.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: Portable assmbler code - newline
References: <523FD9E7.3050303@asianux.com>	<523FDBD7.4040602@asianux.com>	<C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com>	<523FE578.5060801@asianux.com>	<52672DAC.1030307@asianux.com>	<CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com>	<52673E41.6040606@asianux.com>	<5267AF98.1010800@asianux.com>	<5268B0B1.9050009@asianux.com>	<CAFLxGvzERDqwZhb_5d=bXKmqz6-Yrema_TLMTM7rjyeFeDJG_w@mail.gmail.com>	<526958D8.6030102@synopsys.com> <CAMuHMdURxpuWPYYDTU2Sa4eF8WZTb=0ALQ+irtGk9ERtSKz09Q@mail.gmail.com> <5269FD53.6040903@synopsys.com> <526BC5D4.9070809@asianux.com> <526CC0AD.8090208@synopsys.com>
In-Reply-To: <526CC0AD.8090208@synopsys.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2013 03:28 PM, Vineet Gupta wrote:
> On 10/26/2013 07:08 PM, Chen Gang wrote:
>> On 10/25/2013 01:10 PM, Vineet Gupta wrote:
>>> Eh ! My untested patch was broken but not because of what you mentioned.
>>>
>>> For ARC, the ; negating the newline annotation. So the following works (backquote
>>> is new line for ARC)
>>>
>>> diff --git a/arch/arc/include/asm/linkage.h b/arch/arc/include/asm/linkage.h
>>> index 0283e9e44e0d..b3eea2999322 100644
>>> --- a/arch/arc/include/asm/linkage.h
>>> +++ b/arch/arc/include/asm/linkage.h
>>> @@ -9,6 +9,8 @@
>>>  #ifndef __ASM_LINKAGE_H
>>>  #define __ASM_LINKAGE_H
>>>
>>> +#define __ARCH_NL      `
>>> +
>>>  #ifdef __ASSEMBLY__
>>>
>>>
>>> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
>>> index d3e8ad23a8e0..969e70ad231a 100644
>>> --- a/include/linux/linkage.h
>>> +++ b/include/linux/linkage.h
>>> @@ -6,6 +6,10 @@
>>>  #include <linux/export.h>
>>>  #include <asm/linkage.h>
>>>
>>> +#ifndef __ARCH_NL
>>> +#define __ARCH_NL      ;
>>> +#endif
>>> +
>>>  #ifdef __cplusplus
>>>  #define CPP_ASMLINKAGE extern "C"
>>>  #else
>>> @@ -75,7 +79,7 @@
>>>
>>>  #ifndef ENTRY
>>>  #define ENTRY(name) \
>>> -  .globl name; \
>>> +  .globl name __ARCH_NL \
>>>    ALIGN; \
>>
>> Do we also need consider about "ALIGN;"?
> 
> Right - as I said already, above was not a formal patch but a RFC whether we are
> on right track. The proper fix will have to audit all such places.
> 
> 
>>>    name:
>>>  #endif
>>>
>>
>> For next-20130927 tree, do we also need consider about WEAK, ENDPROC?
> 
> Indeed.
> 
> 
>> I am not quite sure about it, but I will try. 
> 
> So you volunteer to send out a patch base don __ARCH_NL I proposed above ?
> 
> 

OK, I will/should try.

Hmm... I am 'almost' a volunteer: my company support what I have done
for Public Open Source, they treat it as important thing.

Now you are mainly focusing on arc, and I want/try to focus on kernel
wide. This patch belongs to kernel wide, and at least now, nobody
rejects me for it, so I will/should try.


>> Now, I am just analyzing
>> another issue -- maybe the last issue for allmodconfig under arc, which
>> may be related with this patch, the errors are:
>>
>>       1   Building modules, stage 2.
>>       2   MODPOST 2994 modules
>>       3 ERROR: "__st_r13_to_r20" [sound/usb/snd-usbmidi-lib.ko] undefined!
> 
> Yes we know about this already. This is to do with libgcc linkage. The fix is non
> trivial - I'll get back to you on this. For now disable CONFIG_CC_OPTIMIZE_FOR_SIZE.
> 

OK, thank you for your valuable information in time, at least, it saves
my time resources, after pass this issue, hope our arc can pass
allmodconfig.

:-)

> -Vineet
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Thanks.
-- 
Chen Gang

-- 
Chen Gang
