Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab3DQFt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 01:49:56 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:64580 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab3DQFtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 01:49:52 -0400
Message-ID: <516E37FA.4020000@gmail.com>
Date: Wed, 17 Apr 2013 13:49:46 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
CC: Ric Mason <ric.masonn@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
References: <51662D5B.3050001@hitachi.com> <516633BB.40307@gmail.com> <5166B1DF.8070504@hitachi.com> <5166B3FE.4000002@gmail.com> <51680F97.3020407@hitachi.com>
In-Reply-To: <51680F97.3020407@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mitsuhiro,
On 04/12/2013 09:43 PM, Mitsuhiro Tanino wrote:
> (2013/04/11 22:00), Ric Mason wrote:
>> Hi Mitsuhiro,
>> On 04/11/2013 08:51 PM, Mitsuhiro Tanino wrote:
>>> (2013/04/11 12:53), Simon Jeons wrote:
>>>> One question against mce instead of the patchset. ;-)
>>>>
>>>> When check memory is bad? Before memory access? Is there a process scan it period?
>>> Hi Simon-san,
>>>
>>> Yes, there is a process to scan memory periodically.
>>>
>>> At Intel Nehalem-EX and CPUs after Nehalem-EX generation, MCA recovery
>>> is supported. MCA recovery provides error detection and isolation
>>> features to work together with OS.
>>> One of the MCA Recovery features is Memory Scrubbing. It periodically
>>> checks memory in the background of OS.
>> Memory Scrubbing is a kernel thread? Where is the codes of memory scrubbing?
> Hi Ric,
>
> No. One of the MCA Recovery features is Memory Scrubbing.

Memory Scrubbing is a process in CPU?

> And Memory Scrubbing is a hardware feature of Intel CPU.
>
> OS has a hwpoison feature which is included at mm/memory-failure.c.
> A main function is memory_failure().
>
> If Memory Scrubbing finds a memory error, MCA recovery notifies SRAO error
> into OS and OS handles the SRAO error using hwpoison function.
>
>
>>> If Memory Scrubbing find an uncorrectable error on a memory before
>>> OS accesses the memory bit, MCA recovery notifies SRAO error into OS
>> It maybe can't find memory error timely since it is sleeping when memory error occur, can this case happened?
> Memory Scrubbing seems to be operated periodically but I don't have
> information about how oftern it is executed.

If Memory Scurbbing doesn't catch memory error timely, who will send 
SRAR into OS?

>
> Regards,
> Mitsuhiro Tanino
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

