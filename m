Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab3IXIAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:00:09 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:31976 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab3IXIAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:00:08 -0400
Message-ID: <52414682.3010608@c-s.fr>
Date: Tue, 24 Sep 2013 10:00:02 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [PATCH v2] powerpc 8xx: Fixing issue with CONFIG_PIN_TLB
References: <201309121825.r8CIPrkI005690@localhost.localdomain>   <1379011469.2536.45.camel@snotra.buserror.net> <52329CDF.9020103@c-s.fr>  <1379365336.2536.166.camel@snotra.buserror.net> <5238860F.4030405@c-s.fr> <1379712141.16231.36.camel@aoeu.buserror.net>
In-Reply-To: <1379712141.16231.36.camel@aoeu.buserror.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 20/09/2013 23:22, Scott Wood a écrit :
>>> The hardware wants to decrement; why fight it?
>> >I see your point.
>> >However it is not clear in the documentation if the decrement is done
>> >really after the update, or at xTLB interrupt. So I propose to still set
>> >the CTR ourself as described in the reference Manual and not assume that
>> >the HW decrements it.
> It says "every update" -- do you have any reason to believe that's
> wrong?  It could be tested...
>
>
Ok. I just test it,  and I observe the following: As we have set the 
RSV4x bit, the CPU sets Mx_CTR to a value below 0x1c after each update:
* After writing entry 0x1c, Mx_CTR has value 0x1b
* After writing entry 0x1d, Mx_CTR has value 0x18
* After writing entry 0x1e, Mx_CTR has value 0x19
* After writing entry 0x1f, Mx_CTR has value 0x1a

Indeed the first version of my patch was complete, only the description 
was not fully correct.
So, in order to minimise code churn, I will re-submit my initial patch 
with a modified description.

Christophe
