Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbaCKV7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:59:53 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53027 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbaCKV7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>
References: <531F6689.60307@oracle.com>
	<1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>
Date: Tue, 11 Mar 2014 14:59:47 -0700
Message-ID: <CANN689G2Mv+1zr0MgF17uA2GwKaCcEp-ckE=j5YzXHBxjP0tLA@mail.gmail.com>
Subject: Re: mm: mmap_sem lock assertion failure in __mlock_vma_pages_range
From: Michel Lespinasse <walken@google.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 1:07 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Tue, 2014-03-11 at 15:39 -0400, Sasha Levin wrote:

>> I've ended up deleting the log file by mistake, but this bug does seem to be important
>> so I'd rather not wait before the same issue is triggered again.
>>
>> The call chain is:
>>
>>       mlock (mm/mlock.c:745)
>>               __mm_populate (mm/mlock.c:700)
>>                       __mlock_vma_pages_range (mm/mlock.c:229)
>>                               VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
>
> So __mm_populate() is only called by mlock(2) and this VM_BUG_ON seems
> wrong as we call it without the lock held:

Not related to the bug, but please note that __mm_populate() is public
and has other call sites outside of mlock.c - namely, it is called
during mmap with MAP_POPULATE.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
