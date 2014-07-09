Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaGIWfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:35:23 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:48649 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaGIWfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:35:22 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:8cce:4220:32bc:b297]
In-Reply-To: <20140703181059.GJ17372@arm.com>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
	<1404324218-4743-2-git-send-email-lauraa@codeaurora.org>
	<20140703181059.GJ17372@arm.com>
Date: Wed, 9 Jul 2014 15:35:21 -0700
Message-ID: <CAOesGMjBMgutN6EDv=CeY=iM8zV=ti69_iyL=t5-HTD+pbCjzw@mail.gmail.com>
Subject: Re: [PATCHv4 1/5] lib/genalloc.c: Add power aligned algorithm
From: Olof Johansson <olof@lixom.net>
To: Will Deacon <will.deacon@arm.com>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 11:10 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Jul 02, 2014 at 07:03:34PM +0100, Laura Abbott wrote:
>>
>> One of the more common algorithms used for allocation
>> is to align the start address of the allocation to
>> the order of size requested. Add this as an algorithm
>> option for genalloc.
>>
>> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
>> ---
>>  include/linux/genalloc.h |  4 ++++
>>  lib/genalloc.c           | 20 ++++++++++++++++++++
>>  2 files changed, 24 insertions(+)
>>
>> diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
>> index 1c2fdaa..3cd0934 100644
>> --- a/include/linux/genalloc.h
>> +++ b/include/linux/genalloc.h
>> @@ -110,6 +110,10 @@ extern void gen_pool_set_algo(struct gen_pool *pool, genpool_algo_t algo,
>>  extern unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
>>               unsigned long start, unsigned int nr, void *data);
>>
>> +extern unsigned long gen_pool_first_fit_order_align(unsigned long *map,
>> +             unsigned long size, unsigned long start, unsigned int nr,
>> +             void *data);
>> +
>
> You could also update gen_pool_first_fit to call this new function instead.

+1, that'd be slightly nicer and remove one exported symbol.

But, as Will says, up to you. Either option:

Acked-by: Olof Johansson <olof@lixom.net>
