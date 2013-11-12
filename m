Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3KLJMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:12:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22396 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3KLJMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:12:36 -0500
Message-ID: <5281F0B4.8060902@oracle.com>
Date: Tue, 12 Nov 2013 17:11:16 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dan Streetman <ddstreet@ieee.org>
CC: sjennings@variantweb.net, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>, minchan@kernel.org,
        weijie.yang@samsung.com, k.kozlowski@samsung.com,
        konrad.wilk@oracle.com
Subject: Re: mm/zswap: change to writethrough
References: <CALZtONAxsYxLizARV3Aam_n7534g5gh_FFkTz6jb-0Q9gThuBQ@mail.gmail.com>
In-Reply-To: <CALZtONAxsYxLizARV3Aam_n7534g5gh_FFkTz6jb-0Q9gThuBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/12/2013 03:12 AM, Dan Streetman wrote:
> Seth, have you (or anyone else) considered making zswap a writethrough
> cache instead of writeback?  I think that it would significantly help
> the case where zswap fills up and starts writing back its oldest pages
> to disc - all the decompression work would be avoided since zswap
> could just evict old pages and forget about them, and it seems likely
> that when zswap is full that's probably the worst time to add extra
> work/delay, while adding extra disc IO (presumably using dma) before
> zswap is full doesn't seem to me like it would have much impact,
> except in the case where zswap isn't full but there is so little free
> memory that new allocs are waiting on swap-out.
> 
> Besides the additional disc IO that obviously comes with making zswap
> writethrough (additional only before zswap fills up), are there any
> other disadvantages?  Is it a common situation for there to be no
> memory left and get_free_page actively waiting on swap-out, but before
> zswap fills up?
> 
> Making it writethrough also could open up other possible improvements,
> like making the compression and storage of new swap-out pages async,
> so the compression doesn't delay the write out to disc.
> 

I like this idea and those benefits, the only question I'm not sure is
would it be too complicate to implement this feature? It sounds like we
need to reimplement something like swapcache to handle zswap write through.

-- 
Regards,
-Bob
