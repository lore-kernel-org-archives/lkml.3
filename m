Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaCZLvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:51:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52612 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbaCZLvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:51:23 -0400
Message-ID: <5332BF37.5090704@free-electrons.com>
Date: Wed, 26 Mar 2014 12:51:19 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/14] ARM: mvebu: ll_set_cpu_coherent always uses
 the current CPU
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com> <1395787705-31061-4-git-send-email-gregory.clement@free-electrons.com> <5332BF88.5020401@gmail.com>
In-Reply-To: <5332BF88.5020401@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/2014 12:52, Sebastian Hesselbarth wrote:
> On 03/25/2014 11:48 PM, Gregory CLEMENT wrote:
>> ll_set_cpu_coherent is always used on the current CPU, so instead of
>> passing the CPU id as argument, ll_set_cpu_coherent() can find it by
>> itself.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> ---
> [...]
>> diff --git a/arch/arm/mach-mvebu/coherency_ll.S b/arch/arm/mach-mvebu/coherency_ll.S
>> index 1f2bcd4b5424..6cb26b919787 100644
>> --- a/arch/arm/mach-mvebu/coherency_ll.S
>> +++ b/arch/arm/mach-mvebu/coherency_ll.S
>> @@ -24,9 +24,7 @@
>>   #include <asm/cp15.h>
>>
>>   	.text
>> -/*
>> - * r0: HW CPU id
>> - */
>> +
>>   ENTRY(ll_set_cpu_coherent)
>>   	mrc	p15, 0, r1, c1, c0, 0
>>   	tst	r1, #CR_M @ Check MMU bit enabled
>> @@ -43,9 +41,11 @@ ENTRY(ll_set_cpu_coherent)
>>   	ldr	r0, [r0]
>>   2:
>>   	/* Create bit by cpu index */
>> -	mov	r3, #(1 << 24)
>> -	lsl	r1, r3, r1
>> -ARM_BE8(rev	r1, r1)
>> +	mrc	15, 0, r1, cr0, cr0, 5
>> +	and	r1, r1, #15
>> +	mov	r2, #(1 << 24)
>> +	lsl	r1, r2, r1
>> +	ARM_BE8(rev	r1, r1)
> 
> nit: re-indent ARM_BE8 to the beginning of the line?

Good catch!

Thanks,

Gregory




> Sebastian
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
