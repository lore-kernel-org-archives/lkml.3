Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaETHxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:53:18 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:48601 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaETHxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:53:15 -0400
Message-ID: <537B09DF.1090906@linux.vnet.ibm.com>
Date: Tue, 20 May 2014 13:23:03 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, x86@kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, riel@redhat.com, mgorman@suse.de, ak@linux.intel.com,
        peterz@infradead.org, mingo@kernel.org, dave.hansen@intel.com
Subject: Re: [PATCH V4 0/2] mm: FAULT_AROUND_ORDER patchset performance data
 for powerpc
References: <1399541296-18810-1-git-send-email-maddy@linux.vnet.ibm.com> <537479E7.90806@linux.vnet.ibm.com> <alpine.LSU.2.11.1405151026540.4664@eggly.anvils> <87wqdik4n5.fsf@rustcorp.com.au>	<53797511.1050409@linux.vnet.ibm.com> <alpine.LSU.2.11.1405191531150.1317@eggly.anvils> <20140519164301.eafd3dd288ccb88361ddcfc7@linux-foundation.org> <20140520004429.E660AE009B@blue.fi.intel.com> <87oaythsvk.fsf@rustcorp.com.au> <20140520003201.a2360d5d.akpm@linux-foundation.org>
In-Reply-To: <20140520003201.a2360d5d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052007-3864-0000-0000-00000E4DB63B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 01:02 PM, Andrew Morton wrote:
> On Tue, 20 May 2014 15:52:07 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>> "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> writes:
>>> Andrew Morton wrote:
>>>> On Mon, 19 May 2014 16:23:07 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
>>>>
>>>>> Shouldn't FAULT_AROUND_ORDER and fault_around_order be changed to be
>>>>> the order of the fault-around size in bytes, and fault_around_pages()
>>>>> use 1UL << (fault_around_order - PAGE_SHIFT)
>>>>
>>>> Yes.  And shame on me for missing it (this time!) at review.
>>>>
>>>> There's still time to fix this.  Patches, please.
>>>
>>> Here it is. Made at 3.30 AM, build tested only.
>>
>> Prefer on top of Maddy's patch which makes it always a variable, rather
>> than CONFIG_DEBUG_FS.  It's got enough hair as it is.
>>
> 
> We're at 3.15-rc5 and this interface should be finalised for 3.16.  So
> Kirrill's patch is pretty urgent and should come first.
> 
> Well.  It's only a debugfs interface at this stage so we are allowed to
> change it later, but it's better not to.
>
My patchset does not change the interface, but uses the current fault
around order variable from CONFIG_DEBUG_FS block to allow changes at
runtime, instead of having a constant and some cleanup.

Thanks for review
Regards
--Maddy



