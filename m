Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3KUDuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 22:50:51 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:37003 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3KUDus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 22:50:48 -0500
MIME-Version: 1.0
In-Reply-To: <528D570D.3020006@oracle.com>
References: <1384976973-32722-1-git-send-email-ddstreet@ieee.org>
	<528D570D.3020006@oracle.com>
Date: Thu, 21 Nov 2013 11:50:47 +0800
Message-ID: <CAL1ERfNr+J5gT-s1Qe+RVmNz+CenNFOzAWi86MNCt2ZGLB4ZCA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: change zswap to writethrough cache
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Bob Liu <bob.liu@oracle.com>
Cc: Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan,

On Thu, Nov 21, 2013 at 8:42 AM, Bob Liu <bob.liu@oracle.com> wrote:
> Hi Dan,
>
> On 11/21/2013 03:49 AM, Dan Streetman wrote:
>> Currently, zswap is writeback cache; stored pages are not sent
>> to swap disk, and when zswap wants to evict old pages it must
>> first write them back to swap cache/disk manually.  This avoids
>> swap out disk I/O up front, but only moves that disk I/O to
>> the writeback case (for pages that are evicted), and adds the
>> overhead of having to uncompress the evicted pages, and adds the
>> need for an additional free page (to store the uncompressed page)
>> at a time of likely high memory pressure.  Additionally, being
>> writeback adds complexity to zswap by having to perform the
>> writeback on page eviction.
>>
>
> Good work!
>
>> This changes zswap to writethrough cache by enabling
>> frontswap_writethrough() before registering, so that any
>> successful page store will also be written to swap disk.  All the
>> writeback code is removed since it is no longer needed, and the
>> only operation during a page eviction is now to remove the entry
>> from the tree and free it.
>>

Thanks for your work. I reviewed this patch, and it is good to me.

However, I am skeptical about it because:
1. it will add more IO than original zswap, how does it result in a
performance improvement ?
2. most embedded device use NAND, more IO will reduce its working life

Regards

> Could you do some testing using eg. SPECjbb? And compare the result with
> original zswap.
>
> Thanks,
> -Bob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
