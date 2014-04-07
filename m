Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaDGPco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:32:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:17698 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbaDGPcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:32:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,810,1389744000"; 
   d="scan'208";a="118724411"
Message-ID: <5342C517.2020305@citrix.com>
Date: Mon, 7 Apr 2014 16:32:39 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Noonan <steven@uplinklabs.net>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-X86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86: Define _PAGE_NUMA with unused physical address
 bits PMD and PTE levels
References: <1396883443-11696-1-git-send-email-mgorman@suse.de> <1396883443-11696-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1396883443-11696-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/14 16:10, Mel Gorman wrote:
> _PAGE_NUMA is currently an alias of _PROT_PROTNONE to trap NUMA hinting
> faults. As the bit is shared care is taken that _PAGE_NUMA is only used in
> places where _PAGE_PROTNONE could not reach but this still causes problems
> on Xen and conceptually difficult.

The problem with Xen guests occurred because mprotect() /was/ confusing
PROTNONE mappings with _PAGE_NUMA and clearing the non-existant NUMA hints.

David
