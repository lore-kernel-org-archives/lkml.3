Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934823AbaGQQNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:13:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31403 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934776AbaGQQNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:13:10 -0400
Message-ID: <53C7F5FF.7010006@oracle.com>
Date: Thu, 17 Jul 2014 12:12:47 -0400
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
References: <alpine.LSU.2.11.1407150247540.2584@eggly.anvils> <53C7F55B.8030307@suse.cz>
In-Reply-To: <53C7F55B.8030307@suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 12:10 PM, Vlastimil Babka wrote:
> On 07/15/2014 12:28 PM, Hugh Dickins wrote:
>> In the end I decided that we had better look at it as two problems,
>> the trinity faulting starvation, and the indefinite punching loop,
>> so 1/2 and 2/2 present both solutions: belt and braces.
> 
> I tested that with my reproducer and it was OK, but as I already said, it's not trinity so I didn't observe the new problems in the first place.

I've started seeing a new hang in the lru code, but I'm not sure if
it's related to this patch or not (the locks are the same ones, but
the location is very different).

I'm looking into that.


Thanks,
Sasha
