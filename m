Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935034Ab3DHRjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:39:48 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37765 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762474Ab3DHRjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:39:47 -0400
Message-ID: <516300C7.7000008@linux.vnet.ibm.com>
Date: Mon, 08 Apr 2013 10:39:19 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm/page_alloc: factor out setting of pcp->high and
 pcp->batch.
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <1365194030-28939-2-git-send-email-cody@linux.vnet.ibm.com> <5160CDD8.3050908@gmail.com>
In-Reply-To: <5160CDD8.3050908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040817-7182-0000-0000-0000062409AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2013 06:37 PM, Simon Jeons wrote:
> Hi Cody,
> On 04/06/2013 04:33 AM, Cody P Schafer wrote:
>> Creates pageset_set_batch() for use in setup_pageset().
>> pageset_set_batch() imitates the functionality of
>> setup_pagelist_highmark(), but uses the boot time
>> (percpu_pagelist_fraction == 0) calculations for determining ->high
>
> Why need adjust pcp->high, pcp->batch during system running? What's the
> requirement?
>

There is currently a sysctl (which I patch later in this series) which 
allows adjusting the ->high mark (and, indirectly, ->batch). 
Additionally, memory hotplug changes ->high and ->batch due to the zone 
size changing (essentially, zone->managed_pages and zone->present_pages 
have changed) , meaning that zone_batchsize(), which is used at boot to 
set ->batch and (indirectly) ->high has a different output.

Note that in addition to the 2 users of this functionality mentioned 
here, I'm currently working on anther resizer of zones (runtime NUMA 
reconfiguration).

