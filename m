Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaDGT3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:29:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57905 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830AbaDGT3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:29:11 -0400
Message-ID: <5342FC0E.9080701@zytor.com>
Date: Mon, 07 Apr 2014 12:27:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Cyrill Gorcunov <gorcunov@gmail.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Steven Noonan <steven@uplinklabs.net>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-X86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 2/3] x86: Define _PAGE_NUMA with unused physical address
 bits PMD and PTE levels
References: <1396883443-11696-1-git-send-email-mgorman@suse.de> <1396883443-11696-3-git-send-email-mgorman@suse.de> <5342C517.2020305@citrix.com> <20140407154935.GD7292@suse.de> <20140407161910.GJ1444@moon> <20140407182854.GH7292@suse.de>
In-Reply-To: <20140407182854.GH7292@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 11:28 AM, Mel Gorman wrote:
> 
> I had considered the soft-dirty tracking usage of the same bit. I thought I'd
> be able to swizzle around it or a further worst case of having soft-dirty and
> automatic NUMA balancing mutually exclusive. Unfortunately upon examination
> it's not obvious how to have both of them share a bit and I suspect any
> attempt to will break CRIU.  In my current tree, NUMA_BALANCING cannot be
> set if MEM_SOFT_DIRTY which is not particularly satisfactory. Next on the
> list is examining if _PAGE_BIT_IOMAP can be used.
> 

Didn't we smoke the last user of _PAGE_BIT_IOMAP?

	-hpa

