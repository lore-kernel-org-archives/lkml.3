Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaINJIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:08:36 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51039 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaINJIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:08:34 -0400
Message-ID: <54155B14.9060809@gmail.com>
Date: Sun, 14 Sep 2014 17:08:36 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: eparis@redhat.com, paulmck@linux.vnet.ibm.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, zhenglong.cai@cs2c.com.cn,
        khilman@linaro.org, ak@linux.intel.com, mcgrof@suse.com,
        fabf@skynet.be, "dhowells@redhat.com" <dhowells@redhat.com>,
        pefoley2@pefoley.com, mgorman@suse.de, biederm@xmission.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] init/Kconfig: Add ENDIAN attributes for all architectures
 using
References: <540494D6.40701@gmail.com> <20140901160828.GJ26632@windriver.com> <5404A66E.509@zytor.com> <20140902051737.GK26632@windriver.com> <54055FF8.3080907@gmail.com> <5406FFBD.8010207@gmail.com>
In-Reply-To: <5406FFBD.8010207@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Is this patch worthy enough to be applied?

Welcome any ideas, suggestions or completions.

Thanks.

On 09/03/2014 07:47 PM, Chen Gang wrote:
> On 09/02/2014 02:13 PM, Chen Gang wrote:
>> On 9/2/14 13:17, Paul Gortmaker wrote:
>>>
>>> OK, but that was not at _all_ what I thought when looking at this...
>>>
>>> Instead I saw a well intentioned, but perhaps not fully thought out
>>> attempt at fixing a largely irrelevant randconfig/allmodconfig of a
>>> 1990's vintage ISDN driver coming from that x86-only era, built against
>>> an architecture that will never use or support it (microblaze).
>>>
>>> In today's world, we'd probably not accept a new ethernet driver or
>>> filesystem if it was incapable of handling both BE and LE (exception
>>> being SoC ethernet physically bound to one specific CPU, of course.)
>>> So the justification given in the commit log for expanding the scope to
>>> better deal with the stuff found in ISDN and the like was questionable.
>>>
>>
> 
> I guess, we are mainly focus on: "Is it worthy enough to add *ENDIAN in
> init/Kconfig?"
> 
> It seems really few modules need depend on LE or BE (although I am still
> not quite sure). If it is true, for me, only for architectures, it is
> still worthy enough to let all duplicated *ENDIAN to one place.
> 
> If it is still worthy, maybe this patch need be improvement (especially,
> for its comments), so please help check when you have time, thanks.
> 
> 
> Welcome any other members' ideas, suggestions, or completions.
> 
> Thanks.
> 
>> After a simple search, for crypto, it may be endian sensitive, and for
>> architectures may be endian sensitive, in config time.
>>
>>   bash-3.2# find ./ | grep Kconfig | xargs grep depend | grep ENDIAN
>>   .//arch/arm/mm/Kconfig:	depends on ARCH_SUPPORTS_BIG_ENDIAN
>>   .//arch/arm/mm/Kconfig:	depends on CPU_BIG_ENDIAN
>>   .//arch/arm/mm/Kconfig:	depends on CPU_BIG_ENDIAN
>>   .//arch/arm64/Kconfig:	depends on OF && !CPU_BIG_ENDIAN
>>   .//arch/mips/Kconfig:	depends on SYS_SUPPORTS_BIG_ENDIAN
>>   .//arch/mips/Kconfig:	depends on SYS_SUPPORTS_LITTLE_ENDIAN
>>   .//arch/mips/Kconfig:	depends on SGI_IP22 || SGI_IP28 || (SNI_RM && CPU_LITTLE_ENDIAN)
>>   .//arch/powerpc/platforms/Kconfig.cputype:	depends on !CPU_LITTLE_ENDIAN
>>   .//arch/powerpc/platforms/Kconfig.cputype:	depends on PPC_BOOK3S_64 && !CPU_LITTLE_ENDIAN
>>   .//arch/powerpc/platforms/Kconfig.cputype:	depends on PPC_BOOK3S_64 && !CPU_LITTLE_ENDIAN
>>   .//arch/powerpc/platforms/Kconfig.cputype:	depends on PPC_BOOK3S_64 && !CPU_LITTLE_ENDIAN
>>   .//arch/powerpc/platforms/Kconfig.cputype:	depends on PPC_BOOK3S_64 && !CPU_LITTLE_ENDIAN
>>   .//arch/powerpc/platforms/Kconfig.cputype:	depends on CPU_LITTLE_ENDIAN
>>   [...]
>>   .//crypto/Kconfig:	depends on ARM && KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
>>   .//crypto/Kconfig:	depends on ARM && KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
>>   .//drivers/crypto/Kconfig:	depends on PPC64 && IBMVIO && !CPU_LITTLE_ENDIAN
>>   [...]
>>
>> It is a simple search, so I am not sure whether have other modules also
>> need LE or BE.
>>
> 
> Thanks.
> 


-- 
Chen Gang

Open share and attitude like air water and life which God blessed
