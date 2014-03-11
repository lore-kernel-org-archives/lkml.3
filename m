Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaCKUgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:36:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23792 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbaCKUgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:36:08 -0400
Message-ID: <531F73AB.5060402@oracle.com>
Date: Tue, 11 Mar 2014 16:35:55 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: mmap_sem lock assertion failure in __mlock_vma_pages_range
References: <531F6689.60307@oracle.com>	<1394568453.2786.28.camel@buesod1.americas.hpqcorp.net> <20140311133051.bf5ca716ef189746ebcff431@linux-foundation.org>
In-Reply-To: <20140311133051.bf5ca716ef189746ebcff431@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 04:30 PM, Andrew Morton wrote:
> I worry about what happens if __get_user_pages decides to do
>
> 				if (ret & VM_FAULT_RETRY) {
> 					if (nonblocking)
> 						*nonblocking = 0;
> 					return i;
> 				}
>
> uh-oh, that just cleared __mm_populate()'s `locked' variable and we'll
> forget to undo mmap_sem.  That won't explain this result, but it's a
> potential problem.

That's actually seems right because if 'ret & VM_FAULT_RETRY' is true it means that
lock_page_or_retry() was supposed to release mmap_sem for us.


Thanks,
Sasha
