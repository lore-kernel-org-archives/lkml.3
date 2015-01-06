Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbbAFCpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:45:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238AbbAFCpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:45:51 -0500
Message-ID: <54AB4C4C.5030004@redhat.com>
Date: Mon, 05 Jan 2015 21:45:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov@parallels.com>,
        stable@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH V3 1/2] mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled
 process being killed
References: <1420448203-30212-1-git-send-email-vbabka@suse.cz>
In-Reply-To: <1420448203-30212-1-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/05/2015 03:56 AM, Vlastimil Babka wrote:
> Charles Shirron and Paul Cassella from Cray Inc have reported
> kswapd stuck in a busy loop with nothing left to balance, but
> kswapd_try_to_sleep() failing to sleep. Their analysis found the
> cause to be a combination of several factors:

> Fixes: 5515061d22f0 ("mm: throttle direct reclaimers if PF_MEMALLOC
> reserves are low and swap is backed by network storage") 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz> Signed-off-by:
> Vladimir Davydov <vdavydov@parallels.com> Cc:
> <stable@vger.kernel.org>   # v3.6+ Cc: Mel Gorman
> <mgorman@suse.de> Cc: Johannes Weiner <hannes@cmpxchg.org> Cc:
> Michal Hocko <mhocko@suse.cz> Cc: Rik van Riel <riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUq0xLAAoJEM553pKExN6D8ZgH/3AjsMKmA/JytTf5WOjpO0+W
ozN7ttYjYfIAFytYymPYkbm5/8pLBhy9HM9szMijRa+vhLyiGr5CSB0jTTU+1ImP
BynATfT4NbAHssosMRCHqRep/NmGkaV0qkiL4ndEaCwiGz/x481jgvHXP3GdHxbu
kIt8gYrP1gK3yM+yGk06nhsM9QU0C0P/ngzAvMTrch/nKr679Uu+chyLAskms7hZ
+x0OZkkN1gWGDCn55swLPURbIPnWedml+HB19e30fehLtpCcPoTzc1Zr46fPcI4O
BhJJX8QCWhpYdXqE1TZCid3zV4wPTJKAe1MskzBCgo3ELYE7ll1gM24QcfrpdgA=
=0cv0
-----END PGP SIGNATURE-----
