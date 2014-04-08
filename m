Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbaDHOqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:46:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39701 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762AbaDHOqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:46:46 -0400
Message-ID: <53440A5D.6050301@zytor.com>
Date: Tue, 08 Apr 2014 07:40:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Linux-X86 <x86@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for _PAGE_NUMA
 v2
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1396962570-18762-1-git-send-email-mgorman@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 06:09 AM, Mel Gorman wrote:
> Using unused physical bits is something that will break eventually.
> 
> Changelog since V1
> o Reuse software-bits
> o Use paravirt ops when modifying PTEs in the NUMA helpers
> 
> Aliasing _PAGE_NUMA and _PAGE_PROTNONE had some convenient properties but
> it ultimately gave Xen a headache and pisses almost everybody off that
> looks closely at it. Two discussions on "why this makes sense" is one
> discussion too many so rather than having a third so here is this series.
> This series reuses the PTE bits that are available to the programmer.
> This adds some contraints on how and when automatic NUMA balancing can be
> enabled but it should go away again when Xen stops using _PAGE_IOMAP.
> 
> The series also converts the NUMA helpers to use paravirt-friendly operations
> but it needs a Tested-by from the Xen and powerpc people.
> 

It is proably simpler to just base this patchset on top of David
Vrabel's which actually *does* remove _PAGE_IOMAP.

David, is your patchset going to be pushed in this merge window as expected?

That being said, these bits are precious, and if this ends up being a
case where "only Xen needs another bit" once again then Xen should
expect to get kicked to the curb at a moment's notice.

	-hpa


