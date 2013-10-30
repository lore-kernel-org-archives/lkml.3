Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3J3T0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:26:21 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:63139 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3J3T0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:26:20 -0400
Message-ID: <52715D58.9020800@gmail.com>
Date: Wed, 30 Oct 2013 15:26:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] mm: get rid of unnecessary pageblock scanning in setup_zone_migrate_reserve
References: <1382562092-15570-1-git-send-email-kosaki.motohiro@gmail.com> <20131030151904.GO2400@suse.de>
In-Reply-To: <20131030151904.GO2400@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(10/30/13 11:19 AM), Mel Gorman wrote:
> On Wed, Oct 23, 2013 at 05:01:32PM -0400, kosaki.motohiro@gmail.com wrote:
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> Yasuaki Ithimatsu reported memory hot-add spent more than 5 _hours_
>> on 9TB memory machine and we found out setup_zone_migrate_reserve
>> spnet >90% time.
>>
>> The problem is, setup_zone_migrate_reserve scan all pageblock
>> unconditionally, but it is only necessary number of reserved block
>> was reduced (i.e. memory hot remove).
>> Moreover, maximum MIGRATE_RESERVE per zone are currently 2. It mean,
>> number of reserved pageblock are almost always unchanged.
>>
>> This patch adds zone->nr_migrate_reserve_block to maintain number
>> of MIGRATE_RESERVE pageblock and it reduce an overhead of
>> setup_zone_migrate_reserve dramatically.
>>
>
> It seems regrettable to expand the size of struct zone just for this.

This is only matter when backporting enterprise distro. But you are right
it would be nice if it's avoidable.

> You are right that the number of blocks does not exceed 2 because of a
> check made in setup_zone_migrate_reserve so it should be possible to
> special case this. I didn't test this or think about it particularly
> carefully and no doubt there is a nicer way but for illustration
> purposes see the patch below.

I'll test. A few days give me please.


