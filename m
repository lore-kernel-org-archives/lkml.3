Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab3EVLh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:37:27 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41849 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab3EVLhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:37:22 -0400
MIME-Version: 1.0
In-Reply-To: <1368321816-17719-35-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1368321816-17719-35-git-send-email-kirill.shutemov@linux.intel.com>
Date: Wed, 22 May 2013 19:37:22 +0800
Message-ID: <CAJd=RBDChGT0i_fsnqW7RvQkJhQaTv7k+=HNTzjx7Rg+6uTNPA@mail.gmail.com>
Subject: Re: [PATCHv4 34/39] thp, mm: handle huge pages in filemap_fault()
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
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> If caller asks for huge page (flags & FAULT_FLAG_TRANSHUGE),
> filemap_fault() return it if there's a huge page already by the offset.
>
> If the area of page cache required to create huge is empty, we create a
> new huge page and return it.
>
> Otherwise we return VM_FAULT_FALLBACK to indicate that fallback to small
> pages is required.
>
s/small/regular/g ?
