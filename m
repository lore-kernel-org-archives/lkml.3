Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaCMWUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:20:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47552 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaCMWUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:20:15 -0400
Message-ID: <53222F1A.8090205@oracle.com>
Date: Thu, 13 Mar 2014 18:20:10 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>	<CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>	<5321CBDA.1060705@oracle.com> <CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
In-Reply-To: <CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 06:03 PM, Linus Torvalds wrote:
> On Thu, Mar 13, 2014 at 8:16 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> I've looked into doing it in the kernel, but it seems that it would require
>> a rather
>> large code addition just to deal with getting pretty line numbers.
>
> No no no. The *kernel* will never do line numbers, especially since
> only people who don't care about build performance compile with debug
> info, and even if you do do that, the kernel won't load it anyway.
>
> You missed the point.
>
> The kernel is going to *remove* all the hex numbers that your script
> relies on, because those hex numbers are completely worthless. They
> are worthless and annoying now, but they are *doubly* worthless if the
> kernel is compiled with base address randomization, since nobody will
> know what the hex numbers mean.
>
>> Unless I'm missing something big, is it really worth it?
>
> You're missing something big. The patch I sent earlier *is* going to
> happen one of these days, possible for 3.15. So your script that looks
> at hex numbers is broken.
>
> You need to look at the *symbol* number. In this output:
>
>       [<ffffffff810020c2>] do_one_initcall+0xc2/0x1e0
>
> that "ffffffff810020c2" is crap, and is going away. The address that
> is meaningful and valid is the "do_one_initcall+0xc2" part.
>
> *That* is the part you'd use to parse in user space.
>
> Try it today with the CONFIG_RANDOMIZE_BASE option to see. Using the
> hex number doesn't *work*.

Oh. doh. that was stupid of me.

I'll fix it up and re-send this patch.


Thanks,
Sasha

