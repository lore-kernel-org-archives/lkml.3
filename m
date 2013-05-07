Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3EGLiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:38:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab3EGLiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:38:21 -0400
Date: Tue, 7 May 2013 13:38:10 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@us.ibm.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Juan Quintela <quintela@redhat.com>, Hugh Dickins <hughd@google.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 0/4] madvise(MADV_USERFAULT) &
 sys_remap_anon_pages()
Message-ID: <20130507113809.GB10720@hawk.usersys.redhat.com>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 09:56:57PM +0200, Andrea Arcangeli wrote:
> 
> The current behavior of remap_anon_pages is very strict to avoid any
> chance of memory corruption going unnoticed, and it will return
> -EFAULT at the first sign of something unexpected (like a page already
> mapped in the destination pmd/pte, potentially signaling an userland
> thread race condition with two threads userfaulting on the same
> destination address). mremap is not strict like that: it would drop
> the destination range silently and it would succeed in such a
> condition. So on the API side, I wonder if I should add a flag to
> remap_anon_pages to provide non-strict behavior more similar to
> mremap. OTOH not providing the permissive mremap behavior may actually
> be better to force userland to be strict and be sure it knows what it
> is doing (otherwise it should use mremap in the first place?).
> 

What about instead of adding a new syscall (remap_anon_pages) to
instead extend mremap with new flags giving it a strict mode?

drew
