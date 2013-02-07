Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422781Ab3BGXkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:40:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422745Ab3BGXky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:40:54 -0500
Date: Thu, 7 Feb 2013 15:40:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 10/18] mm: teach truncate_inode_pages_range() to
 handle non page aligned ranges
Message-Id: <20130207154042.92430aed.akpm@linux-foundation.org>
In-Reply-To: <1360055531-26309-11-git-send-email-lczerner@redhat.com>
References: <1360055531-26309-1-git-send-email-lczerner@redhat.com>
	<1360055531-26309-11-git-send-email-lczerner@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Feb 2013 10:12:03 +0100
Lukas Czerner <lczerner@redhat.com> wrote:

> This commit changes truncate_inode_pages_range() so it can handle non
> page aligned regions of the truncate. Currently we can hit BUG_ON when
> the end of the range is not page aligned, but we can handle unaligned
> start of the range.
> 
> Being able to handle non page aligned regions of the page can help file
> system punch_hole implementations and save some work, because once we're
> holding the page we might as well deal with it right away.
> 
> In previous commits we've changed ->invalidatepage() prototype to accept
> 'length' argument to be able to specify range to invalidate. No we can
> use that new ability in truncate_inode_pages_range().
> 
> ...
>
> +	/*
> +	 * 'start' and 'end' always covers the range of pages to be fully
> +	 * truncated. Partial pages are covered with 'partial_start' at the
> +	 * start of the range and 'partial_end' at the end of the range.
> +	 * Note that 'end' is exclusive while 'lend' is inclusive.
> +	 */

That helped ;)  So the bytes to be truncated are

(start*PAGE_SIZE + partial_start) -> (end*PAGE_SIZE + partial_end) - 1

yes?


