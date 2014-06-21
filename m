Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbaFUBEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 21:04:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33048 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaFUBEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 21:04:10 -0400
Message-ID: <53A4D9F6.6090504@oracle.com>
Date: Fri, 20 Jun 2014 21:03:50 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>	<1403124045-24361-14-git-send-email-hannes@cmpxchg.org>	<53A4D323.5080808@oracle.com> <20140620175648.666cae72.akpm@linux-foundation.org>
In-Reply-To: <20140620175648.666cae72.akpm@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 08:56 PM, Andrew Morton wrote:
> On Fri, 20 Jun 2014 20:34:43 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> I'm seeing the following when booting a VM, bisection pointed me to this
>> patch.
>>
>> [   32.830823] BUG: using __this_cpu_add() in preemptible [00000000] code: mkdir/8677
> 
> Thanks.  This one was fixed earlier today.

Thank Andrew. My first bisection attempt went sideways and ended up
pointing at "fs/mpage.c: forgotten WRITE_SYNC in case of data integrity write"
for some reason.

My attempt to understand what data integrity has to do cgroups was unfruitful :(


Thanks,
Sasha

