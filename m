Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaJWXt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:49:58 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:36737 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaJWXt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <54498FE8.4010700@lge.com>
References: <1414068740-9553-1-git-send-email-gioh.kim@lge.com>
	<1414068740-9553-2-git-send-email-gioh.kim@lge.com>
	<CAOFgiypyxykRPpYn7dAXnnDHhCR-MwRnNT46BdwS28TKobnxuw@mail.gmail.com>
	<54498C68.8090207@lge.com>
	<54498FE8.4010700@lge.com>
Date: Fri, 24 Oct 2014 05:19:56 +0530
Message-ID: <CAOFgiyqm48tHcwmr0SP2ERXp5QW22tx-U0PxvZtyeasF-DmgZw@mail.gmail.com>
Subject: Re: [RFC 1/2] staging: ion: shrink page-pool by page unit
From: Devendra Naga <devendranaga4@gmail.com>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 5:01 AM, Gioh Kim <gioh.kim@lge.com> wrote:
>
>
> 2014-10-24 오전 8:16, Gioh Kim 쓴 글:
>
>>
>>
>> 2014-10-24 오전 5:36, Devendra Naga 쓴 글:
>>>
>>> Hello,
>>>
>>> On Thu, Oct 23, 2014 at 6:22 PM, Gioh Kim <gioh.kim@lge.com> wrote:
>>>>          sys_heap = container_of(heap, struct ion_system_heap, heap);
>>>> @@ -219,7 +219,10 @@ static int ion_system_heap_shrink(struct ion_heap
>>>> *heap, gfp_t gfp_mask,
>>>>          for (i = 0; i < num_orders; i++) {
>>>>                  struct ion_page_pool *pool = sys_heap->pools[i];
>>>>
>>>> -               nr_total += ion_page_pool_shrink(pool, gfp_mask,
>>>> nr_to_scan);
>>>> +               nr_freed += ion_page_pool_shrink(pool, gfp_mask,
>>>> nr_to_scan);
>>>
>>>
>>> nr_freed is not initialised to zero. This might result in updating of
>>> a garbage value stored initially after nr_freed is created.
>>
>>
>> Yes, your're right. It's my mistake.
>> I testes this on my platform with custom kernel and copied codes.
>> I missed a line for it.
>> I'm sorry.
>
>
> Following is the correct code:
> nr_freed = ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);
>

Thanks that is correct. You can send another patch with this fix (it
can be patchset v2 or rfc v2).

>
>>
>>>
>>>> +               nr_total += nr_freed;
>>>> +               /* nr_to_scan can be negative */
>>>> +               nr_to_scan -= nr_freed;
>>>>          }
>>>>
>>>>          return nr_total;
>>>> --
>>>> 1.7.9.5
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>
