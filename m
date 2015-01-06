Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbbAFC63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:58:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbbAFC61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:58:27 -0500
Message-ID: <54AB4F3F.50103@redhat.com>
Date: Mon, 05 Jan 2015 21:58:07 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, stable@vger.kernel.org
Subject: Re: [PATCH V3 2/2] mm, vmscan: wake up all pfmemalloc-throttled processes
 at once
References: <1420448203-30212-1-git-send-email-vbabka@suse.cz> <1420448203-30212-2-git-send-email-vbabka@suse.cz>
In-Reply-To: <1420448203-30212-2-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/05/2015 03:56 AM, Vlastimil Babka wrote:
> Kswapd in balance_pgdate() currently uses wake_up() on processes
> waiting in throttle_direct_reclaim(), which only wakes up a single
> process. This might leave processes waiting for longer than
> necessary, until the check is reached in the next loop iteration.
> Processes might also be left waiting if zone was fully balanced in
> single iteration. Note that the comment in balance_pgdat() also
> says "Wake them", so waking up a single process does not seem
> intentional.
> 
> Thus, replace wake_up() with wake_up_all().
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz> Cc: Mel Gorman
> <mgorman@suse.de> Cc: Johannes Weiner <hannes@cmpxchg.org> Cc:
> Michal Hocko <mhocko@suse.cz> Cc: Vladimir Davydov
> <vdavydov@parallels.com> Cc: Rik van Riel <riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUq08+AAoJEM553pKExN6D9bEIAKV916k0OguiyAGIXrgjPrba
3W2eQ2FFWIm6KwumPas7t6jBzR11yFhpAIACf6nNt12EmH73UwaW2z6vdYque4c+
HU79DXTNTQ91xJfXI8XfNsZW/s8zpCZ+Sm08N7/O7k6c76yKR+owXmoSnjb2Q4N9
O0F0db3Jkd52sH/2l+LCUKrTeI9fRBrKnpAv7FAhZ5go8N7tdtIjYv8hhpIZ/83F
WSRsORt0VKOx0an+JO09e5f6R+RF7RAqiU6yUdDAk52CJzyRqECksLxDOvw81OHD
QUT5TuMVNoqXNJxFpQvyI8Dn82d1CiisX2Wztcic4OlxPJQ6gK04SmeWMXw8Ijw=
=pnD6
-----END PGP SIGNATURE-----
