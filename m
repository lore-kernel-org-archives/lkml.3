Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaKZNNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:13:22 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45690 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaKZNNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:13:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141126044306.36e16cad.akpm@linux-foundation.org>
References: <1416683799-678-1-git-send-email-js07.lee@gmail.com>
	<20141125133857.bb2d71659287df6aa908de5b@linux-foundation.org>
	<CAPP0e=M9eUkn+riY3E+5fTOkrxH+Btr_arByg+E4ROH+ifcZ1g@mail.gmail.com>
	<CAPP0e=Myz8B9x1pRp3q37wGEwSaACBJfUJPcf6MCzN7K4nG=sg@mail.gmail.com>
	<20141126044306.36e16cad.akpm@linux-foundation.org>
Date: Wed, 26 Nov 2014 22:13:19 +0900
Message-ID: <CAPP0e=Me42sc7GinmQshoWmsC-g3SthvryaSMVZtGk=3uX=MyA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs/binfmt_elf.c: fix inconsistent vma dump size
From: Jungseung Lee <js07.lee@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 21:43 GMT+09:00 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 26 Nov 2014 21:37:54 +0900 Jungseung Lee <js07.lee@gmail.com> wrote:
>
>> 2014-11-26 15:51 GMT+09:00 Jungseung Lee <js07.lee@gmail.com>:
>>
>> >>> @@ -2093,7 +2083,20 @@ static int elf_core_dump(struct coredump_params *cprm)
>> >>>
>> >>>       dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
>> >>>
>> >>> -     offset += elf_core_vma_data_size(gate_vma, cprm->mm_flags);
>> >>> +     vma_filesz = kmalloc(sizeof(*vma_filesz) * (segs - 1), GFP_KERNEL);
>> >>
>> >> Use kmalloc_array() here, in case a disaster has occurred...
>> >>
>> > I'll try to find another way how to pass or save vma size with consistency.
>> >
>> it looks like just to replace kmalloc to vmalloc could be solution.
>> I'll send patch, thanks.
>
> Solution to what?  I was merely suggesting the use of kmalloc_array()
> instead of open-coded kmalloc(n * m).
>
Ah.. I misunderstood with my poor english. Thanks for the notice to me.
