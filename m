Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbaCEEKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:10:31 -0500
Received: from ozlabs.org ([203.10.76.45]:52000 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300AbaCEEKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:10:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm: introduce vm_ops->map_pages()
In-Reply-To: <20140303151611.5671eebb74cedb99aa5396c8@linux-foundation.org>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com> <1393530827-25450-2-git-send-email-kirill.shutemov@linux.intel.com> <20140303151611.5671eebb74cedb99aa5396c8@linux-foundation.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 05 Mar 2014 10:34:15 +1030
Message-ID: <8761nt1pfk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> On Thu, 27 Feb 2014 21:53:46 +0200 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
>> +
>> +void do_set_pte(struct vm_area_struct *vma, unsigned long address,
>> +		struct page *page, pte_t *pte, bool write, bool anon);
>>  #endif
>>  
>>  /*
>
> lguest made a dubious naming decision:
>
> drivers/lguest/page_tables.c:890: error: conflicting types for 'do_set_pte'
> include/linux/mm.h:593: note: previous declaration of 'do_set_pte' was here
>
> I'll rename lguest's do_set_pte() to do_guest_set_pte() as a
> preparatory patch.

s/do_/ if you don't mind; if we're going to prefix it, we don't need the
extra verb.

Thanks,
Rusty.
