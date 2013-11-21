Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3KUAnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:43:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21761 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3KUAnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:43:08 -0500
Message-ID: <528D570D.3020006@oracle.com>
Date: Thu, 21 Nov 2013 08:42:53 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dan Streetman <ddstreet@ieee.org>
CC: Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Subject: Re: [PATCH v2] mm/zswap: change zswap to writethrough cache
References: <1384976973-32722-1-git-send-email-ddstreet@ieee.org>
In-Reply-To: <1384976973-32722-1-git-send-email-ddstreet@ieee.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On 11/21/2013 03:49 AM, Dan Streetman wrote:
> Currently, zswap is writeback cache; stored pages are not sent
> to swap disk, and when zswap wants to evict old pages it must
> first write them back to swap cache/disk manually.  This avoids
> swap out disk I/O up front, but only moves that disk I/O to
> the writeback case (for pages that are evicted), and adds the
> overhead of having to uncompress the evicted pages, and adds the
> need for an additional free page (to store the uncompressed page)
> at a time of likely high memory pressure.  Additionally, being
> writeback adds complexity to zswap by having to perform the
> writeback on page eviction.
> 

Good work!

> This changes zswap to writethrough cache by enabling
> frontswap_writethrough() before registering, so that any
> successful page store will also be written to swap disk.  All the
> writeback code is removed since it is no longer needed, and the
> only operation during a page eviction is now to remove the entry
> from the tree and free it.
> 

Could you do some testing using eg. SPECjbb? And compare the result with
original zswap.

Thanks,
-Bob
