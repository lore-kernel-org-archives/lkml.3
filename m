Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaGHAns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:43:48 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50395 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaGHAnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:43:45 -0400
Message-ID: <53BB3EBC.8050005@linaro.org>
Date: Tue, 08 Jul 2014 08:43:40 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, Mel Gorman <mgorman@suse.de>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        ak@linux.intel.com, riel@redhat.com, dave.hansen@linux.intel.com,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 5/6] x86: mm: new tunable for single vs full TLB flush
References: <20140421182418.81CF7519@viggo.jf.intel.com> <20140421182426.D6DD1E8F@viggo.jf.intel.com> <20140424103727.GT23991@suse.de> <53BADC49.6000600@sr71.net>
In-Reply-To: <53BADC49.6000600@sr71.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 01:43 AM, Dave Hansen wrote:
> On 04/24/2014 03:37 AM, Mel Gorman wrote:
>>> +Despite the fact that a single individual flush on x86 is
>>>> +guaranteed to flush a full 2MB, hugetlbfs always uses the full
>>>> +flushes.  THP is treated exactly the same as normal memory.
>>>> +
>> You are the second person that told me this and I felt the manual was
>> unclear on this subject. I was told that it might be a documentation bug
>> but because this discussion was in a bar I completely failed to follow up
>> on it. 
> 
> For the record...  There's a new version of the Intel SDM out, and it
> contains some clarifications.  They're the easiest to find in this
> document which highlights the deltas from the last version:
> 
>> http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developers-manual.pdf
> 
> The documentation for invlpg itself has a new footnote, and there's also
> a little bit of new text in section "4.10.2.3 Details of TLB Use".
> 
> The footnotes say:
> 
> 	If the paging structures map the linear address using a page
> 	larger than 4 KBytes and there are multiple TLB entries for
> 	that page (see Section 4.10.2.3), the instruction (invlpg)
> 	invalidates all of them
> 
> I hope that clears up some of the ambiguity over invlpg.
> 

Uh, AFAICT, the invlpg on large page has no clear effect on data
retrieving, on all Intel CPU till ivybridge. No testing on later CPUs.

-- 
Thanks
    Alex
