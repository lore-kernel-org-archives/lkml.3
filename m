Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbbAGJPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:15:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbbAGJPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:15:41 -0500
Message-ID: <54ACF93B.3060801@suse.cz>
Date: Wed, 07 Jan 2015 10:15:39 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH V4 4/4] mm: microoptimize zonelist operations
References: <1420478263-25207-1-git-send-email-vbabka@suse.cz> <1420478263-25207-5-git-send-email-vbabka@suse.cz> <20150106150920.GE20860@dhcp22.suse.cz>
In-Reply-To: <20150106150920.GE20860@dhcp22.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 04:09 PM, Michal Hocko wrote:
> On Mon 05-01-15 18:17:43, Vlastimil Babka wrote:
>> The function next_zones_zonelist() returns zoneref pointer, as well as zone
>> pointer via extra parameter. Since the latter can be trivially obtained by
>> dereferencing the former, the overhead of the extra parameter is unjustified.
>> 
>> This patch thus removes the zone parameter from next_zones_zonelist(). Both
>> callers happen to be in the same header file, so it's simple to add the
>> zoneref dereference inline. We save some bytes of code size.
> 
> Dunno. It makes first_zones_zonelist and next_zones_zonelist look
> different which might be a bit confusing. It's not a big deal but
> I am not sure it is worth it.

Yeah I thought that nobody uses them directly anyway thanks to
for_each_zone_zonelist* so it's not a big deal.
