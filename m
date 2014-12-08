Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaLHLsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:48:50 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:41567 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbaLHLst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:48:49 -0500
Date: Mon, 8 Dec 2014 13:46:01 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>
Subject: Re: [RFC V4] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
Message-ID: <20141208114601.GA28846@node.dhcp.inet.fi>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
 <CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
 <20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
 <35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:00:50AM +0800, Wang, Yalin wrote:
> This patch add KPF_ZERO_PAGE flag for zero_page,
> so that userspace process can notice zero_page from
> /proc/kpageflags, and then do memory analysis more accurately.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---
>  Documentation/vm/pagemap.txt           |  5 +++++
>  fs/proc/page.c                         | 16 +++++++++++++---
>  include/linux/huge_mm.h                | 12 ++++++++++++
>  include/uapi/linux/kernel-page-flags.h |  1 +
>  mm/huge_memory.c                       |  7 +------
>  5 files changed, 32 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
> index 5948e45..fdeb06e 100644
> --- a/Documentation/vm/pagemap.txt
> +++ b/Documentation/vm/pagemap.txt
> @@ -62,6 +62,8 @@ There are three components to pagemap:
>      20. NOPAGE
>      21. KSM
>      22. THP
> +    23. BALLOON
> +    24. ZERO_PAGE
>  
>  Short descriptions to the page flags:
>  
> @@ -102,6 +104,9 @@ Short descriptions to the page flags:
>  22. THP
>      contiguous pages which construct transparent hugepages
>  
> +24. ZERO_PAGE
> +    zero page for pfn_zero or huge_zero page
> +
>      [IO related page flags]
>   1. ERROR     IO error occurred
>   3. UPTODATE  page has up-to-date data

Would be nice to document BALLOON while you're there.
Otherwise looks good to me.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
