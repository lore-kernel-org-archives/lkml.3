Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaHRAGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 20:06:10 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55678 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaHRAGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 20:06:08 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 18 Aug 2014 09:06:30 +0900
From: Minchan Kim <minchan@kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH v14 5/8] s390: add pmd_[dirty|mkclean] for THP
Message-ID: <20140818000630.GA32075@bbox>
References: <1407981212-17818-1-git-send-email-minchan@kernel.org>
 <1407981212-17818-6-git-send-email-minchan@kernel.org>
 <20140814091614.4a0d5178@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140814091614.4a0d5178@mschwide>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 14, 2014 at 09:16:14AM +0200, Martin Schwidefsky wrote:
> On Thu, 14 Aug 2014 10:53:29 +0900
> Minchan Kim <minchan@kernel.org> wrote:
> 
> > MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
> > overwrite of the contents since MADV_FREE syscall is called for
> > THP page but for s390 pmds only referenced bit is available
> > because there is no free bit left in the pmd entry for the
> > software dirty bit so this patch adds dumb pmd_dirty which
> > returns always true by suggesting by Martin.
> > 
> > They finally find a solution in future.
> > http://marc.info/?l=linux-api&m=140440328820808&w=2
> 
> The solution is already there, see git commit 152125b7a882df36.
> You can drop this patch.

Thanks for the heads up. I will drop it in next spin.
> 
> -- 
> blue skies,
>    Martin.
> 
> "Reality continues to ruin my life." - Calvin.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
