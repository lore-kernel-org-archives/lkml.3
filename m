Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab3LSNnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:43:06 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41029 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3LSNnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:43:02 -0500
Message-ID: <52B2F7E2.6020403@gmail.com>
Date: Thu, 19 Dec 2013 21:42:58 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Revert "ARC: Add guard macro to uapi/asm/unistd.h"
References: <1387451598-14490-1-git-send-email-vgupta@synopsys.com> <52B2E7D9.4030908@gmail.com> <C2D7FE5348E1B147BCA15975FBA23075172B5E@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075172B5E@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 09:11 PM, Vineet Gupta wrote:
> On 12/19/2013 06:04 PM, Chen Gang wrote:
>> On 12/19/2013 07:13 PM, Vineet Gupta wrote:
>>>> This reverts commit 97bc386fc12deeb41d5bff33548e3002b258d4e0.
>>>>
>>>> Generic syscall table generator relies on ARCH unistd.h as follows:
>>>>
>>>> 	void *sys_call_table[NR_syscalls] = {
>>>> 		[0 ... NR_syscalls-1] = sys_ni_syscall,
>>>> 	#include <asm/unistd.h>
>>>> 	};
>>>>
>>>> And turns out that prior dependencies already include that header by
>>>> the time preprocessor hits the above. Meaning ARCH unistd.h needs to be
>>>> able to included twice.
>>>>
>> OK, thanks, it sounds reasonable to me.
>>
>> But why many other architectures contents these guard macros? (arm, sh,
>> blackfin, cris, frv, ia64, m32r, m68k, mips, s390, microblaze, mn10300,
>> parisc, powerpc, sparc, x86). Do they need improvement too?
>>
>> And for our case, what xtensa has done looks like a better way to me.
> 
> Yeah, looks like that'll work - good find. Linus, please ignore the Revert, I'll
> follow up with a pull request.
> 

Thanks.  :-)

> -Vineet
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
