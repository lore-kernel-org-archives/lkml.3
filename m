Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaFIUBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:01:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:13979 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaFIUBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:01:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352665331"
Message-ID: <539612A8.8080303@intel.com>
Date: Mon, 09 Jun 2014 13:01:44 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] mm/pagewalk: replace mm_walk->skip with more general
 mm_walk->control
References: <1402095520-10109-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1402095520-10109-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1402095520-10109-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 03:58 PM, Naoya Horiguchi wrote:
> +enum mm_walk_control {
> +	PTWALK_NEXT = 0,	/* Go to the next entry in the same level or
> +				 * the next vma. This is default behavior. */
> +	PTWALK_DOWN,		/* Go down to lower level */
> +	PTWALK_BREAK,		/* Break current loop and continue from the
> +				 * next loop */
> +};

I think this is a bad idea.

The page walker should be for the common cases of walking page tables,
and it should be simple.  It *HAS* to be better (shorter/faster) than if
someone was to just open-code a page table walk, or it's not really useful.

The only place this is used is in the ppc walker, and it saves a single
line of code, but requires some comments to explain what is going on:

 arch/powerpc/mm/subpage-prot.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

So, it adds infrastructure, but saves a single line of code.  Seems like
a bad trade off to me. :(
