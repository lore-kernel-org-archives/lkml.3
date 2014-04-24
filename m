Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbaDXRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:25:56 -0400
Received: from www.sr71.net ([198.145.64.142]:53014 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbaDXRZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:25:54 -0400
Message-ID: <53594920.8030203@sr71.net>
Date: Thu, 24 Apr 2014 10:25:52 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        ak@linux.intel.com, riel@redhat.com, alex.shi@linaro.org,
        dave.hansen@linux.intel.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 5/6] x86: mm: new tunable for single vs full TLB flush
References: <20140421182418.81CF7519@viggo.jf.intel.com> <20140421182426.D6DD1E8F@viggo.jf.intel.com> <20140424103727.GT23991@suse.de>
In-Reply-To: <20140424103727.GT23991@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 03:37 AM, Mel Gorman wrote:
> On Mon, Apr 21, 2014 at 11:24:26AM -0700, Dave Hansen wrote:
>> +This will cause us to do the global flush for more cases.
>> +Lowering it to 0 will disable the use of the individual flushes.
>> +Setting it to 1 is a very conservative setting and it should
>> +never need to be 0 under normal circumstances.
>> +
>> +Despite the fact that a single individual flush on x86 is
>> +guaranteed to flush a full 2MB, hugetlbfs always uses the full
>> +flushes.  THP is treated exactly the same as normal memory.
>> +
> 
> You are the second person that told me this and I felt the manual was
> unclear on this subject. I was told that it might be a documentation bug
> but because this discussion was in a bar I completely failed to follow up
> on it. Specifically this part in 4.10.2.3 caused me problems when I last
> looked at the area.
<snip>

My understanding comes from "4.10.4.2 Recommended Invalidation":

	• If software modifies a paging-structure entry that identifies
	the final page frame for a page number (either a PTE or a
	paging-structure entry in which the PS flag is 1), it should
	execute INVLPG for any linear address with a page number whose
	translation uses that PTE. 2

and especially the footnote:

	2. One execution of INVLPG is sufficient even for a page with
	size greater than 4 KBytes.

I do agree that it's ambiguous at best.  I'll go see if anybody cares to
update that bit.

