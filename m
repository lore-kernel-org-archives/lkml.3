Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3CODLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:11:34 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48297 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3CODLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:11:32 -0400
MIME-Version: 1.0
In-Reply-To: <1363283435-7666-15-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1363283435-7666-15-git-send-email-kirill.shutemov@linux.intel.com>
Date: Fri, 15 Mar 2013 11:11:32 +0800
Message-ID: <CAJd=RBA-CRVu2is9=9E1Y0=HFRHs1TXvFvm2wF7gT+=ujQ+8tg@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 14/30] thp, mm: naive support of thp in generic
 read/write routines
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
> +               if (PageTransTail(page)) {
> +                       page_cache_release(page);
> +                       page = find_get_page(mapping,
> +                                       index & ~HPAGE_CACHE_INDEX_MASK);
check page is valid, please.

> +                       if (!PageTransHuge(page)) {
> +                               page_cache_release(page);
> +                               goto find_page;
> +                       }
> +               }
