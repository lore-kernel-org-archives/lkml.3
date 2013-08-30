Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3H3RyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:54:23 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42930 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab3H3RyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:54:21 -0400
Message-ID: <5220DB5D.9030905@linux.vnet.ibm.com>
Date: Fri, 30 Aug 2013 23:20:21 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org,
        tony.luck@intel.com, matthew.garrett@nebula.com, riel@redhat.com,
        arjan@linux.intel.com, srinivas.pandruvada@linux.intel.com,
        willy@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org,
        rjw@sisk.pl, gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v3 00/35] mm: Memory Power Management
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com> <5220B9E4.3040306@sr71.net>
In-Reply-To: <5220B9E4.3040306@sr71.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083017-9574-0000-0000-000009693126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 08:57 PM, Dave Hansen wrote:
> On 08/30/2013 06:13 AM, Srivatsa S. Bhat wrote:
>> Overview of Memory Power Management and its implications to the Linux MM
>> ========================================================================
>>
>> Today, we are increasingly seeing computer systems sporting larger and larger
>> amounts of RAM, in order to meet workload demands. However, memory consumes a
>> significant amount of power, potentially upto more than a third of total system
>> power on server systems[4]. So naturally, memory becomes the next big target
>> for power management - on embedded systems and smartphones, and all the way
>> upto large server systems.
> 
> Srivatsa, you're sending a huge patch set to a very long cc list of
> people, but you're leading the description with text that most of us
> have already read a bunch of times.  Why?
> 

Well, I had got the impression that with each posting, a fresh set of
reviewers were taking a look at the patchset for the first time. So I retained
the leading description. But since you have been familiar with this patchset
right from the very first posting, I think you found it repetitive and useless.
Thanks for the tip, I'll curtail the leading text in future versions and
instead give links to earlier patchsets as reference, for new reviewers.

> What changed in this patch from the last round?

The fundamental change in this version is the splitting up of the memory
allocator into a front-end (page-allocator) and a back-end (region-allocator).
The corresponding code is in patches 18 to 32. Patches 33-35 are some policy
changes on top of that infrastructure that help further improve the consolidation.
Overall, this design change has caused considerable improvements in the
consolidation ratio achieved by the patchset.

Minor changes include augmenting /proc/pagetypeinfo to print the statistics
on a per-region basis, which turns out to be very useful in visualizing the
fragmentation.

And in this version, the experimental results section (which I posted as a
reply to the cover-letter) has some pretty noticeable numbers. The previous
postings didn't really have enough numbers/data to prove that the patchset
actually was much better than mainline. This version addresses that issue,
from a functional point-of-view.

>  Where would you like
> reviewers to concentrate their time amongst the thousand lines of code?

I would be grateful if reviewers could comment on the new split-allocator
design and let me know if they notice any blatant design issues. Some of
the changes are very bold IMHO, so I'd really appreciate if reviewers could
let me know if I'm going totally off-track or whether the numbers/data
justify the huge design changes sufficiently (atleast to know whether to
continue in that direction or not).

>  What barriers do _you_ see as remaining before this gets merged?
> 

I believe that I have showcased all the major design changes that I had
in mind, in this version and the previous versions. (This version includes
all of them, except the targeted compaction support (dropped temporarily),
which was introduced in the last version). What remains is the routine work:
making this code work with various MM config options etc, and reduce the
overhead in the hotpaths.

So, if the design changes are agreed upon, I can go ahead and address the
remaining rough edges and make it merge-ready. I assume it would be good
to add a config option and keep it under Kernel Hacking or such, so that
people who know their platform characteristics can try it out by giving
the region-boundaries via kernel command line etc. I think that would be
a good way to upstream this feature, since it allows the flexibility for
people to try it out with various usecases on different platforms. (Also,
that way, we need not wait for firmware support such as ACPI 5.0 to be
available in order to merge this code).

Regards,
Srivatsa S. Bhat

