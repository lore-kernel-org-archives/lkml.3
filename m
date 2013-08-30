Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3H3DmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:42:14 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39376 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3H3DmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:42:13 -0400
MIME-Version: 1.0
In-Reply-To: <521fdad0.e8a4420a.5b3b.ffff8bd3SMTPIN_ADDED_BROKEN@mx.google.com>
References: <521faf12.9JwU9Jt+2QNWkPCZ%akpm@linux-foundation.org>
	<CAE9FiQWHeip7XWF+-mCt3gXsESpr52Fb71fbrJbRSJyeHCAMeQ@mail.gmail.com>
	<521fdad0.e8a4420a.5b3b.ffff8bd3SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Thu, 29 Aug 2013 20:42:12 -0700
X-Google-Sender-Auth: 75HbuxSwtKcsRUV9syxxY-P92vg
Message-ID: <CAE9FiQVFJvaTGTejvs9Bd9akCj5pX-TT9eKy9bB5CDZ4d0iQbw@mail.gmail.com>
Subject: Re: + mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch added
 to -mm tree
From: Yinghai Lu <yinghai@kernel.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 4:35 PM, Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:

> On Thu, Aug 29, 2013 at 01:44:18PM -0700, Yinghai Lu wrote:
>>>  mm/sparse.c |   41 +++++++++++++++--------------------------
>>>  1 file changed, 15 insertions(+), 26 deletions(-)
>>>
>>> diff -puN mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap-fix-2 mm/sparse.c
>>> --- a/mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap-fix-2
>>> +++ a/mm/sparse.c
>>> @@ -339,13 +339,14 @@ static void __init check_usemap_section_
>>>  }
>>>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>>>
>>> -static void __init sparse_early_usemaps_alloc_node(unsigned long**usemap_map,
>>> +static void __init sparse_early_usemaps_alloc_node(void **data,
>>>                                  unsigned long pnum_begin,
>>>                                  unsigned long pnum_end,
>>>                                  unsigned long usemap_count, int nodeid)
>>>  {
>>>         void *usemap;
>>>         unsigned long pnum;
>>> +       unsigned long **usemap_map = (unsigned long **)data;
>>
>>Can you check if (void *data) will work?
>>
>>void ** looks strange.
>
> The original patch you give me has (void *data), however, there is compile warning.
>
> mm/sparse.c: In function  $B!F (Bsparse_init $B!G (B: mm/sparse.c:552:8: warning: passing argument 1 of  $B!F (Balloc_usemap_and_memmap $B!G (B
> from incompatible pointer type [enabled by default]
> mm/sparse.c:469:20: note: expected  $B!F (Bvoid (*)(void **, long unsigned int, long unsigned int,  long unsigned int,  int) $B!G (B
> but argument is of type  $B!F (Bvoid (*)(void *, long unsigned int,  long unsigned int,  long unsigned int,  int) $B!G (B
>
> The void ** fix it. ;-)

should change both to void *

Yinghai
