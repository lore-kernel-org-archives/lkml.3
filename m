Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3BEW7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:59:34 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:34211 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab3BEW7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:59:33 -0500
Message-ID: <51118ECB.10006@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2013 14:59:23 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiang Liu <liuj97@gmail.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Wu Jianguo <wujianguo@huawei.com>, Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v2 0/9] mm: zone & pgdat accessors plus some cleanup
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com> <20130201163924.75edfe40.akpm@linux-foundation.org>
In-Reply-To: <20130201163924.75edfe40.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020522-5518-0000-0000-00000B5598F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 04:39 PM, Andrew Morton wrote:
> On Thu, 17 Jan 2013 14:52:52 -0800
> Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
>
>> Summaries:
>> 1 - avoid repeating checks for section in page flags by adding a define.
>> 2 - add & switch to zone_end_pfn() and zone_spans_pfn()
>> 3 - adds zone_is_initialized() & zone_is_empty()
>> 4 - adds a VM_BUG using zone_is_initialized() in __free_one_page()
>> 5 - add pgdat_end_pfn() and pgdat_is_empty()
>> 6 - add debugging message to VM_BUG check.
>> 7 - add ensure_zone_is_initialized() (for memory_hotplug)
>> 8 - use the above addition in memory_hotplug
>> 9 - use pgdat_end_pfn()
>
> Well that's a nice little patchset.
>
> Some of the patches were marked From:cody@linux.vnet.ibm.com and others
> were From:jmesmon@gmail.com.  This is strange.  If you want me to fix
> that up, please let me know which is preferred.

They should all be "From:cody@linux.vnet.ibm.com", other address was me 
messing up gitconfig (which I've since fixed).

>> As a general concern: spanned_pages & start_pfn (in pgdat & zone) are supposed
>> to be locked (via a seqlock) when read (due to changes to them via
>> memory_hotplug), but very few (only 1?) of their users appear to actually lock
>> them.
>
> OK, thanks.  Perhaps this is something which the memory-hotplug
> developers could take a look at?

Yep. It's not immediately clear that not locking on read would do 
terrible things, but at the least the documentation needs fixing and 
explanation as to why the locking is not used some (or all) places.

