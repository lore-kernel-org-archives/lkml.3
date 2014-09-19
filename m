Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaISHiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 03:38:07 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:53722 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaISHiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 03:38:05 -0400
Message-ID: <541BDD58.6060707@c-s.fr>
Date: Fri, 19 Sep 2014 09:38:00 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
Subject: Re: [PATCH v3 03/21] powerpc/8xx: exception InstructionAccess does
 not exist on MPC8xx
References: <20140917163657.7737D1AB032@localhost.localdomain> <OF3CC96BF2.DF7CB060-ONC1257D57.00533ED7-C1257D57.0053CADF@transmode.se> <541B0B66.8030405@c-s.fr> <OFB7DFC74D.65FC1C31-ONC1257D57.00632BC3-C1257D57.00640A0B@transmode.se> <541B2E45.5070900@c-s.fr> <OFFF48B453.8913C6B0-ONC1257D57.006DED24-C1257D57.006E0FCC@transmode.se>
In-Reply-To: <OFFF48B453.8913C6B0-ONC1257D57.006DED24-C1257D57.006E0FCC@transmode.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 18/09/2014 22:02, Joakim Tjernlund a écrit :
> christophe leroy <christophe.leroy@c-s.fr> wrote on 2014/09/18 21:11:01:
>>
>> Le 18/09/2014 20:12, Joakim Tjernlund a écrit :
>>> leroy christophe <christophe.leroy@c-s.fr> wrote on 2014/09/18
> 18:42:14:
>>>> Le 18/09/2014 17:15, Joakim Tjernlund a écrit :
>>>>> Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2014/09/17
>>> 18:36:57:
>>>>>> Exception InstructionAccess does not exist on MPC8xx. No need to
>>> branch
>>>>> there from somewhere else.
>>>>>> Handling can be done directly in InstructionTLBError Exception.
>>>>>>
>>>>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>>>         . = 0x1200
>>>>     DataStoreTLBMiss:
>>>> @@ -477,7 +475,11 @@ DataStoreTLBMiss:
>>>>      */
>>>>         . = 0x1300
>>>>     InstructionTLBError:
>>>> -    b    InstructionAccess
>>>> +    EXCEPTION_PROLOG
>>>> +    mr    r4,r12
>>>> +    mr    r5,r9
>>>> +    /* 0x400 is InstructionAccess exception, needed by
> bad_page_fault()
>>> */
>>>> +    EXC_XFER_LITE(0x400, handle_page_fault)
>>> You should have the code in TLBMiss and have the TLBError branch there
> as
>>> that is the common case.
>> As far as I remember, I tried it already but we don't have enough space
>> in TLBmiss for that. We can only have 40 instructions.
> Do your other optimizations first, then you might have space :)
>
>

Even with the optimisation first, there is no chance to fit ITLBError 
instructions after ITLBMiss and before DTLBMiss.
After optimisation, TLBMiss goes from 0x1100 to 0x1174. TLBError goes 
from 0x1300 to 0x13b4. DTLBMiss is at 0x1200
And this is without CPU6 ERRATA. So this is hopeless I believe.

Christophe
