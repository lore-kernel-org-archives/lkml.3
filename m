Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3CONnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:43:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:47270 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab3CONnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:43:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="302745465"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAJd=RBAEOF7qx1=6vUAA7wYKq6i8efz=Mr9BvUHGxgEE4c6rvg@mail.gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-20-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBD2jWsMOjwXenbHu_Y3-jRm+=XR+h44Tw4KRKEb79ptqg@mail.gmail.com>
 <20130315132911.63716E0085@blue.fi.intel.com>
 <CAJd=RBAEOF7qx1=6vUAA7wYKq6i8efz=Mr9BvUHGxgEE4c6rvg@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 19/30] thp, mm: split huge page on mmap file page
Content-Transfer-Encoding: 7bit
Message-Id: <20130315134528.8BD83E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 15:45:28 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Fri, Mar 15, 2013 at 9:29 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > Hillf Danton wrote:
> >> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
> >> <kirill.shutemov@linux.intel.com> wrote:
> >> >
> >> > We are not ready to mmap file-backed tranparent huge pages.
> >> >
> >> It is not on todo list either.
> >
> > Actually, following patches implement mmap for file-backed thp and this
> > split_huge_page() will catch only fallback cases.
> >
> I wonder if the effort we pay for THP cache is nuked by mmap.

I will not be nuked after patch 30/30.

Actually, it will be splited only if process tries to map hugepage with
unsuitable alignment.

-- 
 Kirill A. Shutemov
