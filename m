Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3CWUZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 16:25:37 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61679 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3CWUZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 16:25:36 -0400
MIME-Version: 1.0
In-Reply-To: <514C11FB.8090507@ladisch.de>
References: <CAHG_u-=ChwiQ72O-9z1eD5Pex-niYMaRwMUOQOryYuPO154G=A@mail.gmail.com>
	<CAHG_u-=O0+2SLYQL_GtP9Yk72EcZjHaxLgu=rwB2DAPsTaXnvA@mail.gmail.com>
	<514C11FB.8090507@ladisch.de>
Date: Sat, 23 Mar 2013 17:25:35 -0300
Message-ID: <CAHG_u-kVbFzMg8FrNFaa58SOmtkKnG8pxXh88KTWC5C_3it9xA@mail.gmail.com>
Subject: Re: remap kernel static memory to user space
From: Eduardo Cruz <eduardohmdacruz@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm adding some asm code in arch/ia64/kernel/ivt.S
to gather some memory usage statistics.

>From whatever reason, when I allocate the memory using
kmalloc/vmalloc, my assembly code cashes the machine when I load the
allocated memory.

If I use static allocated memory, the asm code works.

I know the problem is not the assembly code.

The problem is that I want to be able to read this data from user space.
Since the code performance critical, I don't want to do a
copy_to_user, I prefer to mmap this data into user space.

The problem is, if I use kmalloc/vmalloc, I managed to map the memory
to user space.
However, the asm interrupt handler crashs.

On the other hand, if I use static data, the asm interrupt handler
works, while the mmap fails.

Do you have any clues?

2013/3/22 Clemens Ladisch <clemens@ladisch.de>:
> Eduardo Cruz wrote:
>> Please, anyone knows how to solve this problem?
>>
>> 2013/3/20 Eduardo Cruz <eduardohmdacruz@gmail.com>:
>>> I'm trying to remap some kernel static memory to user space using
>>> remap_pfn_range.
>
> Well, don't do that.
>
> What is the actual problem you're trying to solve?
>
>
> Regards,
> Clemens



-- 
Eduardo Henrique Molina da Cruz
PhD student
Parallel and Distributed Processing Group
Federal University of Rio Grande do Sul (UFRGS)
