Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaBXIDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:03:52 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:46899 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaBXIDu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 24 Feb 2014 03:03:50 -0500
Message-Id: <530B0AF2020000780011E97B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 24 Feb 2014 08:03:46 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Borkmann" <dborkman@redhat.com>
Cc: <davem@davemloft.net>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <ffusco@redhat.com>, <tgraf@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com>
 <5308938A.8070506@redhat.com>
In-Reply-To: <5308938A.8070506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.02.14 at 13:09, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 02/21/2014 11:33 AM, Jan Beulich wrote:
>> ... to match its two callers (i.e. the alternative would have been to
>> swap the arguments at the call sites).
>>
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> Cc: Francesco Fusco <ffusco@redhat.com>
>> Cc: Daniel Borkmann <dborkman@redhat.com>
>> Cc: Thomas Graf <tgraf@redhat.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> ---
>>   arch/x86/lib/hash.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- 3.14-rc3-x86-hash-crc32.orig/arch/x86/lib/hash.c
>> +++ 3.14-rc3-x86-hash-crc32/arch/x86/lib/hash.c
>> @@ -37,7 +37,7 @@
>>   #include <asm/cpufeature.h>
>>   #include <asm/hash.h>
>>
>> -static inline u32 crc32_u32(u32 crc, u32 val)
>> +static inline u32 crc32_u32(u32 val, u32 crc)
>>   {
>>   #ifdef CONFIG_AS_CRC32
>>   	asm ("crc32l %1,%0\n" : "+r" (crc) : "rm" (val));
> 
> Can you elaborate?
> 
> Sorry, I need to ask here (even if it's a stupid question ;)) if this
> change is safe to do; are referring to a cleanup or fixing a concrete
> bug? The code is a modified version of the DPDK hash which you can find
> in [1]. Arguments of the caller are in the correct order, afaik.
> 
>    [1] http://dpdk.org/browse/dpdk/tree/lib/librte_hash/rte_hash_crc.h 

Yes, that file appears to be correct:

rte_hash_crc_4byte(uint32_t data, uint32_t init_val)

as opposed to 

static inline u32 crc32_u32(u32 crc, u32 val)

(quite obviously data <-> val and crc <-> init_val, supported
by the second argument in each caller being named "seed").

Jan

