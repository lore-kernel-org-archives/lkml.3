Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3DJFPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:15:49 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:57233 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3DJFPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:15:48 -0400
Message-ID: <5164F57E.3030106@gmail.com>
Date: Wed, 10 Apr 2013 13:15:42 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Simon Jeons <simon.jeons@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hedi Berriche <hedi@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: Avoid marking zones full prematurely
 after zone_reclaim()
References: <20130320181957.GA1878@suse.de> <514A7163.5070700@gmail.com> <20130321081902.GD6094@dhcp22.suse.cz> <515E6FC4.5000202@gmail.com> <5163E7EA.1040608@gmail.com> <20130409101437.GE29860@dhcp22.suse.cz>
In-Reply-To: <20130409101437.GE29860@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,
On 04/09/2013 06:14 PM, Michal Hocko wrote:
> On Tue 09-04-13 18:05:30, Simon Jeons wrote:
> [...]
>>> I try this in v3.9-rc5:
>>> dd if=/dev/sda of=/dev/null bs=1MB
>>> 14813+0 records in
>>> 14812+0 records out
>>> 14812000000 bytes (15 GB) copied, 105.988 s, 140 MB/s
>>>
>>> free -m -s 1
>>>
>>>                    total       used       free     shared buffers
>>> cached
>>> Mem:          7912       1181       6731          0 663        239
>>> -/+ buffers/cache:        277       7634
>>> Swap:         8011          0       8011
>>>
>>> It seems that almost 15GB copied before I stop dd, but the used
>>> pages which I monitor during dd always around 1200MB. Weird, why?
>>>
>> Sorry for waste your time, but the test result is weird, is it?
> I am not sure which values you have been watching but you have to
> realize that you are reading a _partition_ not a file and those pages
> go into buffers rather than the page chache.

Interesting. ;-)

What's the difference between buffers and page cache? Why buffers don't 
grow?


