Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab3CYJNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:13:48 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:36837 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab3CYJNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:13:47 -0400
Message-ID: <51501545.50908@suse.cz>
Date: Mon, 25 Mar 2013 10:13:41 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd reclaims
 at each priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-2-git-send-email-mgorman@suse.de> <20130325090758.GO2154@dhcp22.suse.cz>
In-Reply-To: <20130325090758.GO2154@dhcp22.suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 10:07 AM, Michal Hocko wrote:
> On Sun 17-03-13 13:04:07, Mel Gorman wrote:
>> The number of pages kswapd can reclaim is bound by the number of pages it
>> scans which is related to the size of the zone and the scanning priority. In
>> many cases the priority remains low because it's reset every SWAP_CLUSTER_MAX
>> reclaimed pages but in the event kswapd scans a large number of pages it
>> cannot reclaim, it will raise the priority and potentially discard a large
>> percentage of the zone as sc->nr_to_reclaim is ULONG_MAX. The user-visible
>> effect is a reclaim "spike" where a large percentage of memory is suddenly
>> freed. It would be bad enough if this was just unused memory but because
>> of how anon/file pages are balanced it is possible that applications get
>> pushed to swap unnecessarily.
>>
>> This patch limits the number of pages kswapd will reclaim to the high
>> watermark. Reclaim will will overshoot due to it not being a hard limit as
>> shrink_lruvec() will ignore the sc.nr_to_reclaim at DEF_PRIORITY but it
>> prevents kswapd reclaiming the world at higher priorities. The number of
>> pages it reclaims is not adjusted for high-order allocations as kswapd will
>> reclaim excessively if it is to balance zones for high-order allocations.
>>
>> Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> It seems I forgot to add
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks, now I applied all ten.

BTW I very pray this will fix also the issue I have when I run ltp tests
(highly I/O intensive, esp. `growfiles') in a VM while playing a movie
on the host resulting in a stuttered playback ;).

-- 
js
suse labs
