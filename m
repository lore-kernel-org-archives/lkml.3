Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3DLNn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:43:56 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41707 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3DLNnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:43:55 -0400
Message-ID: <51680F97.3020407@hitachi.com>
Date: Fri, 12 Apr 2013 22:43:51 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ric Mason <ric.masonn@gmail.com>
Cc: Simon Jeons <simon.jeons@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
References: <51662D5B.3050001@hitachi.com> <516633BB.40307@gmail.com> <5166B1DF.8070504@hitachi.com> <5166B3FE.4000002@gmail.com>
In-Reply-To: <5166B3FE.4000002@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/11 22:00), Ric Mason wrote:
> Hi Mitsuhiro,
> On 04/11/2013 08:51 PM, Mitsuhiro Tanino wrote:
>> (2013/04/11 12:53), Simon Jeons wrote:
>>> One question against mce instead of the patchset. ;-)
>>>
>>> When check memory is bad? Before memory access? Is there a process scan it period?
>> Hi Simon-san,
>>
>> Yes, there is a process to scan memory periodically.
>>
>> At Intel Nehalem-EX and CPUs after Nehalem-EX generation, MCA recovery
>> is supported. MCA recovery provides error detection and isolation
>> features to work together with OS.
>> One of the MCA Recovery features is Memory Scrubbing. It periodically
>> checks memory in the background of OS.
> 
> Memory Scrubbing is a kernel thread? Where is the codes of memory scrubbing?

Hi Ric,

No. One of the MCA Recovery features is Memory Scrubbing.
And Memory Scrubbing is a hardware feature of Intel CPU.

OS has a hwpoison feature which is included at mm/memory-failure.c.
A main function is memory_failure().

If Memory Scrubbing finds a memory error, MCA recovery notifies SRAO error
into OS and OS handles the SRAO error using hwpoison function.


>> If Memory Scrubbing find an uncorrectable error on a memory before
>> OS accesses the memory bit, MCA recovery notifies SRAO error into OS
> 
> It maybe can't find memory error timely since it is sleeping when memory error occur, can this case happened?

Memory Scrubbing seems to be operated periodically but I don't have
information about how oftern it is executed.

Regards,
Mitsuhiro Tanino

