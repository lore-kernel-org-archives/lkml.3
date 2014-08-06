Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaHFHJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 03:09:24 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:22078 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbaHFHJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 03:09:20 -0400
Message-ID: <53E1D497.3080309@bfs.de>
Date: Wed, 06 Aug 2014 09:09:11 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: andrey.krieger.utkin@gmail.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/sparc/math-emu/math_32.c: drop stray break operator
References: <1407185261-1799-1-git-send-email-andrey.krieger.utkin@gmail.com>	<53E083B8.4090008@bfs.de> <20140805.124939.1701979639778778101.davem@davemloft.net>
In-Reply-To: <20140805.124939.1701979639778778101.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 05.08.2014 21:49, schrieb David Miller:
> From: walter harms <wharms@bfs.de>
> Date: Tue, 05 Aug 2014 09:11:52 +0200
> 
>>
>>
>> Am 04.08.2014 22:47, schrieb Andrey Utkin:
>>> This commit is a guesswork, but it seems to make sense to drop this
>>> break, as otherwise the following line is never executed and becomes
>>> dead code. And that following line actually saves the result of
>>> local calculation by the pointer given in function argument. So the
>>> proposed change makes sense if this code in the whole makes sense (but I
>>> am unable to analyze it in the whole).
>>>
>>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81641
>>> Reported-by: David Binderman <dcb314@hotmail.com>
>>> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
>>> ---
>>>  arch/sparc/math-emu/math_32.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/sparc/math-emu/math_32.c b/arch/sparc/math-emu/math_32.c
>>> index aa4d55b..5ce8f2f 100644
>>> --- a/arch/sparc/math-emu/math_32.c
>>> +++ b/arch/sparc/math-emu/math_32.c
>>> @@ -499,7 +499,7 @@ static int do_one_mathemu(u32 insn, unsigned long *pfsr, unsigned long *fregs)
>>>  		case 0: fsr = *pfsr;
>>>  			if (IR == -1) IR = 2;
>>>  			/* fcc is always fcc0 */
>>
>> The patch looks ok, but can somebody comment on this comment ?
>> what "fcc" ? should it be a fsr ?
> 
> It's the condition code field inside of the %fsr register.
> 
> In 32-bit chips there is only one set of condition codes, whereas
> on 64-bit chips there are 4 sets referred to as fcc0, fcc1, fcc2,
> and fcc3.
> 
> That's what this comment is talking about.
> 
thx for info,

would you mind to add your explanation ?
It is much mor helpful that the comment right now.

re,
 wh

