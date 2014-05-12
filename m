Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbaELRoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:44:04 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:36040 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbaELRoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:44:02 -0400
Message-ID: <5371085E.2050407@colorfullife.com>
Date: Mon, 12 May 2014 19:43:58 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de
Subject: Re: [PATCH 0/6] ipc/sem.c: Fix semctl(,,{GETNCNT,GETZCNT})
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com> <CAKgNAkiLwFrn=kDSrc4JSfobaM98pLVMcrCy4EoobgeXjqfK0g@mail.gmail.com>
In-Reply-To: <CAKgNAkiLwFrn=kDSrc4JSfobaM98pLVMcrCy4EoobgeXjqfK0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 05/12/2014 10:02 AM, Michael Kerrisk (man-pages) wrote:
> Hi Manfred,
>
> On Sat, May 10, 2014 at 12:03 PM, Manfred Spraul
> <manfred@colorfullife.com> wrote:
>> Hi all,
>>
>> According to the man page of semop(), semzcnt or semncnt are increased
>> exactly for the operation that couldn't proceed.
> Perhaps it's woth noting here that the man page is also pretty close
> to the POSIX text that describes semzcnt and semncnt. Form the SUSv4
> <sys/sem.h> spec:
>
> semncnt: number of processes waiting for semval to become
>          greater than current value.
> semzcnt: Number of processes waiting for semval to become 0.
Good idea, I have updated the comments.

>> The Linux implementation always tried to be clever and to increase the counters
>> for all operations that might be the reason why a task sleeps.
>>
>> The following patches fix that and make the code conform to the
>> documentation.
>>
>> The series got fairly long, because I also noticed that semzcnt was calculated
>> incorrectly.
>>
>> What do you think?
>> I ran a few test cases, and the semncnt and semzcnt counts now match
>> the expectation.
> Are any of those test cases in a form that could be used by other to
> replicate your results? Also, are there any of those tests that could
> go into the source tree?
Unfortunately I have more or less given up writing specific tests, 
instead I use a generic "change" application that allows to create 
multi-semop operations.

# ./createary 5 3
# ./change 5 0 -1 1 -1 2 -1&
# ./getall 5 -v

I wrote a simple test for semncnt, too:
# ./ncnt

https://github.com/manfred-colorfu/ipcsemtest


