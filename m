Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3JILNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:13:33 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60376 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3JILNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:13:31 -0400
Date: Wed, 9 Oct 2013 13:13:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/63] Basic scheduler support for automatic NUMA
 balancing V9
Message-ID: <20131009111328.GB19610@gmail.com>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
 <20131009110353.GA19370@gmail.com>
 <20131009111146.GA19610@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009111146.GA19610@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

>  mmzone.c:
> 
>   #if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_CPUPID_IN_PAGE_FLAGS)
> 
> Note the missing 'NOT_' in the latter line. I've changed it to:
> 
>   #if defined(CONFIG_NUMA_BALANCING) && defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS)

Actually, I think it should be:

   #if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS)

I'll fold back this fix to keep it bisectable on 32-bit platforms.

Thanks,

	Ingo
