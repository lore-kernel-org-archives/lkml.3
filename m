Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3F1CPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 22:15:09 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38982 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3F1CPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 22:15:06 -0400
Date: Fri, 28 Jun 2013 10:14:54 +0800
From: Shaohua Li <shli@kernel.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, kzak@redhat.com,
        jmoyer@redhat.com, kosaki.motohiro@gmail.com, riel@redhat.com,
        lwoodman@redhat.com, mgorman@suse.de
Subject: Re: [PATCH 01/02] swap: discard while swapping only if
 SWAP_FLAG_DISCARD_PAGES
Message-ID: <20130628021454.GA16423@kernel.org>
References: <cover.1369529143.git.aquini@redhat.com>
 <537407790857e8a5d4db5fb294a909a61be29687.1369529143.git.aquini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537407790857e8a5d4db5fb294a909a61be29687.1369529143.git.aquini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 01:31:55AM -0300, Rafael Aquini wrote:
> This patch introduces SWAP_FLAG_DISCARD_PAGES and SWAP_FLAG_DISCARD_ONCE
> new flags to allow more flexibe swap discard policies being flagged through
> swapon(8). The default behavior is to keep both single-time, or batched, area
> discards (SWAP_FLAG_DISCARD_ONCE) and fine-grained discards for page-clusters
> (SWAP_FLAG_DISCARD_PAGES) enabled, in order to keep consistentcy with older
> kernel behavior, as well as maintain compatibility with older swapon(8).
> However, through the new introduced flags the best suitable discard policy 
> can be selected accordingly to any given swap device constraint.

I'm sorry to response this thread so later. I thought if we just want to
discard the swap partition once at swapon, we really should do it in swapon
tool. The swapon tool can detect the swap device supports discard, any swap
partition is empty at swapon, and we have ioctl to do discard in userspace, so
we have no problem to do discard at the tool. If we don't want to do discard at
all, let the tool handles the option. Kernel is not the place to handle the
complexity.

Thanks,
Shaohua
