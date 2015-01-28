Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbbA1Bf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:35:56 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:56661 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760002AbbA1Bfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:35:53 -0500
MIME-Version: 1.0
In-Reply-To: <54C7F180.1030505@oracle.com>
References: <1422282365-20015-1-git-send-email-sasha.levin@oracle.com>
	<1422282365-20015-4-git-send-email-sasha.levin@oracle.com>
	<20150127081012.GD11358@js1304-P5Q-DELUXE>
	<54C7D801.3070502@oracle.com>
	<54C7F180.1030505@oracle.com>
Date: Wed, 28 Jan 2015 10:35:52 +0900
Message-ID: <CAAmzW4PEMWh_dtbtbcNEn9eW6ucz-1Frt+yOgwQ=GfbyXMYONw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: cma: release trigger
From: Joonsoo Kim <js1304@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laura Abbott <lauraa@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-28 5:13 GMT+09:00 Sasha Levin <sasha.levin@oracle.com>:
> On 01/27/2015 01:25 PM, Sasha Levin wrote:
>> On 01/27/2015 03:10 AM, Joonsoo Kim wrote:
>>>> >> +                if (mem->n <= count) {
>>>>> >> > +                     cma_release(cma, mem->p, mem->n);
>>>>> >> > +                     count -= mem->n;
>>>>> >> > +                     kfree(mem);
>>>>> >> > +             } else {
>>>>> >> > +                     cma_release(cma, mem->p, count);
>>>>> >> > +                     mem->p += count;
>>>>> >> > +                     mem->n -= count;
>>>>> >> > +                     count = 0;
>>>>> >> > +                     cma_add_to_cma_mem_list(mem);
>>>>> >> > +             }
>>>>> >> > +     }
>>> > If order_per_bit is not 0 and count used in cma_release() is
>>> > different with the count used in cma_alloc(), problem could
>>> > occur since bitmap management code can't handle that situation.
>>> >
>>> > Could we just disable this case in this testing module?
>> How should it behave then? Just free a max of 'count' pages and
>> stop beforehand if we're going to go over it?
>
> Actually, Can I just check for order_per_bit == 0 and execute it
> then? I don't want to avoid testing these paths.

Okay. I'm okay if you check order_per_bit == 0 in such case.

Thanks.
