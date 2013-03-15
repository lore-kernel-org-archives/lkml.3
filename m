Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3COCet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 22:34:49 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38621 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3COCes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 22:34:48 -0400
MIME-Version: 1.0
In-Reply-To: <1363283435-7666-14-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1363283435-7666-14-git-send-email-kirill.shutemov@linux.intel.com>
Date: Fri, 15 Mar 2013 10:34:47 +0800
Message-ID: <CAJd=RBCHLigJBWiBt==wjjm7HA3CYSSyS6odKy0BgoudVxN80g@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 13/30] thp, mm: implement grab_cache_huge_page_write_begin()
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
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +struct page *grab_cache_huge_page_write_begin(struct address_space *mapping,
> +                       pgoff_t index, unsigned flags);
> +#else
> +static inline struct page *grab_cache_huge_page_write_begin(
> +               struct address_space *mapping, pgoff_t index, unsigned flags)
> +{
build bug?

> +       return NULL;
> +}
> +#endif
>
btw, how about grab_thp_write_begin?
