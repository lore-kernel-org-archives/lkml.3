Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaKZMh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:37:58 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:45867 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaKZMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:37:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAPP0e=M9eUkn+riY3E+5fTOkrxH+Btr_arByg+E4ROH+ifcZ1g@mail.gmail.com>
References: <1416683799-678-1-git-send-email-js07.lee@gmail.com>
	<20141125133857.bb2d71659287df6aa908de5b@linux-foundation.org>
	<CAPP0e=M9eUkn+riY3E+5fTOkrxH+Btr_arByg+E4ROH+ifcZ1g@mail.gmail.com>
Date: Wed, 26 Nov 2014 21:37:54 +0900
Message-ID: <CAPP0e=Myz8B9x1pRp3q37wGEwSaACBJfUJPcf6MCzN7K4nG=sg@mail.gmail.com>
Subject: Re: [RFC PATCH] fs/binfmt_elf.c: fix inconsistent vma dump size
From: Jungseung Lee <js07.lee@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 15:51 GMT+09:00 Jungseung Lee <js07.lee@gmail.com>:

>>> @@ -2093,7 +2083,20 @@ static int elf_core_dump(struct coredump_params *cprm)
>>>
>>>       dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
>>>
>>> -     offset += elf_core_vma_data_size(gate_vma, cprm->mm_flags);
>>> +     vma_filesz = kmalloc(sizeof(*vma_filesz) * (segs - 1), GFP_KERNEL);
>>
>> Use kmalloc_array() here, in case a disaster has occurred...
>>
> I'll try to find another way how to pass or save vma size with consistency.
>
it looks like just to replace kmalloc to vmalloc could be solution.
I'll send patch, thanks.
