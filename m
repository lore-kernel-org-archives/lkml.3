Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaGOErT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:47:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:47563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaGOErQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:47:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="543404267"
Message-ID: <53C4B251.5000505@intel.com>
Date: Mon, 14 Jul 2014 21:47:13 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, thp: only collapse hugepages to nodes with affinity
References: <alpine.DEB.2.02.1407141807030.8808@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407141807030.8808@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 06:09 PM, David Rientjes wrote:
> +		if (node == NUMA_NO_NODE) {
> +			node = page_to_nid(page);
> +		} else {
> +			int distance = node_distance(page_to_nid(page), node);
> +
> +			/*
> +			 * Do not migrate to memory that would not be reclaimed
> +			 * from.
> +			 */
> +			if (distance > RECLAIM_DISTANCE)
> +				goto out_unmap;
> +		}

Isn't the reclaim behavior based on zone_reclaim_mode and not
RECLAIM_DISTANCE directly?  And isn't that reclaim behavior disabled by
default?

I think you should at least be consulting zone_reclaim_mode.
