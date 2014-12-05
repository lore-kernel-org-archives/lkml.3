Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaLEIc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:32:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaLEIcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:32:54 -0500
Date: Fri, 5 Dec 2014 09:32:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        zhangyanfei@cn.fujitsu.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v17 1/7] mm: support madvise(MADV_FREE)
Message-ID: <20141205083249.GA2321@dhcp22.suse.cz>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
 <1413799924-17946-2-git-send-email-minchan@kernel.org>
 <20141127144725.GB19157@dhcp22.suse.cz>
 <20141130235652.GA10333@bbox>
 <20141202100125.GD27014@dhcp22.suse.cz>
 <20141203000026.GA30217@bbox>
 <20141203101329.GB23236@dhcp22.suse.cz>
 <20141205070816.GB3358@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205070816.GB3358@bbox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 05-12-14 16:08:16, Minchan Kim wrote:
[...]
> From cfa212d4fb307ae772b08cf564cab7e6adb8f4fc Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Mon, 1 Dec 2014 08:53:55 +0900
> Subject: [PATCH] madvise.2: Document MADV_FREE
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> ---
>  man2/madvise.2 | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/man2/madvise.2 b/man2/madvise.2
> index 032ead7..fc1aaca 100644
> --- a/man2/madvise.2
> +++ b/man2/madvise.2
> @@ -265,6 +265,18 @@ file (see
>  .BR MADV_DODUMP " (since Linux 3.4)"
>  Undo the effect of an earlier
>  .BR MADV_DONTDUMP .
> +.TP
> +.BR MADV_FREE " (since Linux 3.19)"
> +Tell the kernel that contents in the specified address range are no
> +longer important and the range will be overwritten. When there is
> +demand for memory, the system will free pages associated with the
> +specified address range. In this instance, the next time a page in the
> +address range is referenced, it will contain all zeroes.  Otherwise,
> +it will contain the data that was there prior to the MADV_FREE call.
> +References made to the address range will not make the system read
> +from backing store (swap space) until the page is modified again.
> +It works only with private anonymous pages (see
> +.BR mmap (2)).
>  .SH RETURN VALUE
>  On success
>  .BR madvise ()
> -- 
> 2.0.0
> 
> -- 
> Kind regards,
> Minchan Kim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
