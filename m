Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaGQAya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:54:30 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:50562 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbaGQAyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:54:23 -0400
Date: Wed, 16 Jul 2014 17:54:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm, tmp: only collapse hugepages to nodes with affinity
 for zone_reclaim_mode
In-Reply-To: <53C69C7B.1010709@suse.cz>
Message-ID: <alpine.DEB.2.02.1407161754000.23892@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407141807030.8808@chino.kir.corp.google.com> <alpine.DEB.2.02.1407151712520.12279@chino.kir.corp.google.com> <53C69C7B.1010709@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014, Vlastimil Babka wrote:

> I wonder if you could do this here?
> 
> if (khugepaged_node_load[nid])
> 	return false;
> 
> If the condition is true, it means you already checked the 'nid' node against
> all other nodes present in the pmd in a previous khugepaged_scan_pmd iteration.
> And if it passed then, it would also pass now. If meanwhile a new node was found
> and recorded, it was also checked against everything present at that point,
> including 'nid'. So it should be safe?
> 
> The worst case (perfect interleaving page per page, so that "node != last_node"
> is true in each iteration) complexity then reduces from O(HPAGE_PMD_NR *
> MAX_NUMNODES) to O(HPAGE_PMD_NR + MAX_NUMNODES) iterations.
> 

Excellent suggestion, thanks Vlastimil!
