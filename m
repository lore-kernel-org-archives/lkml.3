Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaCKTkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:40:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28251 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbaCKTkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:40:07 -0400
Message-ID: <531F6689.60307@oracle.com>
Date: Tue, 11 Mar 2014 15:39:53 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: mm: mmap_sem lock assertion failure in __mlock_vma_pages_range
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've ended up deleting the log file by mistake, but this bug does seem to be important
so I'd rather not wait before the same issue is triggered again.

The call chain is:

	mlock (mm/mlock.c:745)
		__mm_populate (mm/mlock.c:700)
			__mlock_vma_pages_range (mm/mlock.c:229)
				VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));

It seems to be a rather simple trace triggered from userspace. The only recent patch
in the area (that I've noticed) was "mm/mlock: prepare params outside critical region".
I've reverted it and trying to testing without it.


Thanks,
Sasha
