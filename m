Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbbAHStU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:49:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481AbbAHStQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:49:16 -0500
Message-ID: <54AED10C.7090305@redhat.com>
Date: Thu, 08 Jan 2015 12:48:44 -0600
From: Mark Langsdorf <mlangsdo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Linux 3.19-rc3
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com> <54AE7D53.2020305@redhat.com> <20150108134520.GC14200@e104818-lin.cambridge.arm.com> <54AEBE84.6090307@redhat.com> <20150108173408.GF17290@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150108173408.GF17290@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 11:34 AM, Catalin Marinas wrote:
> On Thu, Jan 08, 2015 at 05:29:40PM +0000, Mark Langsdorf wrote:
>> On 01/08/2015 07:45 AM, Catalin Marinas wrote:
>>> On Thu, Jan 08, 2015 at 12:51:31PM +0000, Mark Langsdorf wrote:
>>>> On 01/05/2015 07:46 PM, Linus Torvalds wrote:
>>>>> It's a day delayed - not because of any particular development issues,
>>>>> but simply because I was tiling a bathroom yesterday. But rc3 is out
>>>>> there now, and things have stayed reasonably calm. I really hope that
>>>>> implies that 3.19 is looking good, but it's equally likely that it's
>>>>> just that people are still recovering from the holiday season.
>>>>
>>>> I'm consistently getting an out of memory killer triggered when
>>>> compiling the kernel (make -j 16 -s) on a 16 core ARM64 system
>>>> with 16 GB of memory. This doesn't happen when running a 3.18
>>>> kernel.
>>>>
>>>> I'm going to start bisecting the failure now, but here's the crash
>>>> log in case someone can see something obvious in it.
>>
>>> Can you disable (transparent) huge pages? I don't have any better at the
>>> moment suggestion apart from bisecting.
>>
>> I didn't have transparent huge pages on. Turning off hugetblfs didn't
>> change anything. Turning off 64K pages isn't an option because of
>> firmware constraints.
>
> What constraints are these? I thought they could only happen the other
> way around (4K to 64K).

I was confused. I can turn off 64K pages with only minor loss of
functionality (network MAC address gets corrupted; I can work around
for testing).

With 4K pages, the oom killer doesn't trigger during `make -j 16 -s`
on a fresh kernel. Thanks for the suggestion. I'm not sure what to do
about that, though.

--Mark Langsdorf


