Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaJVHMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:12:13 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:58198 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaJVHML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:12:11 -0400
Message-ID: <544758AB.3060100@openwrt.org>
Date: Wed, 22 Oct 2014 09:11:39 +0200
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: eunb.song@samsung.com, "ralf@linux-mips.org" <ralf@linux-mips.org>
CC: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mips: add arch_trigger_all_cpu_backtrace() function
References: <1061520101.169091413960858532.JavaMail.weblogic@epmlwas02b>
In-Reply-To: <1061520101.169091413960858532.JavaMail.weblogic@epmlwas02b>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/10/2014 08:54, Eunbong Song wrote:
> 
>> Hi Eubong,
> 
>> one small question inline ...
> 
>>> +void arch_trigger_all_cpu_backtrace(bool); +#define
>>> arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
> 
>> What is the purpose of this define ? is this maybe a leftover from
>> some regex/cleanups ?
> 
> Hi John.
> Actually, I just follow the same function of sparc architecture.
> You can find this in arch/sparc/include/asm/irq_64.h as below
> 
> void arch_trigger_all_cpu_backtrace(bool);
> #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
> 
> I guess this is used for conditional compile. 
> See below.
> include/linux/nmi.h
> #ifdef arch_trigger_all_cpu_backtrace
> static inline bool trigger_all_cpu_backtrace(void)
> {
>         arch_trigger_all_cpu_backtrace(true);
> 
>         return true;
> }
> static inline bool trigger_allbutself_cpu_backtrace(void)
> {
>         arch_trigger_all_cpu_backtrace(false);
>         return true;
> }
> #else
> static inline bool trigger_all_cpu_backtrace(void)
> {
>         return false;
> }
> static inline bool trigger_allbutself_cpu_backtrace(void)
> {
>         return false;
> }
> #endif
> 
> Thanks. 
>> John
> 

i don't see how this is required for conditional compiles. the code
define a->a which is bogus i think.

	John
