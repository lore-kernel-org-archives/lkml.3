Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbaDVQBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:01:36 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:38548 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902AbaDVQBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:01:30 -0400
Message-ID: <5356924E.7020605@codesourcery.com>
Date: Wed, 23 Apr 2014 00:01:18 +0800
From: Chung-Lin Tang <cltang@codesourcery.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tobias Klauser <tklauser@distanz.ch>
CC: Ley Foon Tan <lftan@altera.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <lftan.linux@gmail.com>
Subject: Re: [PATCH 06/28] nios2: Memory management
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <1397824031-4892-5-git-send-email-lftan@altera.com> <20140422142443.GB15745@arch.cereza> <20140422151458.GC1053@distanz.ch> <20140422153522.GF15745@arch.cereza>
In-Reply-To: <20140422153522.GF15745@arch.cereza>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Apr 2014 16:01:28.0828 (UTC) FILETIME=[1F0593C0:01CF5E44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/22 下午 11:35, Ezequiel Garcia wrote:
> On Apr 22, Tobias Klauser wrote:
>> On 2014-04-22 at 16:24:43 +0200, Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:
>>> Hi Ley Foon,
>>>
>>> On Apr 18, Ley Foon Tan wrote:
>>>> +/*
>>>> + * PAGE_SHIFT determines the page size
>>>> + */
>>>> +#define PAGE_SHIFT	12
>>>> +#define PAGE_SIZE	4096
>>>> +#define PAGE_MASK	(~(PAGE_SIZE - 1))
>>>> +
>>>
>>> How about something like this:
>>>
>>> /* PAGE_SHIFT determines the page size */
>>> #define PAGE_SHIFT              12
>>> #define PAGE_SIZE               (_AC(1,UL) << PAGE_SHIFT)
>>> #define PAGE_MASK               (~((1 << PAGE_SHIFT) - 1))
>>>
>>> Otherwise, the PAGE_SIZE macro above produces some warnings, IIRC.
>>
>> AFAIR old nios2 GCC versions (the 4.1 version from Windriver, IIRC)
>> would complain about something like the above, that's the reason I added
>> an explicit value for PAGE_SIZE back then.
>>
> 
> Other than being "pretty" the above fix is to remove a mismatch type
> warning. You can get rid of the warning in different ways:
> 
> ifdef __ASSEMBLY__
> define PAGE_SIZE       4096
> else
> define PAGE_SIZE       4096UL
> endif
> 
>> I assume with the new nios2 GCC this should no longer be necessary and
>> Ezequiel's fix should be fine.
> 
> Speaking of GCC... is there a libc available to test this kernel port?
> (which I assume uses the generic syscall ABI)

It's submitted to libc-alpha, also still review in progress.

Chung-Lin



