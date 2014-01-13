Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaAMRDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:03:30 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:60703 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbaAMRD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:03:26 -0500
MIME-Version: 1.0
In-Reply-To: <20140103151154.GA2940@cerebellum.variantweb.net>
References: <1387459407-29342-1-git-send-email-ddstreet@ieee.org> <20140103151154.GA2940@cerebellum.variantweb.net>
From: Dan Streetman <ddstreet@ieee.org>
Date: Mon, 13 Jan 2014 12:03:05 -0500
X-Google-Sender-Auth: ugTAVmBu-Gm_Amt7IpKFpdyqESw
Message-ID: <CALZtONB30aBBY=jPJmXJN9gfSwv8Q4i5=VPpa457TtvSEg4yXQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: add writethrough option
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Linux-MM <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        Shirish Pargaonkar <spargaonkar@suse.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping to see if this patch can get picked up.

On Fri, Jan 3, 2014 at 10:11 AM, Seth Jennings <sjennings@variantweb.net> wrote:
> On Thu, Dec 19, 2013 at 08:23:27AM -0500, Dan Streetman wrote:
>> Currently, zswap is writeback cache; stored pages are not sent
>> to swap disk, and when zswap wants to evict old pages it must
>> first write them back to swap cache/disk manually.  This avoids
>> swap out disk I/O up front, but only moves that disk I/O to
>> the writeback case (for pages that are evicted), and adds the
>> overhead of having to uncompress the evicted pages and the
>> need for an additional free page (to store the uncompressed page).
>>
>> This optionally changes zswap to writethrough cache by enabling
>> frontswap_writethrough() before registering, so that any
>> successful page store will also be written to swap disk.  The
>> default remains writeback.  To enable writethrough, the param
>> zswap.writethrough=1 must be used at boot.
>>
>> Whether writeback or writethrough will provide better performance
>> depends on many factors including disk I/O speed/throughput,
>> CPU speed(s), system load, etc.  In most cases it is likely
>> that writeback has better performance than writethrough before
>> zswap is full, but after zswap fills up writethrough has
>> better performance than writeback.
>>
>> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
>
> Hey Dan, sorry for the delay on this.  Vacation and busyness.
>
> This looks like a good option for those that don't mind having
> the write overhead to ensure that things don't really bog down
> if the compress pool overflows, while maintaining the read fault
> speedup by decompressing from the pool.
>
> Acked-by: Seth Jennings <sjennings@variantweb.net>
