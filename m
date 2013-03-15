Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3COGPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:15:14 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:47505 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3COGPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:15:12 -0400
MIME-Version: 1.0
In-Reply-To: <1363283435-7666-17-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1363283435-7666-17-git-send-email-kirill.shutemov@linux.intel.com>
Date: Fri, 15 Mar 2013 14:15:11 +0800
Message-ID: <CAJd=RBCxNgjUUSbbTnVymC7+O51LKDuKTyTkEGYwuWYB9_oUmw@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 16/30] thp: handle file pages in split_huge_page()
From: Hillf Danton <dhillf@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> -int split_huge_page(struct page *page)
> +static int split_anon_huge_page(struct page *page)
>  {
>         struct anon_vma *anon_vma;
>         int ret = 1;
>
> -       BUG_ON(is_huge_zero_pfn(page_to_pfn(page)));
> -       BUG_ON(!PageAnon(page));
> -
deleted, why?
