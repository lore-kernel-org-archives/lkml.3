Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaKEETa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 23:19:30 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:62891 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaKEET3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 23:19:29 -0500
MIME-Version: 1.0
In-Reply-To: <xa1tlhnq7ga7.fsf@mina86.com>
References: <CADtm3G7DtGkvPk36Fiunwen8grw-94V6=iv82iusGumfNJkn-g@mail.gmail.com>
 <xa1tlhnq7ga7.fsf@mina86.com>
From: Gregory Fong <gregory.0xf0@gmail.com>
Date: Tue, 4 Nov 2014 20:18:58 -0800
Message-ID: <CADtm3G7bU6Y2aKco5Vb81KSqsy=FH9zmdDJm=Tixjoep1YeJ7Q@mail.gmail.com>
Subject: Re: CMA alignment question
To: Michal Nazarewicz <mina86@mina86.com>
Cc: linux-mm@kvack.org, Laura Abbott <lauraa@codeaurora.org>,
        iamjoonsoo.kim@lge.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 2:27 PM, Michal Nazarewicz <mina86@mina86.com> wrote:
> On Tue, Nov 04 2014, Gregory Fong wrote:
>> The alignment in cma_alloc() is done w.r.t. the bitmap.  This is a
>> problem when, for example:
>>
>> - a device requires 16M (order 12) alignment
>> - the CMA region is not 16 M aligned
>>
>> In such a case, can result with the CMA region starting at, say,
>> 0x2f800000 but any allocation you make from there will be aligned from
>> there.  Requesting an allocation of 32 M with 16 M alignment, will
>> result in an allocation from 0x2f800000 to 0x31800000, which doesn't
>> work very well if your strange device requires 16M alignment.
>>
>> This doesn't have the behavior I would expect, which would be for the
>> allocation to be aligned w.r.t. the start of memory.  I realize that
>> aligning the CMA region is an option, but don't see why cma_alloc()
>> aligns to the start of the CMA region.  Is there a good reason for
>> having cma_alloc() alignment work this way?
>
> No, it's a bug.  The alignment should indicate alignment of physical
> address not position in CMA region.
>

Ah, now I see that Marek submitted this patch from you back in 2011
that would have allowed the bitmap lib to support an alignment offset:
http://thread.gmane.org/gmane.linux.kernel/1121103/focus=1121100

Any idea why this didn't make it into the later changesets?  If not,
I'll resubmit it and to use it to fix this bug.

Thanks,
Gregory
