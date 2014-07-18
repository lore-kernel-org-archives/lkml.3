Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbaGRKpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:45:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46726 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761234AbaGRKpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:45:09 -0400
Message-ID: <53C8FAA6.9050908@oracle.com>
Date: Fri, 18 Jul 2014 06:44:54 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Konstantin Khlebnikov <koct9i@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Lukas Czerner <lczerner@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] shmem: fix faulting into a hole while it's punched,
 take 3
References: <alpine.LSU.2.11.1407150247540.2584@eggly.anvils> <53C7F55B.8030307@suse.cz> <53C7F5FF.7010006@oracle.com>
In-Reply-To: <53C7F5FF.7010006@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 12:12 PM, Sasha Levin wrote:
> On 07/17/2014 12:10 PM, Vlastimil Babka wrote:
>> > On 07/15/2014 12:28 PM, Hugh Dickins wrote:
>>> >> In the end I decided that we had better look at it as two problems,
>>> >> the trinity faulting starvation, and the indefinite punching loop,
>>> >> so 1/2 and 2/2 present both solutions: belt and braces.
>> > 
>> > I tested that with my reproducer and it was OK, but as I already said, it's not trinity so I didn't observe the new problems in the first place.
> I've started seeing a new hang in the lru code, but I'm not sure if
> it's related to this patch or not (the locks are the same ones, but
> the location is very different).
> 
> I'm looking into that.

Hi Hugh,

The new hang I'm seeing is much simpler to analyse (compared to shmem_fallocate) and
doesn't seem to be related. I'll send a separate mail and Cc you just in case, but
I don't think that this patchset has anything to do with it.

Otherwise, I've been unable to reproduce the shmem_fallocate hang.


Thanks,
Sasha
