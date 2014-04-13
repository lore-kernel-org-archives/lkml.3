Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaDMPMC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 11:12:02 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:57599 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaDMPMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 11:12:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAOGi=dPOEnNOLfnxTfvsVupRWQZtGs7-9LxDF8g2Kbun2v0hQA@mail.gmail.com>
References: <1396882237-27608-1-git-send-email-ling.ma@alipay.com>
	<877g71jdl8.fsf@tassilo.jf.intel.com>
	<CAOGi=dPOEnNOLfnxTfvsVupRWQZtGs7-9LxDF8g2Kbun2v0hQA@mail.gmail.com>
Date: Sun, 13 Apr 2014 23:11:59 +0800
Message-ID: <CAOGi=dMbRv6S+UGthYTCvW=C7hBRwpnZdM-BYYqT1fn=kF2SLg@mail.gmail.com>
Subject: Re: [PATCH RFC] x86:Improve memset with general 64bit instruction
From: Ling Ma <ling.ma.program@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, neleai@seznam.cz,
        linux-kernel@vger.kernel.org, Ling Ma <ling.ml@alibaba-inc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any further comments  ?

Thanks
Ling


2014-04-08 22:00 GMT+08:00, Ling Ma <ling.ma.program@gmail.com>:
> Andi,
>
> The below is compared result on older machine(cpu info is attached):
> That shows new code get better performance up to 1.6x.
>
> Bytes: ORG_TIME: NEW_TIME: ORG vs NEW:
> 7       0.87    0.76    1.14
> 16      0.99    0.68    1.45
> 18      1.07    0.77    1.38
> 21      1.09    0.78    1.39
> 25      1.11    0.77    1.44
> 30      1.12    0.73    1.53
> 36      1.15    0.75    1.53
> 38      1.12    0.75    1.49
> 62      1.18    0.77    1.53
> 75      1.25    0.79    1.58
> 85      1.28    0.80    1.60
> 120     1.33    0.82    1.62
> 193     1.45    0.88    1.64
> 245     1.48    0.96    1.54
> 256     1.45    0.90    1.61
> 356     1.61    1.02    1.57
> 601     1.78    1.22    1.45
> 958     2.04    1.47    1.38
> 1024    2.07    1.48    1.39
> 2048    2.80    2.21    1.26
>
> Thanks
> Ling
>
> 2014-04-08 0:42 GMT+08:00, Andi Kleen <andi@firstfloor.org>:
>> ling.ma.program@gmail.com writes:
>>
>>> From: Ling Ma <ling.ml@alibaba-inc.com>
>>>
>>> In this patch we manage to reduce miss branch prediction by
>>> avoiding using branch instructions and force destination to be aligned
>>> with general 64bit instruction.
>>> Below compared results shows we improve performance up to 1.8x
>>> (We modified test suit from Ondra, send after this patch)
>>
>> You didn't specify the CPU?
>>
>> I assume it's some Atom, as nothing else uses these open coded functions
>> anymore?
>>
>> -Andi
>>
>> --
>> ak@linux.intel.com -- Speaking for myself only
>>
>
