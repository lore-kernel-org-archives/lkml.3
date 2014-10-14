Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaJNXJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 19:09:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48018 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbaJNXJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 19:09:05 -0400
Message-ID: <543DACFB.2060405@oracle.com>
Date: Tue, 14 Oct 2014 19:08:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, Yu Zhao <yuzhao@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Bob Liu <lliubbo@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: verify compound order when freeing a page
References: <1413317800-25450-1-git-send-email-yuzhao@google.com> <1413317800-25450-2-git-send-email-yuzhao@google.com> <20141014202955.GA2889@psi-dev26.jf.intel.com>
In-Reply-To: <20141014202955.GA2889@psi-dev26.jf.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 04:29 PM, David Cohen wrote:
>> +	VM_BUG_ON(PageTail(page));
>> > +	VM_BUG_ON(PageHead(page) && compound_order(page) != order);
> It may be too severe. AFAIU we're not talking about a fatal error.
> How about VM_WARN_ON()?

VM_BUG_ON() should catch anything which is not "supposed" to happen,
and not just the severe stuff. Unlike BUG_ON, VM_BUG_ON only gets
hit with mm debugging enabled.


Thanks,
Sasha
