Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3KUWSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:18:46 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:60850 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KUWSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:18:43 -0500
MIME-Version: 1.0
In-Reply-To: <CALZtONByWEv-vyx8+HMn+o53hPO4L_UY-+BbLRrBoWx-u2UejA@mail.gmail.com>
References: <1384976909-32671-1-git-send-email-ddstreet@ieee.org>
 <CAL1ERfPcAbNyt9hTYKMj9OGK2=ynLrTVm9udEn=hF+bFptC16Q@mail.gmail.com> <CALZtONByWEv-vyx8+HMn+o53hPO4L_UY-+BbLRrBoWx-u2UejA@mail.gmail.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Thu, 21 Nov 2013 17:18:21 -0500
X-Google-Sender-Auth: hGxsckQZJN9t3__v_C9TYexx5DQ
Message-ID: <CALZtONDH1naq7uKOfcqCz+5bREYYd3A5-DN72wJ5TOpZEcaygw@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: don't allow entry eviction if in use by load
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 4:44 PM, Dan Streetman <ddstreet@ieee.org> wrote:
> On Wed, Nov 20, 2013 at 8:59 PM, Weijie Yang <weijie.yang.kh@gmail.com> wrote:
>> Hello Dan
>>
>> On Thu, Nov 21, 2013 at 3:48 AM, Dan Streetman <ddstreet@ieee.org> wrote:
>>> The changes in commit 0ab0abcf511545d1fddbe72a36b3ca73388ac937
>>> introduce a bug in writeback, if an entry is in use by load
>>> it will be evicted anyway, which isn't correct (technically,
>>> the code currently in zbud doesn't actually care much what the
>>> zswap evict function returns, but that could change).
>>
>> Thanks for your work. Howerver it is not a bug.
>>
>> I have thought about this situation, and it will never happen.
>> If entry is being loaded, its corresponding page must be in swapcache
>> so zswap_get_swap_cache_page() will return ZSWAP_SWAPCACHE_EXIST
>
>
> Can I also ask why you do a rb_search instead of just checking the
> entry->refcount?  Doing the search is going to take longer than just
> checking the refcount; is there some case where the entry will not be
> in the rb but will have a nonzero refcount?

Never mind; I realized the entry will have been free'd once it's
refcount is 0 so that can't be checked.
