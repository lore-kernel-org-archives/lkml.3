Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3JaROq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:14:46 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:41177 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3JaROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:14:45 -0400
Message-ID: <52729003.1060209@gmail.com>
Date: Thu, 31 Oct 2013 13:14:43 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] mm: get rid of unnecessary pageblock scanning in setup_zone_migrate_reserve
References: <1382562092-15570-1-git-send-email-kosaki.motohiro@gmail.com> <20131030151904.GO2400@suse.de> <527169BB.8020104@gmail.com> <20131031101525.GT2400@suse.de>
In-Reply-To: <20131031101525.GT2400@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Nit. I would like to add following hunk. This is just nit because moving
>> reserve pageblock is extreme rare.
>>
>> 		if (block_migratetype == MIGRATE_RESERVE) {
>> +                       found++;
>> 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
>> 			move_freepages_block(zone, page, MIGRATE_MOVABLE);
>> 		}
>
> I don't really see the advantage but if you think it is necessary then I
> do not object either.

For example, a zone has five pageblock b1,b2,b3,b4,b5 and b1 has MIGRATE_RESERVE.
When hotremove b1 and hotadd again, your code need to scan all of blocks. But
mine only need to scan b1 and b2. I mean that's a hotplug specific optimization.


