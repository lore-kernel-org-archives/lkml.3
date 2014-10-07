Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaJGJFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:05:19 -0400
Received: from mta-out1.inet.fi ([62.71.2.234]:53763 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbaJGJFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:05:15 -0400
Date: Tue, 7 Oct 2014 12:03:07 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH 07/17] mm: madvise MADV_USERFAULT: prepare vm_flags to
 allow more than 32bits
Message-ID: <20141007090307.GA30762@node.dhcp.inet.fi>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-8-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412356087-16115-8-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 07:07:57PM +0200, Andrea Arcangeli wrote:
> We run out of 32bits in vm_flags, noop change for 64bit archs.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  fs/proc/task_mmu.c       | 4 ++--
>  include/linux/huge_mm.h  | 4 ++--
>  include/linux/ksm.h      | 4 ++--
>  include/linux/mm_types.h | 2 +-
>  mm/huge_memory.c         | 2 +-
>  mm/ksm.c                 | 2 +-
>  mm/madvise.c             | 2 +-
>  mm/mremap.c              | 2 +-
>  8 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index c341568..ee1c3a2 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -532,11 +532,11 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>  	/*
>  	 * Don't forget to update Documentation/ on changes.
>  	 */
> -	static const char mnemonics[BITS_PER_LONG][2] = {
> +	static const char mnemonics[BITS_PER_LONG+1][2] = {

I believe here and below should be BITS_PER_LONG_LONG instead: it will
catch unknown vmflags. And +1 is not needed un 64-bit systems.

>  		/*
>  		 * In case if we meet a flag we don't know about.
>  		 */
> -		[0 ... (BITS_PER_LONG-1)] = "??",
> +		[0 ... (BITS_PER_LONG)] = "??",
>  
>  		[ilog2(VM_READ)]	= "rd",
>  		[ilog2(VM_WRITE)]	= "wr",
-- 
 Kirill A. Shutemov
