Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbaJ3Ncx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:32:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37331 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506AbaJ3Ncw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:32:52 -0400
Message-ID: <54523DDE.9000904@oracle.com>
Date: Thu, 30 Oct 2014 09:32:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        hannes@cmpxchg.org, peterz@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: initialize variable for mem_cgroup_end_page_stat
References: <1414633464-19419-1-git-send-email-sasha.levin@oracle.com> <20141030082712.GB4664@dhcp22.suse.cz>
In-Reply-To: <20141030082712.GB4664@dhcp22.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 04:27 AM, Michal Hocko wrote:
> On Wed 29-10-14 21:44:24, Sasha Levin wrote:
>> > Commit "mm: memcontrol: fix missed end-writeback page accounting" has changed
>> > the behaviour of mem_cgroup_begin_page_stat() to not always set the "locked"
>> > parameter.
>> > 
>> > We should initialize it at the callers to prevent garbage being used in a
>> > later call to mem_cgroup_end_page_stat().
> The contract is that if the returned memcg is non-NULL then the locked
> is always initialized. Nobody but mem_cgroup_end_page_stat should touch
> this variable and this function makes sure it uses it properly. Similar
> applies to flags which is initialized only if we really take the slow
> path (has a meaning only if locked == true).
> 
> So this is not really needed. Was this triggered by a compiler warning?

The problem is that you are attempting to read 'locked' when you call
mem_cgroup_end_page_stat(), so it gets used even before you enter the
function - and using uninitialized variables is undefined.

Yes, it's a compiler warning.


Thanks,
Sasha

