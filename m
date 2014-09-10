Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaIJOZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:25:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21365 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaIJOZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:25:30 -0400
Message-ID: <54105F28.1000506@oracle.com>
Date: Wed, 10 Sep 2014 10:24:40 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Trinity and mbind flags (WAS: Re: mm: BUG in unmap_page_range)
References: <53E989FB.5000904@oracle.com> <53FD4D9F.6050500@oracle.com> <20140827152622.GC12424@suse.de> <540127AC.4040804@oracle.com> <54082B25.9090600@oracle.com> <20140908171853.GN17501@suse.de> <540DEDE7.4020300@oracle.com> <20140909213309.GQ17501@suse.de> <540F7D42.1020402@oracle.com> <alpine.LSU.2.11.1409091903390.10989@eggly.anvils> <20140910124732.GT17501@suse.de>
In-Reply-To: <20140910124732.GT17501@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 08:47 AM, Mel Gorman wrote:
> That site should have checked PROT_NONE but it can't be the same bug
> that trinity is seeing. Minimally trinity is unaware of MPOL_MF_LAZY
> according to git grep of the trinity source.

Actually, if I'm reading it correctly I think that Trinity handles mbind()
calls wrong. It passes the wrong values for mode flags and actual flags.


Thanks,
Sasha
