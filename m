Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab3EWL50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:57:26 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45058 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab3EWL5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <1368321816-17719-38-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1368321816-17719-38-git-send-email-kirill.shutemov@linux.intel.com>
Date: Thu, 23 May 2013 19:57:24 +0800
Message-ID: <CAJd=RBA64hW7x6u0Mou4_z_Ox3J+sC3ZL+a4h8XcTHbXZicALg@mail.gmail.com>
Subject: Re: [PATCHv4 37/39] thp: handle write-protect exception to
 file-backed huge pages
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
> @@ -1120,7 +1119,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>
>         page = pmd_page(orig_pmd);
>         VM_BUG_ON(!PageCompound(page) || !PageHead(page));
> -       if (page_mapcount(page) == 1) {
> +       if (PageAnon(page) && page_mapcount(page) == 1) {

Could we avoid copying huge page if
no-one else is using it, no matter anon?

>                 pmd_t entry;
>                 entry = pmd_mkyoung(orig_pmd);
>                 entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
