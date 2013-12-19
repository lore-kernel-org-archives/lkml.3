Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3LSNLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:11:20 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:62100 "EHLO
	smtp-relay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab3LSNLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:11:15 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        David Howells <dhowells@redhat.com>, "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH] Revert "ARC: Add guard macro to uapi/asm/unistd.h"
Thread-Topic: [PATCH] Revert "ARC: Add guard macro to uapi/asm/unistd.h"
Thread-Index: AQHO/KthBWRy4QaiG0mR0SRbAza3qQ==
Date: Thu, 19 Dec 2013 13:11:09 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075172B5E@IN01WEMBXA.internal.synopsys.com>
References: <1387451598-14490-1-git-send-email-vgupta@synopsys.com>
 <52B2E7D9.4030908@gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 06:04 PM, Chen Gang wrote:
> On 12/19/2013 07:13 PM, Vineet Gupta wrote:
>> > This reverts commit 97bc386fc12deeb41d5bff33548e3002b258d4e0.
>> > 
>> > Generic syscall table generator relies on ARCH unistd.h as follows:
>> > 
>> > 	void *sys_call_table[NR_syscalls] = {
>> > 		[0 ... NR_syscalls-1] = sys_ni_syscall,
>> > 	#include <asm/unistd.h>
>> > 	};
>> > 
>> > And turns out that prior dependencies already include that header by
>> > the time preprocessor hits the above. Meaning ARCH unistd.h needs to be
>> > able to included twice.
>> > 
> OK, thanks, it sounds reasonable to me.
>
> But why many other architectures contents these guard macros? (arm, sh,
> blackfin, cris, frv, ia64, m32r, m68k, mips, s390, microblaze, mn10300,
> parisc, powerpc, sparc, x86). Do they need improvement too?
>
> And for our case, what xtensa has done looks like a better way to me.

Yeah, looks like that'll work - good find. Linus, please ignore the Revert, I'll
follow up with a pull request.

-Vineet
