Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3KUWjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:39:14 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37533 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3KUWjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:39:11 -0500
MIME-Version: 1.0
In-Reply-To: <528D570D.3020006@oracle.com>
References: <1384976973-32722-1-git-send-email-ddstreet@ieee.org> <528D570D.3020006@oracle.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Thu, 21 Nov 2013 17:38:49 -0500
X-Google-Sender-Auth: T6PV1JT_Mk2pTwCcMj7nutYXuF0
Message-ID: <CALZtONDyXdmzF_K7X+GNA0wY1yDn7k3t1FmQq4J=8=smX9XSoA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: change zswap to writethrough cache
To: Bob Liu <bob.liu@oracle.com>
Cc: Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 7:42 PM, Bob Liu <bob.liu@oracle.com> wrote:
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
>
> Could you do some testing using eg. SPECjbb? And compare the result with
> original zswap.

Sure, I have a small test program that I used for performance
comparisions, which I'll send and include some results, and I'll also
try to find a copy of SPECjbb to get results with.
