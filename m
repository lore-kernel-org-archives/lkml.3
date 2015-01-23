Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbbAWRAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:00:30 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:40119 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbbAWRAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:00:23 -0500
Message-ID: <54C27E07.6000908@roeck-us.net>
Date: Fri, 23 Jan 2015 08:59:51 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, mhocko@suse.cz
Subject: Re: mmotm 2015-01-22-15-04: qemu failure due to 'mm: memcontrol:
 remove unnecessary soft limit tree node test'
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org> <20150123050802.GB22751@roeck-us.net> <20150123141817.GA22926@phnom.home.cmpxchg.org> <alpine.DEB.2.11.1501230908560.15325@gentwo.org> <20150123160204.GA32592@phnom.home.cmpxchg.org>
In-Reply-To: <20150123160204.GA32592@phnom.home.cmpxchg.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54C27E27.00DF,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 08:02 AM, Johannes Weiner wrote:
> On Fri, Jan 23, 2015 at 09:17:44AM -0600, Christoph Lameter wrote:
>> On Fri, 23 Jan 2015, Johannes Weiner wrote:
>>
>>> Is the assumption of this patch wrong?  Does the specified node have
>>> to be online for the fallback to work?
>>
>> Nodes that are offline have no control structures allocated and thus
>> allocations will likely segfault when the address of the controls
>> structure for the node is accessed.
>>
>> If we wanted to prevent that then every allocation would have to add a
>> check to see if the nodes are online which would impact performance.
>
> Okay, that makes sense, thank you.
>
> Andrew, can you please drop this patch?
>
Problem is that there are three patches.

2537ffb mm: memcontrol: consolidate swap controller code
2f9b346 mm: memcontrol: consolidate memory controller initialization
a40d0d2 mm: memcontrol: remove unnecessary soft limit tree node test

Reverting (or dropping) a40d0d2 alone is not possible since it modifies
mem_cgroup_soft_limit_tree_init which is removed by 2f9b346.

Guenter

