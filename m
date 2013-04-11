Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678Ab3DKNAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:00:54 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40031 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3DKNAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:00:53 -0400
Message-ID: <5166B3FE.4000002@gmail.com>
Date: Thu, 11 Apr 2013 21:00:46 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
CC: Simon Jeons <simon.jeons@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
References: <51662D5B.3050001@hitachi.com> <516633BB.40307@gmail.com> <5166B1DF.8070504@hitachi.com>
In-Reply-To: <5166B1DF.8070504@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mitsuhiro,
On 04/11/2013 08:51 PM, Mitsuhiro Tanino wrote:
> (2013/04/11 12:53), Simon Jeons wrote:
>> One question against mce instead of the patchset. ;-)
>>
>> When check memory is bad? Before memory access? Is there a process scan it period?
> Hi Simon-san,
>
> Yes, there is a process to scan memory periodically.
>
> At Intel Nehalem-EX and CPUs after Nehalem-EX generation, MCA recovery
> is supported. MCA recovery provides error detection and isolation
> features to work together with OS.
> One of the MCA Recovery features is Memory Scrubbing. It periodically
> checks memory in the background of OS.

Memory Scrubbing is a kernel thread? Where is the codes of memory scrubbing?

>
> If Memory Scrubbing find an uncorrectable error on a memory before
> OS accesses the memory bit, MCA recovery notifies SRAO error into OS

It maybe can't find memory error timely since it is sleeping when memory 
error occur, can this case happened?

> and OS handles the SRAO error using hwpoison function.
>
> Regards,
> Mitsuhiro Tanino
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

