Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3CSKRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:17:00 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58010 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3CSKQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:16:58 -0400
Message-ID: <51483B12.6040502@gmail.com>
Date: Tue, 19 Mar 2013 18:16:50 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd reclaims
 at each priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-2-git-send-email-mgorman@suse.de> <5147A8EC.5010908@gmail.com> <20130319095514.GA2055@suse.de>
In-Reply-To: <20130319095514.GA2055@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,
On 03/19/2013 05:55 PM, Mel Gorman wrote:
> On Tue, Mar 19, 2013 at 07:53:16AM +0800, Simon Jeons wrote:
>> Hi Mel,
>> On 03/17/2013 09:04 PM, Mel Gorman wrote:
>>> The number of pages kswapd can reclaim is bound by the number of pages it
>>> scans which is related to the size of the zone and the scanning priority. In
>>> many cases the priority remains low because it's reset every SWAP_CLUSTER_MAX
>>> reclaimed pages but in the event kswapd scans a large number of pages it
>>> cannot reclaim, it will raise the priority and potentially discard a large
>>> percentage of the zone as sc->nr_to_reclaim is ULONG_MAX. The user-visible
>>> effect is a reclaim "spike" where a large percentage of memory is suddenly
>>> freed. It would be bad enough if this was just unused memory but because
>> Since there is nr_reclaimed >= nr_to_reclaim check if priority is
>> large than DEF_PRIORITY in shrink_lruvec, how can a large percentage
>> of memory is suddenly freed happen?
>>
> Because of the priority checks made in get_scan_count(). Patch 5 has
> more detail on why this happens.
>
But nr_reclaim >= nr_to_reclaim check in function shrink_lruvec is after 
scan each evictable lru, so if priority == 0, still scan the whole world.
