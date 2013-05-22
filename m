Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3EVNYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:24:52 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:32791 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab3EVNYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:24:50 -0400
MIME-Version: 1.0
In-Reply-To: <1368321816-17719-34-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1368321816-17719-34-git-send-email-kirill.shutemov@linux.intel.com>
Date: Wed, 22 May 2013 21:24:49 +0800
Message-ID: <CAJd=RBAwi6mUv0GqTobfPS7X4kpaRVD_NFg6WvCodkSmy+7uKA@mail.gmail.com>
Subject: Re: [PATCHv4 33/39] thp, mm: implement do_huge_linear_fault()
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
        Dave Hansen <dave@sr71.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 9:23 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>         page = vmf.page;
> +
> +       /*
> +        * If we asked for huge page we expect to get it or VM_FAULT_FALLBACK.
> +        * If we don't ask for huge page it must be splitted in ->fault().
> +        */
> +       BUG_ON(PageTransHuge(page) != thp);
> +
Based on the log message in 34/39(
If the area of page cache required to create huge is empty, we create a
new huge page and return it.), the above trap looks bogus.

	if (thp)
		BUG_ON(!PageTransHuge(page));
