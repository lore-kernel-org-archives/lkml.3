Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3KWUf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 15:35:59 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:45255 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3KWUf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 15:35:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1ERfNWXFmKFbVf2H1G7A=rVfxh+0ScN_yn_YcH=VsUr3bVjg@mail.gmail.com>
References: <1384976973-32722-1-git-send-email-ddstreet@ieee.org>
 <1385158216-6247-1-git-send-email-ddstreet@ieee.org> <CAL1ERfNWXFmKFbVf2H1G7A=rVfxh+0ScN_yn_YcH=VsUr3bVjg@mail.gmail.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Sat, 23 Nov 2013 15:35:35 -0500
X-Google-Sender-Auth: BtHmqs7TwWOI_j-t0MWosTHRH_g
Message-ID: <CALZtONByDcL+yd3rMfFmrW_a2dV3ZV8XKiWcxba-oWTWeGNVVQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm/zswap: change zswap to writethrough cache
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 9:37 PM, Weijie Yang <weijie.yang.kh@gmail.com> wrote:
> Hello Dan,
>
> On Sat, Nov 23, 2013 at 6:10 AM, Dan Streetman <ddstreet@ieee.org> wrote:
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
>> This changes zswap to writethrough cache by enabling
>> frontswap_writethrough() before registering, so that any
>> successful page store will also be written to swap disk.  All the
>> writeback code is removed since it is no longer needed, and the
>> only operation during a page eviction is now to remove the entry
>> from the tree and free it.
>
> I agree with Seth, It is not good to embedded device.
> May be we can find its place in others like server.
> I guess it is good to medium workload when swap io is not frequent.
>
> My suggestion is would you please make it configurable so that user
> can choice to use writethrough or writeback mode?
>

Having to support both significantly increases complexity and I think
would make further improvements more difficult.  My opinion is the
writeback code should be removed.  Is there anyone else who thinks
both should be available by a param?
