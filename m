Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaHNHQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:16:28 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:52633 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaHNHQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:16:26 -0400
Date: Thu, 14 Aug 2014 09:16:14 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Minchan Kim <minchan@kernel.org>
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
Message-ID: <20140814091614.4a0d5178@mschwide>
In-Reply-To: <1407981212-17818-6-git-send-email-minchan@kernel.org>
References: <1407981212-17818-1-git-send-email-minchan@kernel.org>
	<1407981212-17818-6-git-send-email-minchan@kernel.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081407-1948-0000-0000-000000CFC15F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014 10:53:29 +0900
Minchan Kim <minchan@kernel.org> wrote:

> MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
> overwrite of the contents since MADV_FREE syscall is called for
> THP page but for s390 pmds only referenced bit is available
> because there is no free bit left in the pmd entry for the
> software dirty bit so this patch adds dumb pmd_dirty which
> returns always true by suggesting by Martin.
> 
> They finally find a solution in future.
> http://marc.info/?l=linux-api&m=140440328820808&w=2

The solution is already there, see git commit 152125b7a882df36.
You can drop this patch.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

