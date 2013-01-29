Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3A2CVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:21:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48612 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3A2CVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:21:48 -0500
Message-ID: <51073207.7040607@zytor.com>
Date: Mon, 28 Jan 2013 18:20:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Renninger <trenn@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, horms@verge.net.au
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump
 usage
References: <1358868049-19884-1-git-send-email-trenn@suse.de> <CAE9FiQWJqWQJhoJb2dBn=iAsKjxuf3MJro-jz+6k+WNZor8-xQ@mail.gmail.com> <CAE9FiQWXcwagEb0jdFfdHvNcByNxtaLbvvoRC-jAppQmiGS22w@mail.gmail.com> <6950516.1uefDuthAH@hammer82.arch.suse.de> <510721C6.6080705@zytor.com> <CAE9FiQWDcFR+6L-GiR6rk60TC0zH=xewyH_h1Rx_QB+8PTiU3Q@mail.gmail.com> <51072FEF.50000@zytor.com> <CAE9FiQVG4ShGKSdjzYhQaXNNhS=MVNJg=QqG1yW-mAUscErXMA@mail.gmail.com>
In-Reply-To: <CAE9FiQVG4ShGKSdjzYhQaXNNhS=MVNJg=QqG1yW-mAUscErXMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 06:19 PM, Yinghai Lu wrote:
> On Mon, Jan 28, 2013 at 6:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 01/28/2013 06:10 PM, Yinghai Lu wrote:
>>>
>>>
>>> kexec-tools will change that to E820_KDUMP_RESERVED (or other good name).
>>>
>>> We only need to update kernel to get old max_pfn by
>>> checking E820_KDUMP_RESERVED.
>>>
>>
>> OK, I have asked this before, but I still have not gotten any acceptable
>> answer:
>>
>> Why do we still have max_*_pfn at all?  Shouldn't it all be based on
>> memblocks by now?
>
> saved_max_pfn is used for kdump:
> drivers/char/mem.c::read_oldmem will stop there.
> ...
>          while (count) {
>                  pfn = *ppos / PAGE_SIZE;
>                  if (pfn > saved_max_pfn)
>                          return read;
> ...

That is a non-answer.

Why do we have *any* instances of max_pfn or max_low_pfn in the kernel 
anymore?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

