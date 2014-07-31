Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaGaPjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaGaPjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:39:33 -0400
Message-ID: <53DA62FB.7000108@redhat.com>
Date: Thu, 31 Jul 2014 11:38:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 2/2] memcg, vmscan: Fix forced scan of anonymous pages
References: <1406807385-5168-1-git-send-email-jmarchan@redhat.com> <1406807385-5168-3-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1406807385-5168-3-git-send-email-jmarchan@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/31/2014 07:49 AM, Jerome Marchand wrote:
> When memory cgoups are enabled, the code that decides to force to
> scan anonymous pages in get_scan_count() compares global values
> (free, high_watermark) to a value that is restricted to a memory
> cgroup (file). It make the code over-eager to force anon scan.
> 
> For instance, it will force anon scan when scanning a memcg that
> is mainly populated by anonymous page, even when there is plenty of
> file pages to get rid of in others memcgs, even when swappiness ==
> 0. It breaks user's expectation about swappiness and hurts
> performance.
> 
> This patch make sure that forced anon scan only happens when there
> not enough file pages for the all zone, not just in one random
> memcg.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

That fix is a lot smaller than I thought it would be. Nice.

Reviewed-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT2mL7AAoJEM553pKExN6DbzsH/ArKqWXYFfz7/hjADJXz85aK
ygWdjpK18MbFeUMW3nL324j2567TXWpC2G7SgxSPjYnF/qvKjpoQHJk7WvisymjE
p+5jGQAxzXgjlq0usGoFRrWUnR6vkdjTx0K8r6MO/asMLbvDBjkXvaURHdcV6fx4
nUbkF/GRXGAGcnHOEks294w+8j8R50bugnX+IfmKo73eteNcMWU7Ga+b93kUmz3p
4EE2PRpRKFWtpTAhpFlFI46gfu+e7I1Ziu2pzNUlYOP3P7t9pRS8YOI5JNOnyDfi
lrbOXzoSqs6sbIlDd//A/p7u6Pzr+HnpbaxCrf9UCdNaMMqvb0gDQWv7221gI24=
=BfHz
-----END PGP SIGNATURE-----
