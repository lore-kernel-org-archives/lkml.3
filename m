Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937566Ab3DIKUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:20:18 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62840 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935573Ab3DIKUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:20:16 -0400
Message-ID: <5163EB59.3010204@gmail.com>
Date: Tue, 09 Apr 2013 18:20:09 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
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

buffer cache are contained in page cache, is it? Which value I should watch?


