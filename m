Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3AaWka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:40:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3AaWk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:40:27 -0500
Date: Thu, 31 Jan 2013 14:40:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: PAGE_CACHE_SIZE vs. PAGE_SIZE
Message-Id: <20130131144026.bd735c07.akpm@linux-foundation.org>
In-Reply-To: <20130118155724.GA8507@otc-wbsnb-06>
References: <20130118155724.GA8507@otc-wbsnb-06>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013 17:57:25 +0200
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> Hi,
> 
> PAGE_CACHE_* macros were introduced long time ago in hope to implement
> page cache with larger chunks than one page in future.
> 
> In fact it was never done.
> 
> Some code paths assume PAGE_CACHE_SIZE <= PAGE_SIZE. E.g. we use
> zero_user_segments() to clear stale parts of page on cache filling, but
> the function is implemented only for individual small page.
> 
> It's unlikely that global switch to PAGE_CACHE_SIZE > PAGE_SIZE will never
> happen since it will affect to much code at once.
> 
> I think support of larger chunks in page cache can be in implemented in
> some form of THP with per-fs enabling.
> 
> Is it time to get rid of PAGE_CACHE_* macros?
> I can prepare patchset if it's okay.

The distinct PAGE_CACHE_SIZE has never been used for anything, but I do
kinda like it for documentary reasons: PAGE_SIZE is a raw, low-level
thing and PAGE_CACHE_SIZE is the specialized
we're-doing-pagecache-stuff thing.

But I'm sure I could get used to not having it ;)
