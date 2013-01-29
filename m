Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3A2C2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:28:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48658 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab3A2C2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:28:08 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQVG4ShGKSdjzYhQaXNNhS=MVNJg=QqG1yW-mAUscErXMA@mail.gmail.com>
References: <1358868049-19884-1-git-send-email-trenn@suse.de> <CAE9FiQWJqWQJhoJb2dBn=iAsKjxuf3MJro-jz+6k+WNZor8-xQ@mail.gmail.com> <CAE9FiQWXcwagEb0jdFfdHvNcByNxtaLbvvoRC-jAppQmiGS22w@mail.gmail.com> <6950516.1uefDuthAH@hammer82.arch.suse.de> <510721C6.6080705@zytor.com> <CAE9FiQWDcFR+6L-GiR6rk60TC0zH=xewyH_h1Rx_QB+8PTiU3Q@mail.gmail.com> <51072FEF.50000@zytor.com> <CAE9FiQVG4ShGKSdjzYhQaXNNhS=MVNJg=QqG1yW-mAUscErXMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump usage
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2013 18:27:15 -0800
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Renninger <trenn@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, horms@verge.net.au
Message-ID: <4302d59f-5c87-4b82-af16-9f54625fc9ce@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be more clear: the max_pfn stuff seems like a relic of the past, and I am wondering what it would take to get rid of it.

It clearly has the wrong semantics, except perhaps in the most trivial allocator models.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Mon, Jan 28, 2013 at 6:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 01/28/2013 06:10 PM, Yinghai Lu wrote:
>>>
>>>
>>> kexec-tools will change that to E820_KDUMP_RESERVED (or other good
>name).
>>>
>>> We only need to update kernel to get old max_pfn by
>>> checking E820_KDUMP_RESERVED.
>>>
>>
>> OK, I have asked this before, but I still have not gotten any
>acceptable
>> answer:
>>
>> Why do we still have max_*_pfn at all?  Shouldn't it all be based on
>> memblocks by now?
>
>saved_max_pfn is used for kdump:
>drivers/char/mem.c::read_oldmem will stop there.
>...
>        while (count) {
>                pfn = *ppos / PAGE_SIZE;
>                if (pfn > saved_max_pfn)
>                        return read;
>...

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
