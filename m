Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbaJNPb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:31:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbaJNPb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 11:31:56 -0400
Message-ID: <543D41B9.1040401@redhat.com>
Date: Tue, 14 Oct 2014 11:31:05 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [BUG] mm, thp: khugepaged can't allocate on requested node when
 confined to a cpuset
References: <20141008191050.GK3778@sgi.com> <20141014114828.GA6524@node.dhcp.inet.fi> <20141014145435.GA7369@worktop.fdxtended.com>
In-Reply-To: <20141014145435.GA7369@worktop.fdxtended.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 10:54 AM, Peter Zijlstra wrote:
> On Tue, Oct 14, 2014 at 02:48:28PM +0300, Kirill A. Shutemov wrote:
>
>> Why whould you want to pin khugpeaged? Is there a valid use-case?
>> Looks like userspace shoots to its leg.
>
> Its just bad design to put so much work in another context. But the
> use-case is isolating other cpus.
>
>> Is there a reason why we should respect cpuset limitation for kernel
>> threads?
>
> Yes, because we want to allow isolating CPUs from 'random' activity.
>
>> Should we bypass cpuset for PF_KTHREAD completely?
>
> No. That'll break stuff.

Agreed on the above.

I suspect the sane thing to do is allow a cpuset
limited task to still allocate pages elsewhere,
if it explicitly asks for it.

Ask for something potentially stupid? Get it :)

In many of the cases where something asks for memory
in a specific location, it has a good reason to do
so, and there's no reason to deny it.
