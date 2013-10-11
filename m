Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab3JKOI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:08:56 -0400
Received: from a14-6.smtp-out.amazonses.com ([54.240.14.6]:59998 "EHLO
	a14-6.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013Ab3JKOIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:08:55 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2013 10:08:54 EDT
Date: Fri, 11 Oct 2013 14:01:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 34/34] mm: dynamically allocate page->ptl if it cannot
 be embedded to struct page
In-Reply-To: <20131010200921.91D84E0090@blue.fi.intel.com>
Message-ID: <00000141a7d2aa7b-e59f292a-746c-4f55-aa51-9fa060a7fbeb-000000@email.amazonses.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com> <1381428359-14843-35-git-send-email-kirill.shutemov@linux.intel.com> <00000141a3f48ada-37ee9c14-2f2b-40a2-93f4-70258363351b-000000@email.amazonses.com>
 <20131010200921.91D84E0090@blue.fi.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.11-54.240.14.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013, Kirill A. Shutemov wrote:

> Christoph Lameter wrote:
> > On Thu, 10 Oct 2013, Kirill A. Shutemov wrote:
> >
> > > +static inline bool ptlock_alloc(struct page *page)
> > > +{
> > > +	if (sizeof(spinlock_t) > sizeof(page->ptl))
> > > +		return __ptlock_alloc(page);
> > > +	return true;
> > > +}
> >
> > Could you make the check a CONFIG option? CONFIG_PTLOCK_DOES_NOT_FIT_IN_PAGE_STRUCT or
> > so?
>
> No. We will have to track what affects sizeof(spinlock_t) manually.
> Not a fun and error prune.

You can generate a config option depending on the size of the object via
Kbuild. Kbuild will determine the setting before building the kernel as a
whole by runing some small C program.

