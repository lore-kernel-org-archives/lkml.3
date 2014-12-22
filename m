Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaLVRKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:10:38 -0500
Received: from mga14.intel.com ([192.55.52.115]:6592 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbaLVRKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:10:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,625,1413270000"; 
   d="scan'208";a="658551121"
Message-ID: <5498508A.4080108@linux.intel.com>
Date: Mon, 22 Dec 2014 09:10:34 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, oleg@redhat.com, rientjes@google.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] proc: task_mmu: show page size in /proc/<pid>/numa_maps
References: <c97f30472ec5fe79cb8fa8be66cc3d8509777990.1419079617.git.aquini@redhat.com> <20141220183613.GA19229@phnom.home.cmpxchg.org> <20141220194457.GA3166@x61.redhat.com> <54970B49.3070104@linux.intel.com> <20141221222850.GA2038@x61.redhat.com>
In-Reply-To: <20141221222850.GA2038@x61.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2014 02:28 PM, Rafael Aquini wrote:
>>> > > I'm fine either way, it makes the change even simpler. Also, if we
>>> > > decide to get rid of page_size != PAGE_SIZE condition I believe we can 
>>> > > also get rid of that "huge" hint being conditionally printed out too.
>> > 
>> > That would break existing users of the "huge" flag.  That makes it out
>> > of the question, right?
>> >
> Yeah, but it sort of follows the same complaint Johannes did for the 
> conditional page size printouts. If we start to print out page size
> deliberately for each map regardless their backing pages being PAGE_SIZE 
> long or bigger, I don't see much point on keep conditionally printing out 
> the 'huge' hint out.

Because existing userspace might be relying on it.  If we take the
'huge' hint out, userspace will break.

> As I said before, I'm fine either way though I think
> we can keep the current behaviour, and just disambiguate page sizes !=
> PAGE_SIZE as in the current proposal.

Unless we somehow have a (really good) handle on how many apps out there
are reading and using 'huge', I think we have to keep the existing behavior.
