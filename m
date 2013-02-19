Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab3BSKzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:55:16 -0500
Received: from mail-gh0-f173.google.com ([209.85.160.173]:65113 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3BSKzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:55:12 -0500
Message-ID: <512354C4.2040705@gmail.com>
Date: Tue, 19 Feb 2013 18:32:36 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: PAGE_CACHE_SIZE vs. PAGE_SIZE
References: <20130118155724.GA8507@otc-wbsnb-06>
In-Reply-To: <20130118155724.GA8507@otc-wbsnb-06>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 11:57 PM, Kirill A. Shutemov wrote:
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

IIRC, you try to implement THP support page cache, then PAGE_CACHE_SIZE 
maybe don't need any more.

>
> Is it time to get rid of PAGE_CACHE_* macros?
> I can prepare patchset if it's okay.
>

