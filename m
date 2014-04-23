Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaDWCvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:51:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58235 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbaDWCvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:51:45 -0400
Message-ID: <53572AAA.4070207@zytor.com>
Date: Tue, 22 Apr 2014 19:51:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Why do we set _PAGE_DIRTY for page tables?
References: <5356FCC1.6060807@zytor.com> <CA+55aFwsPs12_57YEBHdb4ti1BXSuDX_RPSf6S4JSRLGK_2X7Q@mail.gmail.com>
In-Reply-To: <CA+55aFwsPs12_57YEBHdb4ti1BXSuDX_RPSf6S4JSRLGK_2X7Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 07:48 PM, Linus Torvalds wrote:
> On Tue, Apr 22, 2014 at 4:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I just noticed this:
>>
>> #define _PAGE_TABLE     (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |       \
>>                          _PAGE_ACCESSED | _PAGE_DIRTY)
>> #define _KERNPG_TABLE   (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |   \
>>                          _PAGE_DIRTY)
>>
>> Is there a reason we set _PAGE_DIRTY for page tables?  It has no
>> function, but doesn't do any harm either (the dirty bit is ignored for
>> page tables)... it just looks funny to me.
> 
> I think it just got copied, and at least the A bit does matter even in
> page tables (well, it gets updated, I don't know how much that
> "matters"). So the fact that D is ignored is actually the odd man out.
> 

Yes, not setting the A bit means the hardware will take an assist to set
the bit for us, which is a waste of time if we don't care about it.  The
D bit is the one which made me wonder; I thought either it was just copy
& paste, or that it got set to make it more analogous with large pages.

	-hpa


