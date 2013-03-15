Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab3COCZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 22:25:09 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:37699 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3COCZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 22:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <1363283435-7666-10-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1363283435-7666-10-git-send-email-kirill.shutemov@linux.intel.com>
Date: Fri, 15 Mar 2013 10:25:05 +0800
Message-ID: <CAJd=RBDWGNUvjPBiOmYDOfwbf8ZvyoMDdZn8uhcN0xTNbgKYfA@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 09/30] thp, mm: rewrite delete_from_page_cache() to
 support huge pages
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
> +       if (PageTransHuge(page)) {
> +               int i;
> +
> +               for (i = 0; i < HPAGE_CACHE_NR; i++)
> +                       radix_tree_delete(&mapping->page_tree, page->index + i);

Move the below page_cache_release for tail page here, please.

> +               nr = HPAGE_CACHE_NR;
[...]
> +       if (PageTransHuge(page))
> +               for (i = 1; i < HPAGE_CACHE_NR; i++)
> +                       page_cache_release(page + i);
>         page_cache_release(page);
