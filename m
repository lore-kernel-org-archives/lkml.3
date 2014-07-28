Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaG1ImO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:42:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaG1ImJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:42:09 -0400
Message-ID: <53D60CDD.4080801@suse.cz>
Date: Mon, 28 Jul 2014 10:42:05 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v3] mm, thp: only collapse hugepages to nodes with affinity
 for zone_reclaim_mode
References: <alpine.DEB.2.02.1407141807030.8808@chino.kir.corp.google.com> <alpine.DEB.2.02.1407151712520.12279@chino.kir.corp.google.com> <53C69C7B.1010709@suse.cz> <alpine.DEB.2.02.1407161754000.23892@chino.kir.corp.google.com> <alpine.DEB.2.02.1407161757500.23892@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407161757500.23892@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 02:59 AM, David Rientjes wrote:
> Commit 9f1b868a13ac ("mm: thp: khugepaged: add policy for finding target
> node") improved the previous khugepaged logic which allocated a
> transparent hugepages from the node of the first page being collapsed.
>
> However, it is still possible to collapse pages to remote memory which may
> suffer from additional access latency.  With the current policy, it is
> possible that 255 pages (with PAGE_SHIFT == 12) will be collapsed remotely
> if the majority are allocated from that node.
>
> When zone_reclaim_mode is enabled, it means the VM should make every attempt
> to allocate locally to prevent NUMA performance degradation.  In this case,
> we do not want to collapse hugepages to remote nodes that would suffer from
> increased access latency.  Thus, when zone_reclaim_mode is enabled, only
> allow collapsing to nodes with RECLAIM_DISTANCE or less.
>
> There is no functional change for systems that disable zone_reclaim_mode.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

