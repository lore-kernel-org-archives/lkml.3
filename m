Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3H0D2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:28:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab3H0D2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:28:36 -0400
Date: Mon, 26 Aug 2013 23:28:16 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        gong.chen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1377574096-y8hxgzdw-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1377571171-9958-3-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377571171-9958-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1377571171-9958-3-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/3] mm/hwpoison: fix return value of madvise_hwpoison
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1377571171-9958-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 10:39:31AM +0800, Wanpeng Li wrote:
> The return value outside for loop is always zero which means madvise_hwpoison 
> return success, however, this is not truth for soft_offline_page w/ failure
> return value.

I don't understand what you want to do for what reason. Could you clarify
those?

> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/madvise.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index a20764c..19b71e4 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -359,7 +359,7 @@ static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
>  				page_to_pfn(p), start);
>  			ret = soft_offline_page(p, MF_COUNT_INCREASED);
>  			if (ret)
> -				break;
> +				return ret;
>  			continue;
>  		}
>  		pr_info("Injecting memory failure for page %#lx at %#lx\n",

This seems to introduce no behavioral change.

Thanks,
Naoya Horiguchi
