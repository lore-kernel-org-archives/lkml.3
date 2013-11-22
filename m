Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3KVHpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:45:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59728 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3KVHpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:45:08 -0500
Message-ID: <528F0B80.9020900@linux-pingi.de>
Date: Fri, 22 Nov 2013 08:45:04 +0100
From: Karsten Keil <kkeil@linux-pingi.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: =?UTF-8?B?VmluY2VudCBTdGVobMOp?= <vincent.stehle@laposte.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>
Subject: Re: [PATCH linux-next] hisax: disable build for big-endian arm
References: <1385077794-17022-1-git-send-email-vincent.stehle@laposte.net> <s5hzjowhp2l.wl%tiwai@suse.de>
In-Reply-To: <s5hzjowhp2l.wl%tiwai@suse.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:uNO9kUjytwarbAJc0p7JuA9/QUZnNcSQr4bMbHhoupm
 Xx/nBHm0vHT4Qm8h6/Rt18MswU4VYMX5Cd8tbDIpbMavDMsTw6
 FlgndmDntVd5pJY349e1FmTiUBJvQijiT2AArZ8o/4CH/jwnv7
 4lCwEkfR0F03AFEMJQaamoYjPn+vRZyUt500S1SpeurT5JhJyr
 VQI2mOF6LZPEzPjC/NscKOV+srLvHd8ulb3xGakwQkrjqd+iXb
 Jaoy8BbDLrrnRkVxoR3wq922UzCF3ariuAZomzMXkB7fsflwuN
 qWS/lAFC0DGVEOTLzmbdyKzutVXX02SAki37Jrqc13FGPQIIwq
 AKYaT6FXPQLj52ZrUXZlR5oeom6dFohXCUmbc6u0H
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.11.2013 08:29, schrieb Takashi Iwai:
> At Fri, 22 Nov 2013 00:49:54 +0100,
> Vincent Stehlé wrote:
>>
>> Teles PCI and HFC PCI-bus refuse to build on big-endian ARM; disable them in
>> Kconfig.
>>
>> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
>> Cc: Karsten Keil <isdn@linux-pingi.de>
>> ---
>>
>> Hi,
>>
>> This can be seen on e.g. linux next-20131121 with arm allyesconfig.
>>
>> Best regards,
>>
>> V.
>>
>>  drivers/isdn/hisax/Kconfig | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
>> index d9edcc9..53dbb75 100644
>> --- a/drivers/isdn/hisax/Kconfig
>> +++ b/drivers/isdn/hisax/Kconfig
>> @@ -109,7 +109,7 @@ config HISAX_16_3
>>  
>>  config HISAX_TELESPCI
>>  	bool "Teles PCI"
>> -	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
>> +	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN) || (ARM && !CPU_LITTLE_ENDIAN)))
> 
> Isn't it a bit better to exclude CPU_LITTLE_ENDIAN globally?
> 
> 	depends on PCI && CPU_LITTLE_ENDIAN && (BROKEN || !(SPARC || PPC || PARISC || M68K || MIPS || FRV || XTENSA || ARM))
> 
> Or maybe just
> 
> 	depends on PCI && (X86 || BROKEN)
> 
> (Alpha?  Can anyone test? :)

I never got this card so it was never in my tests, if I remember
correctely  somebody had it running with Alpha before 2000.
And yes I'm fine if we simplify this mess to only X86.

Karsten
