Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaGGPby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:31:54 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:33835 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaGGPbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:31:52 -0400
Date: Mon, 7 Jul 2014 17:31:43 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v10 5/7] s390: add pmd_[dirty|mkclean] for THP
Message-ID: <20140707173143.271bbd52@thinkpad>
In-Reply-To: <1404694438-10272-6-git-send-email-minchan@kernel.org>
References: <1404694438-10272-1-git-send-email-minchan@kernel.org>
	<1404694438-10272-6-git-send-email-minchan@kernel.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070715-4966-0000-0000-000000A3219E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Jul 2014 09:53:56 +0900
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
> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  arch/s390/include/asm/pgtable.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

