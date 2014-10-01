Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaJAQzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:55:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25319 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaJAQzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:55:42 -0400
Message-ID: <542C31E0.5040909@oracle.com>
Date: Wed, 01 Oct 2014 12:54:56 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
CC: Andres Lagar-Cavilla <andreslc@google.com>, Gleb Natapov <gleb@kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jianyu Zhan <nasa4836@gmail.com>, Paul Cassella <cassella@cray.com>,
        Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH 3/4] mm: gup: use get_user_pages_fast and get_user_pages_unlocked
References: <1412153797-6667-1-git-send-email-aarcange@redhat.com> <1412153797-6667-4-git-send-email-aarcange@redhat.com>
In-Reply-To: <1412153797-6667-4-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

On 10/01/2014 04:56 AM, Andrea Arcangeli wrote:
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 8f5330d..6606c10 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -881,7 +881,7 @@ static int lookup_node(struct mm_struct *mm, unsigned long addr)
>  	struct page *p;
>  	int err;
>  
> -	err = get_user_pages(current, mm, addr & PAGE_MASK, 1, 0, 0, &p, NULL);
> +	err = get_user_pages_fast(addr & PAGE_MASK, 1, 0, &p);
>  	if (err >= 0) {
>  		err = page_to_nid(p);
>  		put_page(p);

This change looks bogus. mmap_sem might get locked in do_get_mempolicy(), and with this
change we'll try locking it again in get_user_pages_fast.


Thanks,
Sasha
