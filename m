Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaG1Oth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:49:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44390 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaG1Otd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:49:33 -0400
Message-ID: <53D662E9.5050409@oracle.com>
Date: Mon, 28 Jul 2014 10:49:13 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
CC: James Morris <james.l.morris@oracle.com>, serge@hallyn.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: security: oops on boot in __key_link_begin
References: <53D31D16.1030806@oracle.com> <26466.1406547132@warthog.procyon.org.uk>
In-Reply-To: <26466.1406547132@warthog.procyon.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 07:32 AM, David Howells wrote:
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>>   23:	49 89 9f f0 00 00 00 	mov    %rbx,0xf0(%r15)
>>   2a:	55                   	push   %rbp
>>   2b:*	c1 b8 42 ff 49 8b 5f 	sarl   $0x5f,-0x74b600be(%rax)		<-- trapping instruction
>>   32:	10 49 8d             	adc    %cl,-0x73(%rcx)
> 
> I can't make any sense of this.  It doesn't look anything like what I
> get when I disassemble assoc_array_insert().  There are no SARL or ADC
> instructions.
> 
> Can you load your vmlinux into gdb and disassemble the function that holds the
> faulting instruction:
> 
> 	gdb vmlinux
> 	(gdb) disassemble <RIP-value>
> 
> Unfortunately, I'm not sure what the RIP value actually is because it's been
> replaced in the dump by source file + line number.  It's not this:
> 
> 	[   31.330473] CR2: ffffffff8b49ff42
> 
> though.  That's RAX (ie. 0) plus the offset in the following instruction:
> 
> 	sarl   $0x5f,-0x74b600be(%rax)		<-- trapping instruction

Hrm, the code on disk and in memory doesn't look anything like the one in the BUG...

I've tried keys-next and linux-next for today and it didn't reproduce, but it did
show up again when I applied the KASAN patchset (Cc Andrey).

Sorry for pointing a finger to the wrong place, it reproduced so reliably with the
same call trace that I didn't even suspect anything else.


Thanks,
Sasha

